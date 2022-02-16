import Foundation
import UIKit

public class TransitionDelegate: NSObject {
    
    private let presentionAnimationDuration: TimeInterval
    private let dissmissAnimationDuration: TimeInterval
    private let transitionManager: TransitionManager
    
    public init(
        presentionAnimationDuration: TimeInterval = 0.3,
        dissmissAnimationDuration: TimeInterval = 0.3
    ) {
        self.presentionAnimationDuration = presentionAnimationDuration
        self.dissmissAnimationDuration = dissmissAnimationDuration
        transitionManager = TransitionManager()
        super.init()
    }
}

// MARK: - Implement UIViewControllerTransitioningDelegate

extension TransitionDelegate: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        transitionManager.bind(viewController: presented)
        return TransitionController(
            presentedViewController: presented,
            presenting: presenting ?? source
        ).apply {
            $0.transitionManager = transitionManager
        }
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        AnimatedTransitioning(
            duration: presentionAnimationDuration,
            presentationDirection: .present
        )
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        AnimatedTransitioning(
            duration: dissmissAnimationDuration,
            presentationDirection: .dissmiss
        )
    }
    
    public func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        transitionManager
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        transitionManager
    }
}
