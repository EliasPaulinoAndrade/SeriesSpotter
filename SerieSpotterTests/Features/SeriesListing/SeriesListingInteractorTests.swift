import XCTest
@testable import SerieSpotter

final class SeriesListingInteractorTests: XCTestCase {
    func testStarted_WhenServiceFail_ShouldPresentError() async {
        let (sut, doubles) = makeSut()
        
        doubles.listServiceMock.expectedReturn = .failure(RequestError.noResponse)
        
        await sut.started()
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentError
        ])
    }
    
    func testStarted_WhenServiceSucceed_ShouldPresentSeries() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(), .fixture()]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.started()
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testStarted_ShouldLoadFirstPage() async {
        let (sut, doubles) = makeSut()
        
        await sut.started()
        
        XCTAssertEqual(doubles.listServiceMock.receivedPages, [0])
    }
    
    func testShowedSerie_WhenDidntShowLastSerie_ShouldNotLoadNextPage() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1), .fixture(id: 2)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.started()
        await sut.showedSerie(with: 1)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testShowedSerie_WhenDidntLoadFirstPage_ShouldNotLoadSecond() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.showedSerie(with: 1)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [])
    }
    
    func testShowedSerie_WhenServiceFail_ShouldNotLoadNextPage() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.started()
        
        doubles.listServiceMock.expectedReturn = .failure(RequestError.noResponse)
        
        await sut.showedSerie(with: 1)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub),
            .presentError
        ])
    }
    
    func testShowedSerie_WhenServiceSucceed_ShouldNotLoadNextPage() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        let secondPageSeries: [Serie] = [.fixture(id: 2)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.started()
        
        doubles.listServiceMock.expectedReturn = .success(secondPageSeries)
        
        await sut.showedSerie(with: 1)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub),
            .presentSeries(seriesStub + secondPageSeries)
        ])
    }
    
    func testShowedSerie_ShouldLoadNextPage() async {
        let (sut, doubles) = makeSut()
        
        doubles.listServiceMock.expectedReturn = .success([.fixture()])
        
        await sut.started()
        await sut.showedSerie(with: 1)
        
        XCTAssertEqual(doubles.listServiceMock.receivedPages, [0, 1])
    }
    
    func testChangedSearch_WhenQueryIsEmpty_ShouldNotSearch() async {
        let (sut, doubles) = makeSut()
        
        await sut.changedSearch(query: "")
        
        XCTAssertEqual(doubles.presenterSpy.messages, [])
    }
    
    func testChangedSearch_WhenServiceFail_ShouldPresentError() async {
        let (sut, doubles) = makeSut()
        
        doubles.searchServiceMock.expectedReturn = .failure(RequestError.noResponse)
        
        await sut.changedSearch(query: ".")
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentError
        ])
    }
    
    func testChangedSearch_WhenServiceSucceedWithNoData_ShouldPresentEmptyState() async {
        let (sut, doubles) = makeSut()
        
        doubles.searchServiceMock.expectedReturn = .success([])
        
        await sut.changedSearch(query: ".")
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentEmptyState
        ])
    }
    
    func testChangedSearch_WhenServiceSucceed_ShouldPresentSeries() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.searchServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.changedSearch(query: ".")
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testChangedSearch_WhenHadLoadedPage_ShouldCleanOldData() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        let searchedSeriesStub: [Serie] = [.fixture(id: 2)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        doubles.searchServiceMock.expectedReturn = .success(searchedSeriesStub)
        
        await sut.started()
        await sut.changedSearch(query: ".")
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub),
            .presentLoading,
            .presentSeries(searchedSeriesStub)
        ])
    }
    
    func testToggledSearch_WhenOpenedSearch_ShouldNotReloadInitialPage() async {
        let (sut, doubles) = makeSut()
        
        await sut.toggledSearch(isSearching: true)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [])
    }
    
    func testToggledSearch_WhenClosedSearch_ButStillHasInitalPageLoaded_ShouldNotReloadInitialPage() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.started()
        await sut.toggledSearch(isSearching: false)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testToggledSearch_WhenServiceFail_ShouldPresentError() async {
        let (sut, doubles) = makeSut()
        
        doubles.listServiceMock.expectedReturn = .failure(RequestError.noResponse)
        
        await sut.toggledSearch(isSearching: false)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentError
        ])
    }
    
    func testToggledSearch_WhenServiceSucceed_ShouldPresentSeries() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.toggledSearch(isSearching: false)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testSelectedRetry_ShouldRedoRequest() async {
        let (sut, doubles) = makeSut()
        let seriesStub: [Serie] = [.fixture(id: 1)]
        
        doubles.listServiceMock.expectedReturn = .failure(RequestError.noResponse)
        
        await sut.started()
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
        
        await sut.selectedRetry()
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentError,
            .presentLoading,
            .presentSeries(seriesStub)
        ])
    }
    
    func testSelectedSerie_WhenSerieIdIsValid_ShouldPresentDetail() async {
        let (sut, doubles) = makeSut()
        let serieStub = Serie.fixture(id: 1)
        let seriesStub = [serieStub]
        
        doubles.listServiceMock.expectedReturn = .success(seriesStub)
    
        await sut.started()
        await sut.selectedSerie(with: 1)
        
        XCTAssertEqual(doubles.presenterSpy.messages, [
            .presentLoading,
            .presentSeries(seriesStub),
            .presentSerieDetail(serieStub)
        ])
    }
}

private extension SeriesListingInteractorTests {
    typealias Doubles = (
        presenterSpy: SeriesListingPresentingSpy,
        listServiceMock: SeriesListingServicingMock,
        searchServiceMock: SeriesSearchingServicingMock
    )
    
    func makeSut() -> (SeriesListingInteractor, Doubles) {
        let presenterSpy = SeriesListingPresentingSpy()
        let listServiceMock = SeriesListingServicingMock()
        let searchServiceMock = SeriesSearchingServicingMock()
        
        let sut = SeriesListingInteractor(
            presenter: presenterSpy,
            listService: listServiceMock,
            searchService: searchServiceMock
        )
        
        return (sut, (presenterSpy, listServiceMock, searchServiceMock))
    }
}
