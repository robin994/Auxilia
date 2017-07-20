//
//  ReportClinicalFolderViewController.swift
//  iHelp
//
//  Created by Korniychuk Alina on 19/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//


import UIKit
import Foundation

class ReportClinicalFolderViewController: UITableViewController{
    @IBOutlet weak var sesso: UILabel!
    @IBOutlet weak var dataDiNascita: UILabel!
    
    @IBOutlet weak var altezza: UILabel!
    @IBOutlet weak var peso: UILabel!
    
    @IBOutlet weak var battito: UILabel!
    @IBOutlet weak var fototipo: UILabel!
    @IBOutlet weak var gruppoSanguigno: UILabel!
    @IBOutlet weak var sediaArotelle: UILabel!
    var currentReport: Report!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("ReportClinicalFolderViewController viewDidLoad ")
        sesso.text = currentReport.clinicalFolder.sesso!
        dataDiNascita.text = currentReport.clinicalFolder.dataDiNascita!
        altezza.text = currentReport.clinicalFolder.altezza!
        peso.text = currentReport.clinicalFolder.peso!
        battito.text = currentReport.clinicalFolder.ultimoBattito!
        fototipo.text = currentReport.clinicalFolder.fototipo!
        gruppoSanguigno.text = currentReport.clinicalFolder.gruppoSanguigno!
        sediaArotelle.text = currentReport.clinicalFolder.sediaARotelle!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
}
