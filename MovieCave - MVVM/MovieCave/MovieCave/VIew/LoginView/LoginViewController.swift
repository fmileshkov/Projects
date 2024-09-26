//
//  ViewController.swift
//  MovieCave
//
//  Created by Admin on 20.09.23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var userNameTextFiled: UITextField!
    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    
    //MARK: - Properties
    var viewModel: LoginViewModelProtocol?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: - IBActions
    @IBAction private func logInButtonPress(_ sender: UIButton) {
        viewModel?.logIn()
    }
    
}

