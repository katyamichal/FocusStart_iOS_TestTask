//
//  NoteTableViewCell.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NoteTableViewCell"
    private let constant: CGFloat = 20
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colours.NoteColours.defaultColour
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        var stackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        var stackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.layer.cornerRadius = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return stackView
    }()
    
    private let noteTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Avenir Next Regular", size: 16)
        label.textColor = Colours.Text.defaultColour
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = Colours.Text.secondaryText
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private let noteMainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 13)
        label.textColor =  Colours.Text.defaultColour
        return label
    }()
    
    private let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    
    // MARK: - Public
    
    public func configure(_ note: Note, at index: Int) {
        let text = String(note.noteText.characters.filter({$0 != "\n"})).trimmingCharacters(in: .whitespaces)
        NSAttributedString(note.noteText).enumerateAttribute(.attachment, in: NSRange(location: 0, length: NSAttributedString(note.noteText).length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, !text.isEmpty {
                noteImageView.isHidden = false
                noteImageView.image = attachment.image
                stop.pointee = true
            } else {
                noteImageView.isHidden = true
            }
        }
        noteTitleLabel.text = !text.isEmpty ? text : "Note #\(index+1)"
        dateLabel.text = note.date.formatted(date: .long, time: .omitted)
        noteMainTextLabel.text = !text.isEmpty ? text : "Note #\(index+1)"
    }
    
}

// MARK: - setup methods

private extension NoteTableViewCell {
    
    func setupCell() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(noteImageView)
        verticalStackView.addArrangedSubview(noteTitleLabel)
        verticalStackView.addArrangedSubview(dateLabel)
        verticalStackView.addArrangedSubview(noteMainTextLabel)
    }
    
    func setupConstraints() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constant).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
}
