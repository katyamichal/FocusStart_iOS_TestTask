//
//  UIViewController + gestureRecognizer.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeDown.cancelsTouchesInView = false
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

