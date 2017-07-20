//
//  ReportTableViewController.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import CloudKit

class ReportTableViewController: UITableViewController {
    
    var reportStore: ReportStore!
    var refresh: UIRefreshControl!
    var NamesArray:  Array<CKRecord> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let users: [UserProfile] = PersistanceManager.fetchDataUserProfile()
        PersistanceManager.clearAllReportHistory()
        reportStore = ReportStore()
        NSLog(users.description)
        if users.isEmpty {
            NSLog("Errore qui")
            if let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeView") {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else {
            refresh = UIRefreshControl()
            refresh.attributedTitle = NSAttributedString(string: "Pull to resfresh")
            refresh.addTarget(self, action: "refreshData", for: UIControlEvents.valueChanged)
            
            tableView.addSubview(refresh!)
            refresh.beginRefreshing()
            
            clearRows()
            NSLog("Reload Topics")
            reloadTopics()
            NSLog("Reload Data")
            refreshData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func clearRows() {
        if reportStore.array.count != 0 {
            for _ in 0...reportStore.array.count {
                tableView.deleteRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
            }
        }
    }
    
    func refreshData() {
        NamesArray = []
        NSLog("Richiesta refresh data")
        NSLog("Reload Notifiche")
        NamesArray = Array<CKRecord>()
        let ourDataPublicDataBase = CKContainer.default().publicCloudDatabase
        let numeroDiTelefono: String?
        if PersistanceManager.fetchDataUserProfile().isEmpty == false && PersistanceManager.fetchDataUserProfile().first?.isSet == true {
            numeroDiTelefono = PersistanceManager.fetchDataUserProfile().first?.address!
        } else {
            numeroDiTelefono = "0"
        }
        NSLog("Numero di telefono prelevato: \(numeroDiTelefono!)")
        //in order to see our data value: true
        let ourPredicate = NSPredicate(format: "topic_id = '\(numeroDiTelefono!)'")
        
        let ourQuery = CKQuery(recordType: "Notifiche", predicate: ourPredicate)
        
        ourQuery.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        NSLog("Fatto il sort")
        ourDataPublicDataBase.perform(ourQuery, inZoneWith: nil) { (results, error) in
        NSLog("Fatta query")
            if error != nil {
                print("Error \(error.debugDescription)")
            }
            else{
                var x = 0
                for results2 in results!{
                    self.NamesArray.append(results2)
                    NSLog("Reload Reports")
                    print(results2["name"])
                    x = x + 1
                    print(x)
                    
                }
                self.reloadReports()
                OperationQueue.main.addOperation({ () -> Void in
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.refresh?.endRefreshing()
                })
                
            }
        }
        
    }
    
    func reloadTopics() {
        var topics = Array<CKRecord>()
        let ourDataPublicDataBase = CKContainer.default().publicCloudDatabase
        
        //in order to see our data value: true
        let numeroDiTelefono = PersistanceManager.fetchDataUserProfile().first?.address
        NSLog(String(describing: numeroDiTelefono!))
        
        //in order to see our data value: true
        let ourPredicate = NSPredicate(format: "Iscritto = '\(numeroDiTelefono!)'")
        
        let ourQuery = CKQuery(recordType: "Topics", predicate: ourPredicate)
        
        ourQuery.sortDescriptors = [NSSortDescriptor(key: "Iscritto", ascending: false)]
        NSLog("Fatto il sort topics")
        NSLog(ourQuery.sortDescriptors!.description)
        ourDataPublicDataBase.perform(ourQuery, inZoneWith: nil) { (results, error) in
            NSLog("Fatta query topics")
            if error != nil {
                print("Error \(error.debugDescription)")
            }
            else{
                for results2 in results!{
                    topics.append(results2)
                    NSLog("SONO QUI")
                    //print(results2)
                    let numeroDiTelefonoIscritto = results2.value(forKey: "Proprietario") as! String
                    NotificationManager.subscribe(numeroDiTelefonoIscritto)
                    //DA AGGIUNGERE RELOADS TOPICS
                }
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.refresh?.endRefreshing()
                })
                
            }
        }
    }
    
    
    func reloadReports() {
        
        for notifica in NamesArray {
            let report = Report(
                name: String(describing: notifica.value(forKey: "name")!),
                surname: String(describing: notifica.value(forKey: "surname")!),
                isMine: false,
                phoneNumber: String(describing: notifica.value(forKey: "telephone")!),
                message: String(describing: notifica.value(forKey: "message")!),
                creationDate: String(describing: notifica["creationDate"]!),
                clinicalFolder: ClinicalFolder(sesso: String(describing: notifica.value(forKey: "sex")),
                                               dataDiNascita: String(describing: notifica.value(forKey: "birthday")!),
                                               altezza: String(describing: notifica.value(forKey: "height")),
                                               peso: String(describing: notifica.value(forKey: "weight")),
                                               gruppoSanguigno: String(describing: notifica.value(forKey: "bloodGroup")),
                                               fototipo: String(describing: notifica.value(forKey: "fototipo")),
                                               sediaARotelle: String(describing: notifica.value(forKey: "wheelchair")),
                                               ultimoBattito: String(describing: notifica.value(forKey: "heartrate"))))
            report.audioMessage = notifica["audioMessage"] as? CKAsset
            NSLog("-----------SALVO REPORT------------")
            NSLog(report.name)
            NSLog(report.message)
            NSLog(report.creationDate.description)
            self.addReport(toAdd: report)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callSOS(_ sender: UIBarButtonItem) {
        SOS.callSOS(self.navigationController)
      //  present(SOS.callSOS(self.navigationController), animated: true, completion: nil)
    }
    
    func addReport(toAdd: Report) {
        reportStore.addReport(report: toAdd)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reportStore.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        let currentReport = reportStore.array[indexPath.row]
        cell.dateField.text = currentReport.creationDate.description
        cell.nameField.text = currentReport.name
        if currentReport.isMine {
            cell.nameField.textColor = UIColor.blue
            cell.dateField.textColor = UIColor.blue
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            reportStore.removeReport(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        reportStore.reorder(from: fromIndexPath.row, to: to.row)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "show"? :
            if let currentindex = tableView.indexPathForSelectedRow?.row {
                let currentReport = reportStore.array[currentindex]
                let dstView = segue.destination as! ReportDetailViewController
                dstView.currentReport = currentReport
            }
        default :
            if let currentindex = tableView.indexPathForSelectedRow?.row {
                let currentReport = reportStore.array[currentindex]
                let dstView = segue.destination as! ReportDetailViewController
                dstView.currentReport = currentReport
            }
        }
    }
   

}
