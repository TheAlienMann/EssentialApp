import Foundation
import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
  private init() { }
  
  private typealias FeedPresentationAdaper = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
  
  public static func feedComposedWith(
    feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
    imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
    selection: @escaping (FeedImage) -> Void = { _ in }
  ) -> ListViewController<FeedImageCell> {
    let presentationAdapter = FeedPresentationAdaper(loader: feedLoader)
    
    let feedController = makeFeedViewController(title: FeedPresenter.title)
    feedController.onRefresh = presentationAdapter.loadResource
    
    presentationAdapter.presenter = LoadResourcePresenter(
      resourceView: FeedViewAdapter(
        controller: feedController,
        imageLoader: imageLoader,
        selection: selection),
      loadingView: WeakRefVirtualProxy(feedController),
      errorView: WeakRefVirtualProxy(feedController))
    
    return feedController
  }
  
  private static func makeFeedViewController(title: String) -> ListViewController<FeedImageCell> {
    //    let bundle = Bundle(for: ListViewController.self)
    //    let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
    //    let feedController = storyboard.instantiateInitialViewController() as! ListViewController
    let feedController = ListViewController<FeedImageCell>(FeedImageCell())
    feedController.title = title
    return feedController
  }
}
