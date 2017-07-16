//
//  ClinicalFolder.swift
//  iHelp
//
//  Created by Korniychuk Alina on 16/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
class ClinicalFolder: NSObject {
    var sesso: String?
    var dataDiNascita: Date?
    var altezza: Float?
    var peso: Float?
    var gruppoSanguigno: String?
    var sediaARotelle: Bool?
    var ultimoBattito: String?
    
    
    init(sesso: String, dataDiNascita: Date, altezza: Float, peso: Float, gruppoSanguigno: String, sediaARotelle: Bool, ultimoBattito: String) {
        self.sesso = sesso
        self.dataDiNascita = dataDiNascita
        self.altezza = altezza
        self.peso = peso
        self.gruppoSanguigno = gruppoSanguigno
        self.sediaARotelle = sediaARotelle
        self.ultimoBattito = ultimoBattito
    }
    
    
}
