//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Suraj Rao on 3/12/21.
//

import Foundation

import UIKit
import NotificationBannerSwift

class SignUpVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome,"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up to continue"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Name:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    
    private let signUpButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signInActionLabel: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Already have an account?",
            buttonTitle: "Sign In")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let signinButtonHeight: CGFloat = 44.0

    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signUpButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: signinButtonHeight)
        ])
        
        signUpButton.layer.cornerRadius = signinButtonHeight / 2
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
        
        view.addSubview(signInActionLabel)
        NSLayoutConstraint.activate([
            signInActionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInActionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
        signInActionLabel.addTarget(self, action: #selector(didTapSignIn(_:)), for: .touchUpInside)
    }

    @objc func didTapSignUp(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Missing email",
                            subtitle: "Please provide an email")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Missing password",
                            subtitle: "Please provide a password")
            return
        }
        
        guard let name = nameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing name",
                            subtitle: "Please provide a name")
            return
        }
        
        guard let username = usernameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing username",
                            subtitle: "Please provide a username")
            return
        }
        
        signUpButton.showLoading()
        FIRAuthProvider.shared.signUp(withEmail: email, withName: name, withUsername: username, withPassword: password) { [weak self] result in
            
            defer {
                self?.signUpButton.hideLoading()
            }
            
            switch result {
            case .success:
                guard let window = UIApplication.shared
                        .windows.filter({ $0.isKeyWindow }).first else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = vc
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
            case .failure(let error):
                self?.showErrorBanner(withTitle: error.localizedDescription)
//                switch error {
//                case .wrongPassword:
//                    self?.showErrorBanner(withTitle: "Incorrect password",
//                                          subtitle: "Please check your password and try again")
//                case .userNotFound:
//                    self?.showErrorBanner(withTitle: "User not found",
//                                          subtitle: "A user with email \(email) doesn't exist")
//                case .internalError:
//                    self?.showErrorBanner(withTitle: "An internal error occured",
//                                          subtitle: "Please try again later")
//                case .invalidEmail:
//                    self?.showErrorBanner(withTitle: "Invalid email",
//                                          subtitle: "Please check your email and try again")
//                default:
//                    return
//                }
            }
        }
    }
    
    @objc private func didTapSignIn(_ sender: UIButton) {
        let vc = SigninVC()
        present(vc, animated: true, completion: nil)
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
