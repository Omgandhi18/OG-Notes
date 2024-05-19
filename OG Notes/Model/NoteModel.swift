//
//  NoteModel.swift
//  OG Notes
//
//  Created by Om Gandhi on 02/01/24.
//

import Foundation
import RealmSwift
class Notes: Object {
    @Persisted var id = Int()
   @Persisted var headingText: String = ""
    @Persisted var noteText: String = ""
    @Persisted var isLocked: Bool = false
    convenience init(id: Int,headingText: String, noteText: String, isLocked: Bool) {
       self.init()
        self.id = id
        self.headingText = headingText
        self.noteText = noteText
        self.isLocked = isLocked
    }
       
}
