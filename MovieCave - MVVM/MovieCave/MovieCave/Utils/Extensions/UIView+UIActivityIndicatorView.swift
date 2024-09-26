import UIKit

// MARK: - SpinnerProtocol + extension
protocol SpinnerProtocol where Self: UIViewController {
    
    /// Description - The spinner view that will be added and removed from the view hierarchy.
    var spinnerView: UIView? { get set }
    
    /// Description - Shows a spinner view with a loading animation in the center of the screen.
    func showSpinner()

    /// Description - /// Removes the spinner view from the view hierarchy.
    func removeSpinner()
}

extension SpinnerProtocol {

    func showSpinner() {
        spinnerView = UIView(frame: view.bounds)
        spinnerView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = view.center
        ai.startAnimating()
        ai.color = .white
        spinnerView?.addSubview(ai)
        view.addSubview(spinnerView!)
    }

    func removeSpinner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = nil
        }
    }
}
