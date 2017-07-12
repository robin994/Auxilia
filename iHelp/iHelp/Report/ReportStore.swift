//
//  ReportStore.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit
import Contacts

class ReportStore: NSObject {
    var array:[Report] = []
    
    
    func addReport(report : Report) {
        PersistanceManager.newReportHistory(toAdd: report)
        array.append(report)
    }
    
    func reloadSavedReports() {
        for report in PersistanceManager.fetchDataReportHistory() {
            let contact = ContactStore.getCNContact(report.contactIdentifier!)
            array.append(Report(name: report.name!, isMine: report.isMine, contact: contact!, message: report.message!))
        }

        
    }
    
    func removeReport(at: Int) {
        if PersistanceManager.removeReportHistory(toRemove: array[at]) {
            array.remove(at: at)
            NSLog("Report rimosso con successo")
        } else {
            NSLog("Report non rimosso")
        }
    }

    func sortByNameCresc() {
        array = array.sorted { $0.name < $1.name }
    }
    
    func sortByNameDec() {
        array = array.sorted { $0.name > $1.name }
    }
    
    func reorder(from: Int , to: Int) {
        let foo: Report = array[from]
        array.remove(at: from)
        array.insert(foo, at: to)
    }
}
