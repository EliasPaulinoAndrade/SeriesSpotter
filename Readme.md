# Series Spotter

## Architecture

### UI Pattern

I have used the VIP (View-Interactor-Presenter) UI Pattern in this project. The main idea is to split the logic into three layers: UI, Presentation, and Business Logic. This approach makes the Presentation and Logic layers more testable and splits the responsibility of formatting data for presentation from the main logic of the screen.


UI -> UI Events -> Interactor -> Presenter -> Update UI

Interactor -> Services, Workers, Data Sources
Presenter -> Formatters, Coordinators


The UI layer delegates the handling of user events to the interactor. The interactor executes any business logic related to these events, such as networking, persistence, and pagination. For this purpose, the interactor can depend on other layers of code responsible for specific tasks, such as a layer for local persistence and layers for specifying and making requests to an API. After handling the logic, the interactor delegates the presentation of the data to the presenter, which receives the data and transforms it into pure view models to be presented to the view. The presenter then delegates the rendering of the formatted data to the view, closing the VIP cycle.

### Clean Architecture

I adopted a clean architecture approach. The screen's business logic is centralized in the interactor and model layers. Data logic resides in the data layer, within the data sources and services. The UI logic is contained within the views, presenters, and other UI-related objects.

1. The Interactor contains the main logic and should not depend on specific UI or Data logic.
2. The interactor can depend on other layers to reuse business logic between screens.
3. The Data layer can depend on business logic models, and it needs to translate the DTO models to pure models, which the interactor can use freely.
4. The UI layer can also depend on business logic models, but the view models cannot be sent directly to the interactor.
5. The UI and Data layers are independent and linked through dependency injection in the factory.
6. All layers have inverted dependencies to ensure testability.

## UI Framework

I chose to use SwiftUI for this project since I had no minimum target limitations, allowing me to leverage all the current power of SwiftUI. I aimed to decouple all the important logic from the view layer by using the architecture patterns described before, thus keeping the view layer simple, focused on building the screen.

## Persistence

For persistence, I used SwiftData, in this case, just for saving the favorite series locally, and it's all abstracted in the data source layers. In case the persistence framework changes, I can simply change the persistence layer logic, respecting the SOLID separation of concerns.

## Networking

I implemented a networking layer using the new concurrency tools: async, await, and Tasks. It's inside the NetworkingLayer folder. It's very basic and just uses URLSession as usual.

## Unit Testing

For unit testing, I used the XCTest framework. I needed to implement some assertions for dealing with async code, which can be found in the tests target.

## Features

1. The user can list all the series and scroll through them.
2. The user can view detailed information about a series.
3. The user can list all episodes of a series.
4. The user can view information about a specific episode.
5. The user can mark a specific series as a favorite from the detail screen.

## Next Steps

1. Implement a screen listing the series marked as favorites.

## How to Run the App

1. Have Xcode 15.3 installed.
2. Run the app normally; it has no third-party frameworks.
