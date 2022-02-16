import UIKit

internal final class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let presentationDirection: TransitioningAnimationDirection
    
    init(
        duration: TimeInterval,
        presentationDirection: TransitioningAnimationDirection
    ) {
        self.duration = duration
        self.presentationDirection = presentationDirection
        super.init()
    }
    
    private func makeAnimator(
        context: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let view = context.view(forKey: presentationDirection == .present ? .to : .from)!
        let vc = context.viewController(forKey: presentationDirection == .present ? .to : .from)!
        let frame = presentationDirection == .present ? context.finalFrame(for: vc) : context.initialFrame(for: vc)
        
        let height = frame.height
        let yOffset = height
        
        if presentationDirection == .present {
            view.frame = frame.offsetBy(dx: 0, dy: yOffset)
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            view.frame = self.presentationDirection == .present ? frame : frame.offsetBy(dx: 0, dy: yOffset)
        }
        
        animator.addCompletion { (_) in
            context.completeTransition(!context.transitionWasCancelled)
        }
        
        return animator
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        makeAnimator(context: transitionContext).startAnimation()
    }
    
    func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        makeAnimator(context: transitionContext)
    }
}
