//
//  LoginViewController.swift
//  MapsFirstTime
//
//  Created by Özgür  Elmaslı on 9.03.2019.
//  Copyright © 2019 Özgür  Elmaslı. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var realm = try! Realm()
    var array = [String]()
    var selected_place_name = ""
    var selected_subtitle_name = ""
    var selected_latitude : Double = 0
    var selected_longtitude : Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loaadarray()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.loaadarray), name: NSNotification.Name(rawValue: "newPlace"), object: nil)
    }
    @objc func loaadarray()
    {
        if array.count > 0
        {
            array.removeAll(keepingCapacity: false)
            let arrayofcome = realm.objects(LocationSaver.self)
            for item in arrayofcome
            {
                array.append(item.title!)
            }
            self.tableView.reloadData()
        }
        else
        {
            let arrayofcome = realm.objects(LocationSaver.self)
            for item in arrayofcome
            {
                array.append(item.title!)
            }
        }
    }
    @IBAction func baritemClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showadd", sender: nil	)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count > 0
        {
            return array.count
        }
        else{
                return 1
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showadd"
        {
            if selected_place_name != "" && selected_subtitle_name != "" && selected_longtitude != 0 && selected_latitude != 0
            {
                let DestinationVC = segue.destination as! ViewController
                DestinationVC._place_name = selected_place_name
                DestinationVC._subtitle_name = selected_subtitle_name
                DestinationVC._latitude = selected_latitude
                DestinationVC._longtitude = selected_longtitude
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if array.count > 0
        {
            cell.textLabel?.text = array[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = "Yakınlarda bir kayıt bulunmadı"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_place_name = array[indexPath.row]
        let itemcontrol = realm.objects(LocationSaver.self).filter{$0.title == self.selected_place_name}.first
        selected_subtitle_name = (itemcontrol?.subtitle)!
        selected_latitude = (itemcontrol?.latitude)!
        selected_longtitude = (itemcontrol?.longtitude)!
        performSegue(withIdentifier: "showadd", sender: nil)
    }
    
    
}
