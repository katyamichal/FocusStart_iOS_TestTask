//
//  DetailNoteViewController.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

final class DetailNoteViewController: UIViewController {
    
    private var noteView: DetailNoteView { return self.view as! DetailNoteView }
    private var viewModel: DetailNoteViewModel
    
    var image: UIImage?
    var textRange: NSRange?
    
    // MARK: - Inits
    
    init(viewModel: DetailNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NoteViewController deinit")
    }
    
    
    // MARK: - Cycle
    
    override func loadView() {
        self.view = DetailNoteView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteView.viewModel = viewModel
    }
    
    
    // MARK: - Private setup methods
    
    private func setupViewController() {
        setupKeyboardBehavior()
        setupNavBar()
    }
    
    private func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(pickPhoto))
        navigationItem.leftBarButtonItem?.tintColor = Colours.ThemeColours.defaultColour
        navigationItem.rightBarButtonItem?.tintColor = Colours.ThemeColours.defaultColour
    }
    
    
    private func setupKeyboardBehavior() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandeling), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandeling), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenSwipeDown()
    }
    
    
    @objc func saveNote() {
        viewModel.saveNote(noteView.noteTextView.attributedText)
        noteView.noteTextView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc
    func keyboardHandeling(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardFrame = self.view.convert(keyboardSize, to: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteView.noteTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            noteView.noteTextView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: keyboardFrame.height, right: 20)
            noteView.noteTextView.scrollIndicatorInsets = noteView.noteTextView.contentInset
        }
        noteView.noteTextView.scrollRangeToVisible(noteView.noteTextView.selectedRange)
    }
}


extension DetailNoteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= 0 {
            view.endEditing(true)
        }
    }
}

// MARK: - Image Helper Methods

extension DetailNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            addPhoto(with: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addPhoto(with image: UIImage) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let newString = NSMutableAttributedString(string: "", attributes: attributes)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageHeight = noteView.bounds.size.width - 100
        imageAttachment.setImageHeight(height: imageHeight)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        if let existingText = noteView.noteTextView.attributedText {
            newString.append(existingText)
        }
        
        newString.append(imageString)
        noteView.noteTextView.attributedText = newString
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
