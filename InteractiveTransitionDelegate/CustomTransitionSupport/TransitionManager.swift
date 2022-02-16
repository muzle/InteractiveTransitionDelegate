import UIKit

internal final class TransitionManager: UIPercentDrivenInteractiveTransition {
    private weak var presentedViewController: UIViewController?
    private weak var pan: UIPanGestureRecognizer?
    private lazy var decelerationRate = UIScrollView.DecelerationRate.fast.rawValue
    
    var presentationTransitionDidEnd = false
    
    private(set) var panHasStarted = false
    private var touchByRegisteredView = false
    
    override var wantsInteractiveStart: Bool {
        get { presentationTransitionDidEnd ? pan?.state == .began : false }
        set { }
    }
    
    func bind(viewController: UIViewController) {
        presentationTransitionDidEnd = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))).apply {
            $0.maximumNumberOfTouches = 1
            $0.cancelsTouchesInView = false
            $0.delegate = self
        }
        self.pan = pan
        viewController.view.addGestureRecognizer(pan)
        self.presentedViewController = viewController
    }
    
    private var presentedViewFrame: CGRect {
        return presentedViewController?.view.frame ?? .zero
    }
    
    var popupMax: CGFloat {
        presentedViewFrame.height
    }
    
    func scrollViewCanBeDissmised() -> Bool {
        guard let scrollView = presentedViewController?.asCustomPresentedViewController()?.getScrollView?() else { return true }
        scrollView.bounces = (scrollView.contentOffset.y > 0)
        return scrollView.contentOffset.y <= 0
    }
}

// MARK: - Pan handling

private extension TransitionManager {
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard presentedViewController?.asCustomPresentedViewController()?.canBeDismissedUsingInteration?() != false else { return }
        presentationTransitionDidEnd ? handleDissmiss(sender) : handlePresentation(sender)
    }
    
    func handlePresentation(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            pause()
            
        case .changed:
            let increment = -translationProgress(sender, popupMax: popupMax)
            update(percentComplete + increment)
            
        case .ended, .cancelled:
            let projection = projectionPoint(sender, decelerationRate: decelerationRate)
            checkForDissmiss(project: projection, midleY: popupMax, percentComplete: 1 - percentComplete) ? cancel() : finish()
            
        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    func handleDissmiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            pause()
            panHasStarted = true
            if percentComplete == 0 {
                presentedViewController?.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            guard scrollViewCanBeDissmised() || touchByRegisteredView else {
                sender.setTranslation(.zero, in: sender.view)
                return
            }
            let progress = translationProgress(sender, popupMax: popupMax)
            update(percentComplete + progress)
            
        case .ended, .cancelled:
            guard scrollViewCanBeDissmised() else { cancel(); return }
            panHasStarted = false
            let projection = projectionPoint(
                sender,
                decelerationRate: decelerationRate,
                locationYOffset: popupMax
            )
            
            let shouldDissmiss = checkForDissmiss(
                project: projection,
                midleY: (presentedViewFrame.height / 2) + presentedViewFrame.minY,
                percentComplete: percentComplete
            )
            shouldDissmiss ? finish() : cancel()
            
        case .failed:
            panHasStarted = false
            cancel()
            
        default:
            break
        }
    }
    
    func checkForDissmiss(
        project: CGPoint,
        midleY: CGFloat,
        percentComplete: CGFloat
    ) -> Bool {
        project.y > (midleY / 2) || percentComplete > 0.5
    }
    
    func translationProgress(
        _ pan: UIPanGestureRecognizer,
        popupMax max: CGFloat
    ) -> CGFloat {
        let offset = pan.translation(in: pan.view).y / max
        pan.setTranslation(.zero, in: pan.view)
        return offset
    }
    
    func projectionPoint(
        _ pan: UIPanGestureRecognizer,
        decelerationRate: CGFloat,
        locationYOffset yOffset: CGFloat = 0
    ) -> CGPoint {
        let velocity = pan.velocity(in: pan.view)
        let location = pan.location(in: pan.view)
        let loc = CGPoint(x: location.x, y: yOffset + location.y)
        let project = loc - velocity / (1000 * log(decelerationRate))
        return project
    }
}

// MARK: - Implement UIGestureRecognizerDelegate

extension TransitionManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        true
    }
}
