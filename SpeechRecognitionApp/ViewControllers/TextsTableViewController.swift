//
//  TextsTableViewController.swift
//  SpeechRecognitionApp
//
//  Created by Алексей Синяговский on 21.06.2022.
//

import UIKit

class TextsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let celID = "Cell"
    let segueID = "showTextSegue"
    let texts = [
        ("About me", "Hi all! My name is Alex, I'm 28 years old. I study Chinese"),
        ("My school day", "My lessons at school begin at 8:15. I usually have 4 or 5 lessons a day. And at noon or at 1 o’clock I go home"),
        ("My foreign friend", "I have a foreign friend. His name is James. He is from London. Every month I write letters to him. And he writes letters to me. We are both 10 years old, but we are very different.")
    ]
    
    var selectedText = ("","")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celID, for: indexPath)
        cell.textLabel?.text = texts[indexPath.row].0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = texts[indexPath.row]
        performSegue(withIdentifier: segueID, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TextViewController {
            destinationVC.text = selectedText
        }
    }

}
