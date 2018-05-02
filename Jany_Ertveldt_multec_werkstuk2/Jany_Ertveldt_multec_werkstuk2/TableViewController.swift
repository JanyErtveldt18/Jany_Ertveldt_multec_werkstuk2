//
//  TableViewController.swift
//  Jany_Ertveldt_multec_werkstuk2
//
//  Created by Jany Ertveldt on 1/05/18.
//  Copyright © 2018 Jany Ertveldt. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UISearchBarDelegate {
    //Tutorial searchbar
    //https://www.youtube.com/watch?v=zgP_VHhkroE
    
 
    var opslagStations:[Station] = []
    @IBOutlet weak var mySearchbarOutlet: UISearchBar!
    var filterStations = [Station]()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchbarOutlet.delegate = self
        mySearchbarOutlet.returnKeyType = UIReturnKeyType.done
        mySearchbarOutlet.placeholder = "Zoek jouw station"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filterStations.count
        }
        // #warning Incomplete implementation, return the number of rows
        return opslagStations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        if isSearching{
           cell.textLabel?.text = filterStations[indexPath.row].naam
            
        }else{
            cell.textLabel?.text = opslagStations[indexPath.row].naam
            cell.detailTextLabel?.text = "Aantal vrije fietsen: \(opslagStations[indexPath.row].beschikbareFietsen)"
        }

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        if mySearchbarOutlet.text == nil || mySearchbarOutlet.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }else{
            isSearching = true
            filterStations = opslagStations.filter({$0.naam == "S"})
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
