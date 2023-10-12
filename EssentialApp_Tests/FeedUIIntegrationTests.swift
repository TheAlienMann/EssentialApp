import Foundation
import XCTest
import EssentialFeed
import EssentialFeediOS
import EssentialApp_

class FeedUIIntegrationTests: XCTestCase {
  func test_feedView_hasTitle() {
    let (sut, _) = makeSUT()
    
    sut.loadViewIfNeeded()
    
    XCTAssertEqual(sut.title, feedTitle)
  }
  
  func test_imageSelection_notifiesHandler() {
    let image0 = makeImage()
    let image1 = makeImage()
    var selectedImages = [FeedImage]()
    let (sut, loader) = makeSUT(selection: { selectedImages.append($0) })
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1], at: 0)
    
    sut.simulateTapOnFeedImage(at: 0)
    XCTAssertEqual(selectedImages, [image0])
    
    sut.simulateTapOnFeedImage(at: 1)
    XCTAssertEqual(selectedImages, [image0, image1])
  }
  
  func test_loadFeedActions_requestFeedFromLoader() {
    let (sut, loader) = makeSUT()
    XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded.")
    
    sut.loadViewIfNeeded()
    XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded.")
    
    sut.simulateUserInitiatedReload()
    XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected no request until previous completes.")
    
    loader.completeFeedLoading(at: 0)
    sut.simulateUserInitiatedReload()
    XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a reload.")
    
    loader.completeFeedLoading(at: 1)
    sut.simulateUserInitiatedReload()
    XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected another loading request once user initiates another reload.")
  }
  
  func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded.")
    
    loader.completeFeedLoading(at: 0)
    XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully.")
    
    sut.simulateUserInitiatedReload()
    XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicaator once user initiates a reload.")
    
    loader.completeFeedLoadingWithError(at: 1)
    XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicaator once user initiates loading completes with error.")
  }
  
  func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
    let image0 = makeImage(description: "a description", location: "a location")
    let image1 = makeImage(description: nil, location: "another location")
    let image2 = makeImage(description: "another description", location: nil)
    let image3 = makeImage(description: nil, location: nil)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    assertThat(sut, isRendering: [])
    
    loader.completeFeedLoading(with: [image0, image1], at: 0)
    assertThat(sut, isRendering: [image0, image1])
    
    sut.simulateLoadMoreFeedAction()
    loader.completeLoadMore(with: [image0, image1, image2, image3], at: 0)
    assertThat(sut, isRendering: [image0, image1, image2, image3])
    
    sut.simulateUserInitiatedReload()
    loader.completeFeedLoading(with: [image0, image1], at: 1)
    assertThat(sut, isRendering: [image0, image1])
  }
  
  func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
    let image0 = makeImage()
    let image1 = makeImage()
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0], at: 0)
    assertThat(sut, isRendering: [image0])
    
    sut.simulateLoadMoreFeedAction()
    loader.completeLoadMore(with: [image0, image1], at: 0)
    assertThat(sut, isRendering: [image0, image1])
    
    sut.simulateUserInitiatedReload()
    loader.completeFeedLoading(with: [], at: 1)
    assertThat(sut, isRendering: [])
  }
  
  func test_loadFeedCompletion_doesNotAlertCurrentRenderingStateOnError() {
    let image0 = makeImage()
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0], at: 0)
    assertThat(sut, isRendering: [image0])
    
    sut.simulateUserInitiatedReload()
    loader.completeFeedLoadingWithError(at: 1)
    assertThat(sut, isRendering: [image0])
    
    sut.simulateLoadMoreFeedAction()
    loader.completeLoadMoreWithError(at: 0)
    assertThat(sut, isRendering: [image0])
  }
  
  func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    
    let exp = expectation(description: "Wait for background queue.")
    DispatchQueue.global().async {
      loader.completeFeedLoading(at: 0)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.errorMessage, nil)
    
    loader.completeFeedLoadingWithError(at: 0)
    XCTAssertEqual(sut.errorMessage, loadError)
    
    sut.simulateUserInitiatedReload()
    XCTAssertEqual(sut.errorMessage, nil)
  }
  
  func test_tapOnErrorView_hidesErrorMessage() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    
    XCTAssertEqual(sut.errorMessage, nil)
    
    loader.completeFeedLoadingWithError(at: 0)
    XCTAssertEqual(sut.errorMessage, loadError)
    
    sut.simulateErrorViewTap()
    XCTAssertEqual(sut.errorMessage, nil)
  }
  
  // MARK: - Load More Tests
  
  func test_loadMoreActions_requestMoreFromLoader() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    loader.completeFeedLoading()
    
    XCTAssertEqual(loader.loadMoreCallCount, 0, "Expected no requests before until load more action.")
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected load more request.")
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected no request while loading more.")
    
    loader.completeLoadMore(lastPage: false, at: 0)
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 2, "Expected request after load more completed with more pages.")
    
    loader.completeLoadMoreWithError(at: 1)
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected request after load more failure.")
    
    loader.completeLoadMore(lastPage: true, at: 2)
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected no request after loading all pages.")
  }
  
  func test_loadingMoreIndicator_isVisibleWhileLoadingMore() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once view is loaded.")
    
    loader.completeFeedLoading(at: 0)
    XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once view completes successfully.")
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on load more action.")
    
    loader.completeLoadMore(at: 0)
    XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once user initiated loading completes successfully.")
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on second load more action.")
    
    loader.completeLoadMoreWithError(at: 1)
    XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once user initiated loading completes with error.")
  }
  
  func test_loadMoreCompletion_dispatchesFromBackgroundToMainThread() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(at: 0)
    sut.simulateLoadMoreFeedAction()
    
    let exp = expectation(description: "Wait for background queue.")
    DispatchQueue.global().async {
      loader.completeLoadMore()
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_loadMoreCompletion_rendersErrorMessageOnError() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    loader.completeFeedLoading()
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(sut.loadMoreFeedErrorMessage, nil)
    
    loader.completeLoadMoreWithError()
    XCTAssertEqual(sut.loadMoreFeedErrorMessage, loadError)
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(sut.loadMoreFeedErrorMessage, nil)
  }
  
  func test_tapOnLoadMoreErrorView_loadMore() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    loader.completeFeedLoading()
    
    sut.simulateLoadMoreFeedAction()
    XCTAssertEqual(loader.loadMoreCallCount, 1)
    
    sut.simulateTapOnLoadMoreFeedError()
    XCTAssertEqual(loader.loadMoreCallCount, 1)
    
    loader.completeLoadMoreWithError()
    sut.simulateTapOnLoadMoreFeedError()
    XCTAssertEqual(loader.loadMoreCallCount, 2)
  }
  
  func test_feedImageView_loadsImageURLWhenVisible() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    
    XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible.")
    
    sut.simulateFeedImageViewVisible(at: 0)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first view becomes visible.")
    
    sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once first view becomes visible.")
  }
  
  func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    
    XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible.")
    
    sut.simulateFeedImageViewNotVisible(at: 0)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected one cancelled image URL request once first image is not visible anymore.")
    
    sut.simulateFeedImageViewNotVisible(at: 1)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected two cancelled image URL request once second image is not visible anymore.")
  }
  
  
  func test_feedImageView_reloadsImageURLWhenBecomsVisibleAgain() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    
    sut.simulateFeedImageBecomingVisibleAgain(at: 0)
    
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image0.url], "Expected two image URL requests after first view becomes visible again.")
    
    sut.simulateFeedImageBecomingVisibleAgain(at: 1)
    
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image0.url, image1.url, image1.url], "Expected two new image URL requests after second view becomes visible again.")
  }
  
  func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage(), makeImage()])
    
    let view0 = sut.simulateFeedImageViewVisible(at: 0)
    let view1 = sut.simulateFeedImageViewVisible(at: 1)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    selection: @escaping (FeedImage) -> Void = { _ in },
    file: StaticString = #file,
    line: UInt = #line
  ) -> (sut: ListViewController<FeedImageCell>, loader: LoaderSpy) {
    let loader = LoaderSpy()
    let sut = FeedUIComposer.feedComposedWith(
      feedLoader: loader.loadPublisher,
      imageLoader: loader.loadImageDataPublisher,
      selection: selection)
    trackForMemoryLeaks(loader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, loader)
  }
  
  private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "https://any-url.com")!) -> FeedImage {
    return FeedImage(id: UUID(), description: description, location: location, url: url)
  }
  
  private func anyImageData() -> Data {
    return UIImage.make(withColor: .red).pngData()!
  }
}
