//
//  KategorilerViewController.swift
//  RecipeMap
//
//  Created by Esna nur Yılmaz on 30.07.2024.
//

import UIKit
import Firebase

class KategorilerViewController: UIViewController {

    @IBOutlet weak var kategorilerTableview: UITableView!
    var kategoriListesi = [Kategoriler]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kategorilerTableview.dataSource = self
        kategorilerTableview.delegate = self
        ref = Database.database().reference()
        kategorilerTableview.rowHeight = UITableView.automaticDimension
        kategorilerTableview.estimatedRowHeight = 90
        tumaKategorileriAl()
    }
        func tumaKategorileriAl(){
            ref.child("KATEGORİLER").observe(.value, with: { snapshot in
                if let gelenVeri = snapshot.value as? [Any]{
                    self.kategoriListesi.removeAll()
                    for case let kategoriData as [String: Any] in gelenVeri where kategoriData != nil {
                        if let kategoriAd = kategoriData["kategoriAd"] as? String,
                           let kategoriID = kategoriData["kategoriId"] as? String {
                            let kategori = Kategoriler(kategoriAd: kategoriAd, kategoriId: kategoriID)
                            self.kategoriListesi.append(kategori)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.kategorilerTableview.reloadData()
                }
            })
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toYemekler",
           let indeks = sender as? Int,
           let gidilecekVC = segue.destination as? YemeklerViewController {
            gidilecekVC.yemekler = kategoriListesi[indeks]
        }
    }
}
extension KategorilerViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return kategoriListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kategoriler = kategoriListesi[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "kategoriHucre", for: indexPath) as! KategorilerTableViewCell
        cell.kategorilerLabel.text = kategoriler.kategoriAd
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toYemekler", sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
