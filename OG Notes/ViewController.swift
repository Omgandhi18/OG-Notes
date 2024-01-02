//
//  ViewController.swift
//  OG Notes
//
//  Created by Om Gandhi on 28/12/23.
//

import UIKit
import RealmSwift
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    //MARK: Outlets
    @IBOutlet weak var tblNotes: UITableView!
    
    //MARK: Variables
    var notesArr = [Notes]()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        // Do any additional setup after loading the view.
        let realmResult: Results<Notes> = realm.objects(Notes.self)
        notesArr = realmResult.toArray()
        print(notesArr)
        tblNotes.delegate = self
        tblNotes.dataSource = self
        tblNotes.reloadData()
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
        cell.lblHeading.text = note.headingText
        cell.lblNoteText.text = note.noteText
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let realm = try! Realm()
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, handler) in
                    print("Delete Action Tapped")
            let noteToDelete = self.notesArr[indexPath.row]
            try! realm.write {
                // Delete the Todo.
                realm.delete(noteToDelete)
                notesArr.remove(at: indexPath.row)
                tblNotes.reloadData()
            }
                }
                deleteAction.backgroundColor = .red
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                return configuration
    }
    //MARK: Button methods
    @IBAction func btnWrite(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "WriteNoteStory") as! WriteNotesVC
        vc.isFromWrite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

