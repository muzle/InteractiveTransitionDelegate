import Foundation
import UIKit

@objc public protocol CustomPresentedViewController {
    @objc optional func getScrollView() -> UIScrollView?
    @objc optional func canBeDismissedUsingInteration() -> Bool
}

internal extension UIViewController {
    func asCustomPresentedViewController() -> CustomPresentedViewController? {
        self as? CustomPresentedViewController
    }
}
