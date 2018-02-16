//
//  SincronizarViewController.swift
//  tsummary
//
//  Created by OTRO on 15-02-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import UIKit

class SincViewController: UIViewController {

    var idAbogado: Int = 0
    

    @IBAction func btnSincronizar(_ sender: Any)
    {
        /*
        Solo testing
        if Reachability.isConnectedToNetwork()
        {
            ControladorLogica.instance.sincronizar(SessionLocal.shared, { (resp: Bool) -> Void in
                print("procesando datos...")
            })
        }
         */
        self.performSegue(withIdentifier: "sincVolverSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sincronizar"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let viewController = segue.destination as! SchedulerViewController
        viewController.idAbogado = self.idAbogado
    }
    

}
