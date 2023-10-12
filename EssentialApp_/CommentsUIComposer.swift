import Foundation
import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
  private init() {}
  
  private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>
  
  public static func commentsComposedWith(
    commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
  ) -> ListViewController<ImageCommentCell> {
    let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
    
    let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
    commentsController.onRefresh = presentationAdapter.loadResource
    
    presentationAdapter.presenter = LoadResourcePresenter(
      resourceView: CommentsViewAdapter(controller: commentsController),
      loadingView: WeakRefVirtualProxy(commentsController),
      errorView: WeakRefVirtualProxy(commentsController),
      mapper: { ImageCommentsPresenter.map($0) })
    
    return commentsController
  }
  
  private static func makeCommentsViewController(title: String) -> ListViewController<ImageCommentCell> {
    //    let bundle = Bundle(for: ListViewController.self)
    //    let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
    //    let controller = storyboard.instantiateInitialViewController() as! ListViewController
    let controller = ListViewController<ImageCommentCell>(ImageCommentCell())
    controller.title = title
    return controller
  }
}

final class CommentsViewAdapter: ResourceView {
  private weak var controller: ListViewController<ImageCommentCell>?
  
  init(controller: ListViewController<ImageCommentCell>) {
    self.controller = controller
  }
  
  func display(_ viewModel: ImageCommentsViewModel) {
    controller?.display(viewModel.comments.map { viewModel in
      CellController(id: viewModel, ImageCommentCellController(model: viewModel))
    })
  }
}
