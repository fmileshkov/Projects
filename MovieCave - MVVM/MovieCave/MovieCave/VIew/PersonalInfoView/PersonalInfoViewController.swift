//
//  PersonalInfoViewController.swift
//  MovieCave
//
//  Created by Admin on 26.10.23.
//

import UIKit
import Combine

class PersonalInfoViewController: UIViewController {

    //MARK: - Properties
    var viewModel: PersonalInfoViewModelProtocol?
    private var cancellables: [AnyCancellable] = []
    private var popUp: PopUpView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
    }

    //MARK: - Methods
    func setUpBinders() {
        viewModel?.changeMessage.sink { [weak self] message in
            guard let self,
            let message else { return }
            
            self.popUp = PopUpView(frame: self.view.frame, inVC: self, messageLabelText: message)
            self.view.addSubview(self.popUp)
        }.store(in: &cancellables)
    }
    
    //MARK: - IBActions
    @IBAction private func saveButtonTapp(_ sender: UIButton) {
        viewModel?.saveChanges()
        viewModel?.removeCoordinator()
    }
    
}
