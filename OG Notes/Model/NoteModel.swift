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

    convenience init(id: Int,headingText: String, noteText: String) {
       self.init()
        self.id = id
        self.headingText = headingText
        self.noteText = noteText
    }
       
}
