//
//  NotesService.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import Foundation

protocol NotesServiceable {
    func save(_ notes: [Note])
    func loadNotes() -> [Note]?
}

struct NotesService: NotesServiceable {
    
    static let shared = NotesService()
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archieveURL = documentDirectory.appendingPathComponent("Note").appendingPathExtension("plist")
    
    // MARK: - Methods
    
    
    func save(_ notes: [Note]) {
        let propertyListEncoder = PropertyListEncoder()
        let codeList = try? propertyListEncoder.encode(notes)
        try? codeList?.write(to: NotesService.archieveURL, options: .noFileProtection)
    }
    
    func loadNotes() -> [Note]? {
        guard let data = try? Data(contentsOf: NotesService.archieveURL) else {
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Note>.self, from: data)
    }
}

