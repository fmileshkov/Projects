//
//  PopUpView.swift
//  MovieCave
//
//  Created by Admin on 27.10.23.
//

import UIKit

struct PopUpViewConstants {
    static let popUpViewHideAnimationTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    static let popUpViewHideAnimationAlpha: CGFloat = 0.2
    static let popUpViewHideAnimationDuration: TimeInterval = 0.3
    static let popUpViewDismissTimeInterval: TimeInterval = 3
    static let popUpViewFrameY: CGFloat = 0
    static let popUpViewFrameX: CGFloat = 0
}

class PopUpView: UIView {

    //MARK: - IBOutlets
    @IBOutlet private weak var messageLabel: UILabel!
    
    //MARK: - Properties
    private var autoDismissTimer: Timer?
    
    //MARK: - Intializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, inVC: UIViewController, messageLabelText: String) {
        super.init(frame: frame)
        guard let view = loadViewFromNib(nibName: Constants.popUpViewNibName) else { return }
        view.frame = CGRect(x: PopUpViewConstants.popUpViewFrameX, y: PopUpViewConstants.popUpViewFrameY, width: frame.width, height: frame.height)
        addSubview(view)
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: PopUpViewConstants.popUpViewDismissTimeInterval, repeats: false, block: { [weak self] _ in
          self?.hide()
        })
        messageLabel.text = messageLabelText
    }
    
    //MARK: - Methods
    private func hide() {
        UIView.animate(withDuration: PopUpViewConstants.popUpViewHideAnimationDuration, animations: {
            self.alpha = PopUpViewConstants.popUpViewHideAnimationAlpha
            self.transform = PopUpViewConstants.popUpViewHideAnimationTransform
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        autoDismissTimer?.invalidate()
        hide()
    }
}
