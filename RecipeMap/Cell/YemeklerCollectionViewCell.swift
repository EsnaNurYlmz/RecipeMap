//
//  YemeklerCollectionViewCell.swift
//  RecipeMap
//
//  Created by Esna nur Yılmaz on 30.07.2024.
//

import UIKit

protocol YemeklerCollectionViewCellProtocol {
    func Tarif(indexPath:IndexPath)
}

class YemeklerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var yemekImage: UIImageView!
    @IBOutlet weak var yemekAd: UILabel!
    
    var hucreProtocol:YemeklerCollectionViewCellProtocol?
    var indexPath:IndexPath?
    
    @IBAction func yemekTarif(_ sender: Any) {
        hucreProtocol?.Tarif(indexPath: indexPath!)
    }
}
