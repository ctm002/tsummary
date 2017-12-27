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
    @IBOutlet weak var BtnRegistrar: UIButton!
    var codigo: Int = 0
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        txtPassword.isSecureTextEntry = true
        
        self.activity.center = self.view.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Registrar(_ sender: Any) {
        BtnRegistrar.isEnabled = false
        self.activity.startAnimating()
        WSTimeSummary.instance.registrar(imei: "863166032574597", userName: self.txtLoginName.text, password: self.txtPassword.text, callback: self.getUsuario)
        
       
    }
    
    func getUsuario(u: Usuario?)
    {
        if (u != nil)
        {
            do
            {
                self.codigo =  Int(u!.Id)
                sincronizar(String(self.codigo))
                
                DispatchQueue.main.async {
                   self.BtnRegistrar.isEnabled = true
                    self.activity.stopAnimating()
                    let vc =  self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
                    vc.IdAbogado =  self.codigo
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            catch
            {
                print("Error:\(error)")
            }
        }
   }
    
    func sincronizar(_ codigo:String)
    {
        ControladorProyecto.instance.sincronizar(codigo)
    }
}
