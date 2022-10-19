//
//  PasswordViewController.swift
//  BruteForce
//
//  Created by Arthur on 17.10.2022.
//

import UIKit

class PasswordViewController: UIViewController {
    
    private let changeThemeIcon: String = "changeThemeButton"
    
    // MARK: Flags
    
    private var isStart = false
    private var isCycleRunning = true
    private var isButtonStopPressed = false
    private let queue = DispatchQueue.global(qos: .background)
    
    // MARK: UI Elements
    
    private lazy var textFieldPassword: UITextField = {
        var textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Input password here"
        textFieldPassword.textAlignment = .center
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.sizeToFit()
        textFieldPassword.backgroundColor = .separator
        textFieldPassword.layer.cornerRadius = Metric.cornerRadius
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPassword
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "****"
        label.textColor = .systemBlue
        label.backgroundColor = view.backgroundColor
        label.textAlignment = .center
        label.sizeToFit()
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.cornerRadius = Metric.cornerRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonColor: UIButton = {
        var buttonColor = UIButton()
        buttonColor.addTarget(self, action: #selector(buttonColorPressed), for: .touchUpInside)
        buttonColor.translatesAutoresizingMaskIntoConstraints = false
        buttonColor.setImage(UIImage(named: changeThemeIcon), for: .normal)
        return buttonColor
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemBlue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: Create buttons
    
    private lazy var buttonStart = makeButton(title: "Взлом",
                                              action: #selector(buttonStartPressed),
                                              color: .systemGreen)
    private lazy var buttonStop = makeButton(title: "Стоп",
                                             action: #selector(buttonStopPressed),
                                             color: .systemRed)
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(activityIndicatorView)
        view.addSubview(textFieldPassword)
        view.addSubview(label)
        view.addSubview(buttonStart)
        view.addSubview(buttonStop)
        view.addSubview(buttonColor)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldPassword.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.leadingValue),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.trailingValue),
            textFieldPassword.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Metric.textFieldHeightMultiplier),
            
            buttonColor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonColor.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Metric.buttonColorHeightMultiplier),
            buttonColor.widthAnchor.constraint(equalTo: buttonColor.heightAnchor),
            buttonColor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.leadingAnchor.constraint(equalTo: textFieldPassword.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor),
            label.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: Metric.labelTopMargin),
            label.heightAnchor.constraint(equalTo: textFieldPassword.heightAnchor, multiplier: Metric.labelHeightMultiplier),
            
            buttonStart.leadingAnchor.constraint(equalTo: textFieldPassword.leadingAnchor),
            buttonStart.trailingAnchor.constraint(equalTo: textFieldPassword.centerXAnchor, constant: Metric.trailingValue),
            buttonStart.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Metric.buttonTopMargin),
            buttonStart.heightAnchor.constraint(equalTo: textFieldPassword.heightAnchor, multiplier: Metric.buttonHeightMultiplier),
            
            buttonStop.leadingAnchor.constraint(equalTo: textFieldPassword.centerXAnchor, constant: Metric.leadingValue),
            buttonStop.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor),
            buttonStop.topAnchor.constraint(equalTo: buttonStart.topAnchor),
            buttonStop.heightAnchor.constraint(equalTo: buttonStart.heightAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: textFieldPassword.centerYAnchor, constant: Metric.activityIndicatorTopMargin)
        ])
    }
    
    // MARK: Change background color
    
    private var isDoor: Bool = true {
        didSet {
            view.backgroundColor = isDoor ? .white : .black
        }
    }
    
    // MARK: Actions
    
    @objc private func buttonStartPressed() {
        isStart = true
        isButtonStopPressed = false
        textFieldPassword.isSecureTextEntry = true
        bruteForce(passwordToUnlock: textFieldPassword.text ?? "")
    }
    
    @objc private func buttonColorPressed() {
        isDoor.toggle()
    }
    
    @objc private func buttonStopPressed() {
        isButtonStopPressed = !isButtonStopPressed // если будет true, то поменяет на false и наоборот
    }
    
    // MARK: Multithreading function
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        queue.async {
            if self.isStart {
                while password != passwordToUnlock && !self.isButtonStopPressed {
                    self.isStart = false
                    password = generateBruteForce(password, fromArray: allowedCharacters)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.startAnimating()
                        self.label.text = password
                    }
                }
            }
            
            DispatchQueue.main.async {
                if password == passwordToUnlock {
                    self.label.text = "Ваш пароль \(passwordToUnlock)"
                } else {
                    self.label.text = "Ваш пароль \(passwordToUnlock) не взломан"
                    self.textFieldPassword.text = ""
                }
                self.textFieldPassword.isSecureTextEntry = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}
