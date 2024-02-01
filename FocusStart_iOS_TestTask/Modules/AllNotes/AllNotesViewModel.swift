//
//  AllNotesViewModel.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import UIKit

final class AllNotesViewModel {
    
    private let service: NotesServiceable
    var notes: [Note] = []
    
    // MARK: - Property Observer + Closure
    
    var onUpdateView: (()->())?
    
    private var isUpdated: Bool = false {
        didSet {
            if isUpdated == true {
                onUpdateView?()
                isUpdated = false
            }
        }
    }
    
    // MARK: - Inits
    init(service: NotesServiceable) {
        self.service = service
    }
    
    // MARK: - Methods
    
   private func loadSampleData() -> [Note] {
       let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont(name: "Avenir Next Regular", size: 18) ?? UIFont.systemFont(ofSize: 17),
       ]
        let text = "In the back of Södermalm design shop Esteriör, Cafériör is set to become Stockholm's new bagel destination. The space features HAY’s colourful Rey chairs, Tableware like the Sobremesa Collection and Rim glasses, storage accessories like the HAY Colour Crate and Tin By Sowden, and functional furniture like the Arcs Trolley. \n \n "
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
       
       let imageAttachment = NSTextAttachment()
       imageAttachment.image = UIImage(named: "cr2")
       imageAttachment.setImageHeight(height: 200)
       let imageString = NSAttributedString(attachment: imageAttachment)
       attributedString.append(imageString)
       
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 30
        components.hour = 6
        components.minute = 0
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        let sampleNote = Note(id: UUID(), noteText: AttributedString(attributedString), date: date, isSelected: false)
        
        return [sampleNote]
    }
    
    // MARK: - Public
    
    func loadNotes() {
        defer {
            isUpdated = true
        }
        
        if let savedNotes = service.loadNotes(), !savedNotes.isEmpty {
            notes = savedNotes.reversed()
        } else {
            notes = loadSampleData()
            service.save(notes)
        }
    }
    
    func deleteNote(note: Note, at index: Int) {
        notes.remove(at: index)
        service.save(notes)
        isUpdated = true
    }
}

