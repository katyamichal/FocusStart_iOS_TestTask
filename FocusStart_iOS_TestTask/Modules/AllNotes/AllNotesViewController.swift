//
//  AllNotesViewController.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

final class AllNotesViewController: UIViewController {
    
    private let notesViewModel: AllNotesViewModel
    private var notesView: AllNotesView { return self.view as! AllNotesView }
    
    // MARK: - Inits
    
    init(notesViewModel: AllNotesViewModel) {
        self.notesViewModel = notesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        self.view = AllNotesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        notesView.delegate = self
        notesViewModel.onUpdateView = { [weak self] in
            self?.notesView.viewModel = self?.notesViewModel
        }
        notesView.onDeleteNote = { [weak self] note, index in
            self?.notesViewModel.deleteNote(note: note, at: index)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesViewModel.loadNotes()
    }
}


private extension AllNotesViewController {
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Notes"
    }
}

extension AllNotesViewController: NotesViewSelectionProtocol {
    func showNote(note: Note?) {
        let viewModel = DetailNoteViewModel(note: note)
        let vc = DetailNoteViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

