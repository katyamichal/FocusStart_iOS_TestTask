//
//  DetailNoteView.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

final class DetailNoteView: UIView {
    
    private let inset: CGFloat = 20
    
    var viewModel: DetailNoteViewModel? {
        didSet {
            guard let note = viewModel?.note else {
                return
            }
            configureView(with: note)
        }
    }

    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NoteView deinit")
    }
    
    
    // MARK: - UI Elements
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        textView.backgroundColor = .clear
        textView.tintColor = Colours.ThemeColours.defaultColour
        textView.font = UIFont(name: "Avenir Next Regular", size: 20)
        return textView
        
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Regular", size: 15)
        label.textColor = Colours.Text.secondaryText
        return label
    }()
    
    // MARK: - Private
    
    private func configureView(with note: Note) {
        NSAttributedString(note.noteText).enumerateAttribute(.attachment, in: NSRange(location: 0, length: NSAttributedString(note.noteText).length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment {
                attachment.setImageHeight(height: self.bounds.size.width - 100)
            }
        }
        noteTextView.attributedText = NSAttributedString(note.noteText)
        dateLabel.text = note.date.formatted(date: .long, time: .shortened)
    }
}

private extension DetailNoteView {
    
    func setupView() {
        backgroundColor = Colours.BackgroundsColours.defaultColour
        setupTextView()
        setupConstraints()
    }
    
    func setupTextView() {
        addSubview(dateLabel)
        addSubview(noteTextView)
    }
    
    func setupConstraints() {
        dateLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -inset).isActive = true
        
        noteTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        noteTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        noteTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
    }
}
