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
    @IBOutlet weak var btnCamera: UIButton!
    
    //MARK: Variables
    var note = Notes(headingText: "", noteText: "")
    var isFromWrite = false
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let done  = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        txtNoteText.text = "Enter your text here..."
        txtNoteText.textColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = done
        
        let gallery = UIAction(title: "From photos",
          image: UIImage(systemName: "heart.fill")) { _ in
          // Perform action
            let galleryPicker = self.imagePicker(sourceType: .photoLibrary)
            self.present(galleryPicker, animated: true)
        }

        let camera = UIAction(title: "Open Camera",
          image: UIImage(systemName: "square.and.arrow.up.fill")) { action in
          // Perform action
            let cameraPicker = self.imagePicker(sourceType: .camera)
            self.present(cameraPicker, animated: true)
        }
        let items = [gallery, camera]
        btnCamera.menu = UIMenu(children: items)
        btnCamera.showsMenuAsPrimaryAction = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        // Open the local-only default realm
        if (txtNoteHeading.text == "" || txtNoteHeading.hasText == false) && (txtNoteText.text == "" || txtNoteText.hasText == false || txtNoteText.text == "Enter your text here...") {
            
        }
        else{
            let realm = try! Realm()
            let realmResult: Results<Notes> = realm.objects(Notes.self)
            var notesArr = realmResult.toArray()
            var noteHeading = ""
            var noteText = ""
            if txtNoteHeading.text == "" || txtNoteHeading.hasText == false{
                noteHeading = "Untitled"
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
            note = Notes(headingText: noteHeading, noteText: noteText)
            if notesArr.contains(where: {$0.noteText == note.noteText && $0.headingText == note.headingText}){
                try! realm.write{
                    note.headingText = noteHeading
                    note.noteText = noteText
                }
            }
            else{
                
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
                noteHeading = "Untitled"
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
            note = Notes(headingText: noteHeading, noteText: noteText)
            if notesArr.contains(where: {$0.noteText == note.noteText && $0.headingText == note.headingText}){
                try! realm.write{
                    note.headingText = noteHeading
                    note.noteText = noteText
                }
            }
            else{
               
                try! realm.write{
                    realm.add(note)
                }
               
            }
        }
    }
    func imagePicker(sourceType: UIImagePickerController.SourceType)->UIImagePickerController {
        let imagePicker = UIImagePickerController ()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        //create and NSTextAttachment and add your image to it.
        let attachment = NSTextAttachment()
        attachment.image = image
        let oldWidth = attachment.image!.size.width;
        //put your NSTextAttachment into and attributedString
        let scaleFactor = oldWidth / (txtNoteText.frame.size.width - 10);
        attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation: .downMirrored)
        var attrStringWithImage = NSAttributedString(attachment: attachment)
        let attString = NSAttributedString(attachment: attachment)
        //add this attributed string to the current position.
        txtNoteText.textStorage.append(attString)
        dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
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
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text here..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
       
    }
    
}
