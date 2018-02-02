//
//  SemanaViewController.swift
//  tsummary
//
//  Created by OTRO on 02-02-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import UIKit

class SemanaViewController: UIViewController {

    
    @IBOutlet weak var txtCantSemanas: UITextField!
    
    var cantidadSemanas: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtCantSemanas.text = String(cantidadSemanas)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ajustesSegue"
        {
            //let controller = segue.destination as! AjustesViewController
        }
    }
    
    @IBAction func btnGuardar_OnClick(_ sender: Any) {
        self.performSegue(withIdentifier: "ajustesSegue", sender: "")
    }
}
