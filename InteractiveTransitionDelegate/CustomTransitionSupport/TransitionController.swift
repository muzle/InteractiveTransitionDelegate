import UIKit

internal final class TransitionController: UIPresentationController {
    private var dissmissInProgress = false
    weak var transitionManager: TransitionManager?
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        containerView?.bounds ?? UIScreen.main.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard !dissmissInProgress else { return }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed { transitionManager?.presentationTransitionDidEnd = true }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        dissmissInProgress = true
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        dissmissInProgress = false
    }
    
    private func transitionAnimation(_ closure: @escaping () -> Void) {
        guard let coordinator = presentedViewController.transitionCoordinator else { closure(); return }
        coordinator.animate(
            alongsideTransition: { (_) in closure() },
            completion: nil
        )
    }
}
