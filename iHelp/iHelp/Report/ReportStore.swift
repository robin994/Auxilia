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
        if (!PersistanceManager.isReportAlreadyInside(toCheck: report)) {
            PersistanceManager.newReportHistory(toAdd: report)
            array.append(report)
        }
    }
    
    func reloadSavedReports() {
        for report in PersistanceManager.fetchDataReportHistory() {
            array.append(
                Report(
                    name: report.name!,
                    isMine: report.isMine,
                    phoneNumber: report.contactIdentifier!,
                    message: report.message!,
                    clinicalFolder: ClinicalFolder(sesso: report.sesso!,
                                                   dataDiNascita: report.birthday!,
                                                   altezza: report.height!,
                                                   peso: report.weight!,
                                                   gruppoSanguigno: report.bloodGroup!,
                                                   fototipo: report.fototipo!,
                                                   sediaARotelle: report.wheelchair!,
                                                   ultimoBattito: report.hearthrate!)
                )
            )
        }

        
    }
    
    func removeReport(at: Int) {
        PersistanceManager.removeReportHistory(toRemove: array[at])
        array.remove(at: at)
        NSLog("Report rimosso con successo")
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
