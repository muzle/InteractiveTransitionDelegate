import UIKit

final class PageViewController: UIPageViewController {
    
    private let colors: [UIColor] = (0...5).map { _ in UIColor.random }
    private var currentIndex = 0
    private var buffer = [Int: UIViewController]()
    private var pageViewControllerTransitionInProgress = false
    private lazy var scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let scene = makeScene(for: currentIndex) {
            setViewControllers([scene], direction: .forward, animated: true, completion: .none)
        }
    }
}

// MARK: - Implement UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = buffer.first(where: { $0.value === viewController })?.key ?? 0
        return makeScene(for: index - 1)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = buffer.first(where: { $0.value === viewController })?.key ?? 0
        return makeScene(for: index + 1)
    }
}

// MARK: - Implement UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            completed,
            let vc = pageViewController.viewControllers?.first,
            let index = buffer.first(where: { $0.value === vc })?.key
        else { return }
        currentIndex = index
    }
}

// MARK: - Helpers

private extension PageViewController {
    private func makeScene(for index: Int) -> UIViewController? {
        if let vc = buffer[index] {
            return vc
        }
        if
            colors.indices.contains(index) {
            let vc = ScrollViewController().apply {
                $0.view.backgroundColor = colors[index]
            }
            buffer[index] = vc
            return vc
        }
        return nil
    }
}

// MARK: - Implement CustomPresentedViewController

extension PageViewController: CustomPresentedViewController {
    func getScrollView() -> UIScrollView? {
        (buffer[currentIndex] as? CustomPresentedViewController)?.getScrollView?()
    }
    
    func canBeDismissedUsingInteration() -> Bool {
        if
            let canBeDismissedUsingInteration = (buffer[currentIndex] as? CustomPresentedViewController)?.canBeDismissedUsingInteration?(),
            !canBeDismissedUsingInteration {
            return false
        }
        if let state = scrollView?.panGestureRecognizer.state {
            switch state {
            case .began, .changed:
                return false
            case .possible, .ended, .cancelled, .failed:
                return true
            @unknown default:
                return true
            }
        }
        return true
    }
}

// MARK: - UIColor extension for testing

private extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIPanGestureRecognizer.State {
    var name: String {
        switch self {
        case .possible:
            return "posible"
        case .began:
            return "began"
        case .changed:
            return "changed"
        case .ended:
            return "ended"
        case .cancelled:
            return "cancelled"
        case .failed:
            return "failed"
        @unknown default:
            return "default"
        }
    }
}
