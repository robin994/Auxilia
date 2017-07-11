//
//  ReportStore.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import UIKit

class ReportStore: NSObject {
    var array:[Report] = []
    
    
    func addReport(report : Report) {
        array.append(report)
    }
    
    func createEmptyReport() {
        let report = Report.init(name: "Empty")
        array.append(report)
    }
    
    func removeReport(report : Report) {
        array.remove(at: array.index(of: report)!)
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