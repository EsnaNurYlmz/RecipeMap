//
//  Yemekler.swift
//  RecipeMap
//
//  Created by Esna nur Yılmaz on 31.07.2024.
//

import Foundation

class Yemekler {
    
    var yemekAd : String?
    var yemekResim : String?
    var yemekTarif : String?
    var yemekMalzeme: String?
    var kategoriAd : String?
    
    init(yemekAd: String , yemekResim: String , yemekTarif: String , kategoriAd: String , yemekMalzeme: String) {
        self.yemekAd = yemekAd
        self.yemekResim = yemekResim
        self.yemekTarif = yemekTarif
        self.yemekMalzeme = yemekMalzeme
        self.kategoriAd = kategoriAd
    }
}
