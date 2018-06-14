//
//  ViewController.swift
//  d02
//
//  Created by Audrey ROEMER on 3/28/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newNote: Note?
    
    var notes = [
        Note(name: "Donald Trump", date: "05/12/2018 12:12", description: "Burried alived by Martin L. King's granddaughter"),
        Note(name: "Jack Dawson", date: "05/31/1911 07:30", description: "The iceberg was pretty huge Dude"),
        Note(name: "Superman", date: "12/02/2042 22:22", description: "Crashed by a meteorite")
    ]
    
    @IBOutlet weak var tableView: UITableView!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeathNote", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.note = note
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Death Note"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destController = segue.destination as! SecondViewController
                let selectedNote = notes[indexPath.row]
                destController.noteToEdit = selectedNote
            }
        }
    }
    
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue)
    {
        notes.append(newNote!)
        tableView.beginUpdates()
        tableView.insertRows(at: [NSIndexPath(row: notes.count-1, section: 0) as IndexPath], with: .automatic)
        tableView.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


