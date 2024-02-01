//
//  AddNewNoteButton.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

class AddNewNoteButton: UIButton {
    
    var onAddNewButtonDidSelected: (()->())?
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit AddNewNoteButton")
    }
    
    // MARK: - setup methods
    
    private func setupButton() {
        self.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        self.tintColor = Colours.ThemeColours.defaultColour
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.cornerRadius = 30
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.addTarget(self, action: #selector(addButtonDidPressed), for: .touchUpInside)
    }
    
    @objc
    func addButtonDidPressed() {
        onAddNewButtonDidSelected?()
    }
}
