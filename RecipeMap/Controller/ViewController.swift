//
//  ViewController.swift
//  RecipeMap
//
//  Created by Esna nur Yılmaz on 29.07.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "toKategoriler", sender: nil)
    }
}

