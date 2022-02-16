import UIKit

class ScrollViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let contentView = UIView().apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).apply {
                $0.priority = .defaultLow
            },
        ])
        
        let topLabel = UILabel().apply {
            $0.text = "Top label"
        }
        let bottomLabel = UILabel().apply {
            $0.text = "Bootom label"
        }
        
        [topLabel, bottomLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .blue
        }
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            bottomLabel.topAnchor.constraint(greaterThanOrEqualTo: topLabel.bottomAnchor, constant: 1200),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: - Implement CustomPresentedViewController

extension ScrollViewController: CustomPresentedViewController {
    func getScrollView() -> UIScrollView? {
        scrollView
    }
}
