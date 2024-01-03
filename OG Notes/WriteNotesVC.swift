//
//  WriteNotesVC.swift
//  OG Notes
//
//  Created by Om Gandhi on 02/01/24.
//

import UIKit
import Realm
import RealmSwift
class WriteNotesVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//MARK: Outlets
    @IBOutlet weak var txtNoteHeading: UITextField!
    @IBOutlet weak var txtNoteText: UITextView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    //MARK: Variables
    var note = Notes(id: 0,headingText: "", noteText: "")
    var isFromWrite = false
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done  = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        if (note.noteText == "" || note.noteText.isEmpty){
            txtNoteText.text = "Enter your text here..."
            txtNoteText.textColor = UIColor.lightGray
        }
        else{
            txtNoteText.text = note.noteText
            txtNoteText.textColor = .label
        }
        if(note.headingText.isEmpty || note.headingText == ""){
            txtNoteHeading.placeholder = "Untitled"
        }
        else{
            txtNoteHeading.text = note.headingText
        }
            
        self.navigationItem.rightBarButtonItem = done

    }
    override func viewWillDisappear(_ animated: Bool) {
        // Open the local-only default realm
        if (txtNoteHeading.text == "" || txtNoteHeading.hasText == false) && (txtNoteText.text == "" || txtNoteText.hasText == false || txtNoteText.text == "Enter your text here...") {
            
        }
        else{
            let realm = try! Realm()
            let realmResult: Results<Notes> = realm.objects(Notes.self)
            let notesArr = realmResult.toArray()
            var noteHeading = ""
            var noteText = ""
            if txtNoteHeading.text == "" || txtNoteHeading.hasText == false{
                noteHeading = ""
            }
            else{
                noteHeading = txtNoteHeading.text ?? ""
            }
            if txtNoteText.text == "" || txtNoteText.hasText == false || txtNoteText.text == "Enter your text here..."{
                noteText = ""
            }
            else{
                noteText = txtNoteText.text ?? ""
            }
            if notesArr.contains(where: {$0.id == note.id}){
                try! realm.write{
                    note.headingText = noteHeading
                    note.noteText = noteText
                }
            }
            else{
                note = Notes(id: Int.random(in: 1...999999), headingText: noteHeading, noteText: noteText)
                try! realm.write{
                    realm.add(note)
                }
               
            }
        }
        
    }
    
    //MARK: Button Methods
    @objc func doneTapped(){
        if txtNoteText.isFirstResponder{
            txtNoteText.resignFirstResponder()
        }
        if txtNoteHeading.isFirstResponder{
            txtNoteHeading.resignFirstResponder()
        }
        if (txtNoteHeading.text == "" || txtNoteHeading.hasText == false) && (txtNoteText.text == "" || txtNoteText.hasText == false || txtNoteText.text == "Enter your text here...") {
            
        }
        else{
            let realm = try! Realm()
            let realmResult: Results<Notes> = realm.objects(Notes.self)
            var notesArr = realmResult.toArray()
            var noteHeading = ""
            var noteText = ""
            if txtNoteHeading.text == "" || txtNoteHeading.hasText == false{
                noteHeading = ""
            }
            else{
                noteHeading = txtNoteHeading.text ?? ""
            }
            if txtNoteText.text == "" || txtNoteText.hasText == false || txtNoteText.text == "Enter your text here..."{
                noteText = ""
            }
            else{
                noteText = txtNoteText.text ?? ""
            }
            
            if notesArr.contains(where: {$0.id == note.id}){
                try! realm.write{
                    note.headingText = noteHeading
                    note.noteText = noteText
                }
            }
            else{
                note = Notes(id: Int.random(in: 1...999999), headingText: noteHeading, noteText: noteText)
                try! realm.write{
                    realm.add(note)
                }
               
            }
        }
    }
    //MARK: Textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        txtNoteText.becomeFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text here..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame;

        frame.size = textView.contentSize;
        txtViewHeight.constant = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.greatestFiniteMagnitude)).height
//        textView.frame = frame;
//        viewHeight.constant = txtNoteText.frame.height + textView.frame.height
    }
    
}

