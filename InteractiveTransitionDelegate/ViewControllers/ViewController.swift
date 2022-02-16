import UIKit

class ViewController: UIViewController {

    private var trDelegate: UIViewControllerTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton().apply {
            $0.setTitle("Tap me", for: [])
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.cornerRadius = 4
            $0.setTitleColor(.blue, for: [])
        }
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc
    private func buttonDidTap(_ sender: UIControl) {
        trDelegate = TransitionDelegate()
        let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [.interPageSpacing: 20]).apply {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = trDelegate
        }
        present(vc, animated: true, completion: .none)
    }
}

