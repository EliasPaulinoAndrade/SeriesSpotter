import XCTest
@testable import SerieSpotter

final class SeriesListingPresenterTests: XCTestCase {
    func testPresentLoading_ShouldChangeState() async {
        let (sut, doubles) = makeSut()
        
        await sut.presentLoading()
        
        XCTAssertEqual(doubles.viewStateSpy.listState, .presentingLoading)
    }
    
    func testPresentError_ShouldChangeState() async {
        let (sut, doubles) = makeSut()
        
        await sut.presentError()
        
        XCTAssertEqual(doubles.viewStateSpy.listState, .presentingError)
    }
    
    func testPresentEmptyState_ShouldChangeState() async {
        let (sut, doubles) = makeSut()
        
        await sut.presentEmptyState()
        
        XCTAssertEqual(doubles.viewStateSpy.listState, .presentingEmptyState)
    }
    
    func testPresentSerieDetail_ShouldChangeState() async {
        let (sut, doubles) = makeSut()
        let serieStub = Serie.fixture()
        
        await sut.presentSerieDetail(serie: serieStub)
        
        XCTAssertEqual(doubles.navigationStateSpy.isPresentingSerie, true)
        XCTAssertEqual(doubles.navigationStateSpy.presentingSerie, serieStub)
    }
    
    func testPresentSeries_ShouldChangeState() async {
        let (sut, doubles) = makeSut()
        let seriesStub = [Serie.fixture(id: 1), Serie.fixture(id: 2)]
        let excpectedViewModels = [
            ListableSerieViewModel(id: 1, name: "name", imageUrl: nil),
            ListableSerieViewModel(id: 2, name: "name", imageUrl: nil)
        ]
        
        await sut.presentSeries(series: seriesStub)
        
        XCTAssertEqual(doubles.viewStateSpy.listState, .presentingSeries(excpectedViewModels))
    }
}

private extension SeriesListingPresenterTests {
    typealias Doubles = (
        viewStateSpy: SeriesListingViewStatingSpy,
        navigationStateSpy: SeriesListingNavigationStatingSpy
    )
    
    func makeSut() -> (SeriesListingPresenter, Doubles) {
        let viewStateSpy = SeriesListingViewStatingSpy()
        let navigationStateSpy = SeriesListingNavigationStatingSpy()
        
        let sut = SeriesListingPresenter(viewState: viewStateSpy, navigationState: navigationStateSpy)
        
        return (sut, (viewStateSpy, navigationStateSpy))
    }
}
