import Foundation
import UIKit
import EssentialFeediOS

extension FeedImageCell {
  func simulateRetryAction() {
    feedImageRetryButton.simulateTap()
  }
  
  var isShowingLocation: Bool {
    return !locationContainerStackView.isHidden
  }
  
  var isShowingImageLoadingIndicator: Bool {
    return feedImageContainer.isShimmering
  }
  
  var isShowingRetryAction: Bool {
    return !feedImageRetryButton.isHidden
  }
  
  var locationText: String? {
    return locationLabel.text
  }
  
  var descriptionText: String? {
    return descriptionLabel.text
  }
  
  var renderedImage: Data? {
    return feedImageView.image?.pngData()
  }
}
