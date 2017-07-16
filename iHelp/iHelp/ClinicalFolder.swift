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
    var dataDiNascita: String?
    var altezza: String?
    var peso: String?
    var gruppoSanguigno: String?
    var fototipo: String?
    var sediaARotelle: String?
    var ultimoBattito: String?
    
    
    init(sesso: String, dataDiNascita: String, altezza: String, peso: String, gruppoSanguigno: String, fototipo: String, sediaARotelle: String, ultimoBattito: String) {
        self.sesso = sesso
        self.dataDiNascita = dataDiNascita
        self.altezza = altezza
        self.peso = peso
        self.gruppoSanguigno = gruppoSanguigno
        self.fototipo = fototipo
        self.sediaARotelle = sediaARotelle
        self.ultimoBattito = ultimoBattito
    }
    
    
}
