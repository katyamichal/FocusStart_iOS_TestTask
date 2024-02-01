//
//  AllNotesView.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

protocol NotesViewSelectionProtocol: AnyObject {
    func showNote(note: Note?)
}

final class AllNotesView: UIView {
    
    var onDeleteNote: ((Note, Int)->())?
    
    var viewModel: AllNotesViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: NotesViewSelectionProtocol?
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.cellIdentifier)
        return tableView
    }()
    
    private lazy var addNewNoteButton: AddNewNoteButton = {
        let button = AddNewNoteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

// MARK: -  Setups View

private extension AllNotesView {
    
    func setupView() {
        backgroundColor = Colours.BackgroundsColours.defaultColour
        setupViews()
        setupConstraints()
        addNewNoteButton.onAddNewButtonDidSelected = { [weak self] in
            self?.delegate?.showNote(note: nil)
        }
    }
    
    func setupViews() {
        addSubview(tableView)
        addSubview(addNewNoteButton)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        addNewNoteButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addNewNoteButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        addNewNoteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addNewNoteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

// MARK: - Collection Data Source

extension AllNotesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.cellIdentifier, for: indexPath) as? NoteTableViewCell else {
            assert(false, "Error to dequeue NoteTableViewCell")
        }
        guard let viewModel else {return UITableViewCell()}
        cell.configure(viewModel.notes[indexPath.row], at: indexPath.row)
        return cell
    }
}


// MARK: - Collection Delegate methods

extension AllNotesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = viewModel?.notes[indexPath.row] else { return }
        delegate?.showNote(note: note)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let deleteAction = createDeleteAction(tableView, at: indexPath) else { return nil }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
    
    
    private func createDeleteAction(_ tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.deleteAction(tableView, at: indexPath)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = Colours.ThemeColours.defaultColour
        return deleteAction
    }
    
    
    private func deleteAction(_ tableView: UITableView, at indexPath: IndexPath) {
        guard let viewModel else { return }
        let note = viewModel.notes[indexPath.row]
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .left)
        self.onDeleteNote?(note, Int(indexPath.row))
        self.tableView.endUpdates()
    }
}
