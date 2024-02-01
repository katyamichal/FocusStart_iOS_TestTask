//
//  Note.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 30.01.2024.
//

import Foundation

struct Note: Codable, Equatable, Hashable {
    let id: UUID
    var noteText: AttributedString
    var date: Date
    var isSelected: Bool
    
    // MARK: - Equatable protocol implementation
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}
