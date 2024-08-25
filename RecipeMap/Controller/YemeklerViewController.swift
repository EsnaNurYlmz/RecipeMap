//
//  YemeklerViewController.swift
//  RecipeMap
//
//  Created by Esna nur Yılmaz on 30.07.2024.
//

import UIKit
import Firebase

class YemeklerViewController: UIViewController {

    @IBOutlet weak var yemekCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var yemekListesi = [Yemekler]()
    var yemekler : Kategoriler?
    var filtreliYemekListesi = [Yemekler]()
    var ref : DatabaseReference!
    var aramaYapiliyorMu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yemekCollectionView.dataSource = self
        yemekCollectionView.delegate = self
        searchBar.delegate = self
        ref = Database.database().reference()

            let tasarim :UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            let genislik = self.yemekCollectionView.frame.size.width
            tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let hucreGenislik = (genislik-30)/2
            tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik*1.7)
            tasarim.minimumInteritemSpacing = 10
            tasarim.minimumLineSpacing = 10
            yemekCollectionView.collectionViewLayout = tasarim
        
        if let k = yemekler{
            navigationItem.title = k.kategoriAd
            yemekleriGetir(kategoriAd:k.kategoriAd!)
        }
    }
    
    func yemekleriGetir(kategoriAd:String){
        let sorgu = ref.child("YEMEKLER").queryOrdered(byChild: "kategoriAd").queryEqual(toValue: kategoriAd)
        sorgu.observe(.value, with: { snapshot in
            if let gelenVeri = snapshot.value as? [String:AnyObject]{
                self.yemekListesi.removeAll()
                for gelenVeriSatiri in gelenVeri {
                    if let dictionary = gelenVeriSatiri.value as? NSDictionary{
                        let yemekAd = dictionary["yemekAd"] as? String ?? ""
                        let yemekResim = dictionary["yemekResim"] as? String ?? ""
                        let yemekTarif = dictionary["yemekTarif"] as? String ?? ""
                        let  kategoriAd = dictionary["kategoriAd"] as? String ?? ""
                        let yemek = Yemekler(yemekAd: yemekAd, yemekResim: yemekResim, yemekTarif: yemekTarif, kategoriAd: kategoriAd)
                        self.yemekListesi.append(yemek)
                      }
                    }
                self.filtreliYemekListesi = self.yemekListesi

                }
            DispatchQueue.main.async {
                self.yemekCollectionView.reloadData()
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let indeks = sender as? Int
            let gidilecekVC = segue.destination as! TarifViewController
            gidilecekVC.yemekTarif = filtreliYemekListesi[indeks!]
     }
}

extension YemeklerViewController : UICollectionViewDelegate , UICollectionViewDataSource ,
YemeklerCollectionViewCellProtocol {
    
    func Tarif(indexPath: IndexPath) {
        print("Tarif gösterildi.")
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aramaYapiliyorMu ? filtreliYemekListesi.count : yemekListesi.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let yemek = aramaYapiliyorMu ? filtreliYemekListesi[indexPath.row] : yemekListesi[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yemekHucre", for: indexPath) as! YemeklerCollectionViewCell
                cell.yemekAd.text = yemek.yemekAd
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.borderWidth = 0.5
                cell.hucreProtocol = self
                cell.indexPath = indexPath
                return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toTarif", sender: indexPath.row)
    }
}

extension YemeklerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            aramaYapiliyorMu = false
            filtreliYemekListesi = yemekListesi
        } else {
            aramaYapiliyorMu = true
            filtreliYemekListesi = yemekListesi.filter { $0.yemekAd?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        yemekCollectionView.reloadData()
    }
}
