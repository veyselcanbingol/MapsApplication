//
//  ListViewController.swift
//  MapsApplication
//
//  Created by Veysel Can Bingöl on 4.06.2022.
//

import UIKit
import CoreData
 

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var noteArray = [String]()
    var idArray = [UUID]()
    
    var choosenLocName = ""
    var choosenLocNote = ""
    var choosenLocId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        
        getData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("createdNewLocation"), object: nil)
    }
    
    @objc func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                
                nameArray.removeAll(keepingCapacity: false)
                noteArray.removeAll(keepingCapacity: false)
                idArray.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        nameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    if let note = result.value(forKey: "note") as? String {
                        noteArray.append(note)
                    }
                }
                tableView.reloadData()
            }
        } catch {
            print("Error!")
            
        }
        
        
    }
    
    @objc func addLocation() {
        choosenLocName = ""
        choosenLocNote = ""
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenLocName = nameArray[indexPath.row]
        choosenLocNote = noteArray[indexPath.row]
        choosenLocId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMapsVC") {
            let destionationVC = segue.destination as! MapsViewController
            destionationVC.choosenName = choosenLocName
            destionationVC.choosenNote = choosenLocNote
            destionationVC.choosenId = choosenLocId
            
        }
    }
}
