//
//  WriteNotesVC.swift
//  OG Notes
//
//  Created by Om Gandhi on 02/01/24.
//

import UIKit
import Realm
import RealmSwift
import LocalAuthentication
class WriteNotesVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//MARK: Outlets
    @IBOutlet weak var txtNoteHeading: UITextField!
    @IBOutlet weak var txtNoteText: UITextView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewLocked: UIView!
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    //MARK: Variables
    var note = Notes(id: 0,headingText: "", noteText: "", isLocked:  false)
    var isLocked = false
    private var context = LAContext()
    var lock = UIBarButtonItem()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
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
        if note.isLocked{
            viewLocked.isHidden = false
            lock = UIBarButtonItem(image: UIImage(systemName: "lock.fill"), style: .plain, target: self, action: #selector(lockUnlockNote))
            self.navigationItem.rightBarButtonItems = [lock]
        }
        else{
            viewLocked.isHidden = true
            lock = UIBarButtonItem(image: UIImage(systemName: "lock.open.fill"), style: .plain, target: self, action: #selector(lockUnlockNote))
//            let done  = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
            self.navigationItem.rightBarButtonItems = [lock]
        }
        isLocked = note.isLocked
        scrollView.keyboardDismissMode = .interactive
        

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
                note = Notes(id: Int.random(in: 1...999999), headingText: noteHeading, noteText: noteText, isLocked: isLocked)
                try! realm.write{
                    realm.add(note)
                }
               
            }
        }
        
    }
    
    //MARK: Button Methods
    @IBAction func btnUnlock(_ sender: Any) {
        context = LAContext()
        lockNote(noteToLock: note, toLock: false)
        lock.image = UIImage(systemName: "lock.open.fill")
    }
    @objc func lockUnlockNote(_ sender: Any){
        if isLocked{
            context = LAContext()
            lockNote(noteToLock: note, toLock: false)
            lock.image = UIImage(systemName: "lock.open.fill")
        }
        else{
            lockNote(noteToLock: note, toLock: true)
            lock.image = UIImage(systemName: "lock.fill")
        }
    }
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
                note = Notes(id: Int.random(in: 1...999999), headingText: noteHeading, noteText: noteText, isLocked: isLocked)
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
        let done  = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        self.navigationItem.rightBarButtonItems = [done,lock]
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text here..."
            textView.textColor = UIColor.lightGray
        }
        self.navigationItem.rightBarButtonItems = [lock]
    }
    func textViewDidChange(_ textView: UITextView) {
        var frame = textView.frame;

        frame.size = textView.contentSize;
        txtViewHeight.constant = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.greatestFiniteMagnitude)).height
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
            note = Notes(id: Int.random(in: 1...999999), headingText: noteHeading, noteText: noteText, isLocked: isLocked)
            try! realm.write{
                realm.add(note)
            }
           
        }
//        textView.frame = frame;
//        viewHeight.constant = txtNoteText.frame.height + textView.frame.height
    }
    
    private func lockNote(noteToLock: Notes,toLock:Bool) {
//        guard isBiometricAvailable() else { return }
        let realm = try! Realm()
        
        var error: NSError?
        
        // Check if biometric authentication is available and not locked
        if toLock{
            DispatchQueue.main.async {
                try! realm.write{
                    
                    self.isLocked = true
                    noteToLock.isLocked = self.isLocked
                    self.viewLocked.isHidden = false
                    
                    print(noteToLock)
                   
                }
            }
        }
        else{
            
            // Check if biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

                // Perform biometric authentication
                let reason = "We need to unlock your data."
                
                // It presents a localized reason for authentication to the user, explaining why authentication is necessary.
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self]
                    success, authenticationError in
                    guard let self else { return }

                    // Handle authentication completion
                    if success {
                        // proceeds to decrypt and verify the user's passcode
                        DispatchQueue.main.async {
                            try! realm.write{
                                
                                self.isLocked = false
                                noteToLock.isLocked = self.isLocked
                                self.viewLocked.isHidden = true
                                self.context.invalidate()
                                
                                print(noteToLock)
                               
                            }
                        }
                       
                        
                    } else {
                        // increments the failedAttempt count
                       print("Not Authenticated")

                        // check for the maximum allowed failed limit
                        
                    }
                    
                }
            } else {
                // Handle error if biometric authentication is not possible
                if let error {
                    handleLaError(error: error)
                } else {
                    // Handle other errors if any
                }
            }
        }
        
    }
    //MARK: Biometric methods
    private func isBiometricAvailable() -> Bool {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
    private func handleLaError(error: NSError) {
            if let error = (error as? LAError) {
                var errorMessage: String {
                    switch error.code {
                    case .biometryNotAvailable:
                        return "Your device does not supported biometric"
                    case .biometryNotEnrolled:
                        return "Biometric lock is not set please set it first."
                    case .biometryLockout:
                        return "Biometric is locked try entering passcode manually."
                    default:
                        return "Unidentified error"
                    }
                }
                print("\(errorMessage)")
            }
        }

    
}

