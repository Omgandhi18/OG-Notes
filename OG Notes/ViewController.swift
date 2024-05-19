//
//  ViewController.swift
//  OG Notes
//
//  Created by Om Gandhi on 28/12/23.
//

import UIKit
import RealmSwift
import LocalAuthentication
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    //MARK: Outlets
    @IBOutlet weak var tblNotes: UITableView!
    @IBOutlet weak var viewNoNotes: UIView!
    
    //MARK: Variables
    var notesArr = [Notes]()
    private var context = LAContext()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        // Do any additional setup after loading the view.
        let realmResult: Results<Notes> = realm.objects(Notes.self)
        notesArr = realmResult.toArray()
        if notesArr.count == 0{
            viewNoNotes.isHidden = false
            
        }
        else{
            viewNoNotes.isHidden = true
            tblNotes.delegate = self
            tblNotes.dataSource = self
            tblNotes.reloadData()
        }
        print(notesArr)
        
    }
    
    //MARK: Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notesArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteCell
        cell.selectionStyle = .none
        if note.headingText == "" || note.headingText.isEmpty{
            cell.lblHeading.text = "Untitled"
        }
        else{
            cell.lblHeading.text = note.headingText
        }
        if note.noteText == "" || note.noteText.isEmpty{
            cell.lblNoteText.text = "No additional text"
        }
        else{
            cell.lblNoteText.text = note.noteText
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteNoteStory") as! WriteNotesVC
        vc.note = notesArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let realm = try! Realm()
        let note = notesArr[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, handler) in
            print("Delete Action Tapped")
            
            try! realm.write {
                // Delete the Todo.
                realm.delete(note)
                notesArr.remove(at: indexPath.row)
                if notesArr.count == 0{
                    viewNoNotes.isHidden = false
                    
                }
                else{
                    viewNoNotes.isHidden = true
                }
                tblNotes.reloadData()
            }
        }
        let lockAction = UIContextualAction(style: .normal, title: "Lock", handler: {[self] (action,view,handler) in
            
            let noteToLock = realm.objects(Notes.self).where {
                $0.id == note.id
            }.first!
            context = LAContext()
            lockNote(noteToLock: noteToLock,toLock: true)
            
            print("Lock Action tapped")
            
        })
        let unlockAction = UIContextualAction(style: .normal, title: "Unlock", handler: {[self] (action,view,handler) in
            let noteToLock = realm.objects(Notes.self).where {
                $0.id == note.id
            }.first!
            context = LAContext()
            lockNote(noteToLock: noteToLock,toLock: false)
            
            print("Unlock Action tapped")
        })
        lockAction.backgroundColor = .darkBlue
        lockAction.image = UIImage(systemName: "lock.fill")
        
        unlockAction.backgroundColor = .darkBlue
        unlockAction.image = UIImage(systemName: "lock.open.fill")
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        if note.isLocked{
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction,unlockAction])
            return configuration
        }
        else{
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction,lockAction])
            return configuration
        }
        
    }
    //MARK: Button methods
    @IBAction func btnWrite(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "WriteNoteStory") as! WriteNotesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func lockNote(noteToLock: Notes,toLock:Bool) {

        // Check if biometric authentication is available and not locked
        guard isBiometricAvailable() else { return }
        let realm = try! Realm()
        
        var error: NSError?
        
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
                            if toLock{
                                noteToLock.isLocked = true
                            }
                            else{
                                noteToLock.isLocked = false
                            }
                            self.context.invalidate()
                            print(noteToLock)
                            let realmResult: Results<Notes> = realm.objects(Notes.self)
                            self.notesArr = realmResult.toArray()
                            self.tblNotes.reloadData()
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
extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

