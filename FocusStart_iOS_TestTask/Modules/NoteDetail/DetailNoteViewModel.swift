//
//  DetailNoteViewModel.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//


import Foundation

final class DetailNoteViewModel {
    private let service: NotesService = NotesService.shared
    var note: Note
    
    // MARK: - Inits
    
    init(note: Note?) {
        guard let note = note else {
            self.note = Note(id: UUID(), noteText: AttributedString(), date: Date(), isSelected: false)
            return
        }
        self.note = note
    }
    
    deinit {
        print("DetailNoteViewModel deinit")
    }
    
    // MARK: - Public
    public func saveNote(_ attributedString: NSAttributedString) {
            
        let str = AttributedString(attributedString)
        note.noteText = str
        let isStringEmpty: Bool = str.unicodeScalars.isEmpty

        // Try to load saved notes
        guard var savedNotes = service.loadNotes() else {
            // If no saved notes exist, save the note and return
            service.save([note])
            return
        }
        
        // Check if the note already exists in the saved notes
        if let index = savedNotes.firstIndex(where: {$0.id == note.id}) {
            // If the note text is empty, remove the note
            if isStringEmpty {
                savedNotes.remove(at: index)
            } else {
                // Otherwise, update the note
                savedNotes[index] = note
            }
        } else {
            // If the note doesn't exist and the text isn't empty, add the note
            if !isStringEmpty {
                savedNotes.append(note)
            }
        }
        // Save the updated notes
        service.save(savedNotes)
    }

}


//
//[FocusStart_iOS_TestTask.Note(id: 39251588-7ECD-4572-B0DB-6AA7EADA6C9B, noteText: Your job is not always going to fulfil you. There will be some days that you might be bored.Other days you may not feel like going to work at all. Go anyway. And remember that your job is not who you are. It’s just what you’re doing on the way to who you will become. {
//    NSFont = <UICTFont: 0x151607440> font-family: ".SFUI-Semibold"; font-weight: bold; font-style: normal; font-size: 18.00pt
//    NSColor = UIExtendedSRGBColorSpace 0.309804 0.301961 0.313725 1
//    NSParagraphStyle = Alignment Left, LineSpacing 0, ParagraphSpacing 0, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 5, LineHeight 0/0, LineHeightMultiple 0, LineBreakMode WordWrapping, Tabs (
//    28L,
//    56L,
//    84L,
//    112L,
//    140L,
//    168L,
//    196L,
//    224L,
//    252L,
//    280L,
//    308L,
//    336L
//), DefaultTabInterval 0, Blocks (
//), Lists (
//), BaseWritingDirection Natural, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 0 LineBreakStrategy 0 PresentationIntents (
//) ListIntentOrdinal 0 CodeBlockIntentLanguageHint ''
//}, date: 2024-01-30 03:00:00 +0000, isSelected: false)]
