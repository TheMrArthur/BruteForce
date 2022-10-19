//
//  ExtensionPasswordViewController.swift
//  BruteForce
//
//  Created by Arthur on 17.10.2022.
//

import UIKit

extension PasswordViewController {
    
    func makeButton(title: String, action: Selector, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
