//
//  ViewController.swift
//  tsummary
//
//  Created by Soporte on 30-11-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        
        txtPassword.isSecureTextEntry = true
        
        //BtnRegistrar?.titleLabel?.textColor = UIColor.black
        //navigationItem.title = "LogIn"
        //navigationController?.navigationBar.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var BtnRegistrar: UIButton!
    
    @IBAction func Registrar(_ sender: Any) {
        //let ws: WSTimeSummary = WSTimeSummary()
        //ws.registrar(imei: "863166032574597", userName: txtLoginName.text, password:txtPassword.text, callback: buscarUsuario)
        //WSTimeSummary.Instance.getListDetalleHorasByCodAbogado(codigo: "20", callback: loadHoras)
        sincronizar(codigo: "20")
    }
    
    func buscarUsuario(u: Usuario?)
    {
        if (u != nil)
        {
            do
            {
                //try LocalStoreTimeSummary.Instance.createTables()
                //LocalStoreTimeSummary.Instance.deleteTables()
                //LocalStoreTimeSummary.Instance.save(usuario: u!)
                //var usuario: Usuario? = LocalStoreTimeSummary.Instance.getUsuarioByIMEI(imei: "863166032574597")
                sincronizar(codigo: "20")
            }
            catch
            {
                print("Error:\(error)")
            }
        }
   }
    
    func sincronizar(codigo:String)
    {
        ControladorProyecto.Instance.sincronizar(codigo: codigo)
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //self.presentedViewController(vc,animated: true, completion:nil)
    }
}
