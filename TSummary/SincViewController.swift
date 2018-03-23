import UIKit

class SincViewController: UIViewController {

    var idAbogado: Int32 = 0
    
    @IBOutlet weak var lblTextUltSinc: UILabel!
    @IBOutlet weak var btnSincronizar: UIButton!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var cancel : Bool = true
    
    @IBAction func btnSincronizar(_ sender: Any)
    {
        btnSincronizar.isEnabled =  false
        activityView.startAnimating()
        
        ControladorLogica.instance.sincronizar(SessionLocal.shared, { (response: Response) in
            
            self.mostrar(mensaje: response.mensaje)
            
            if (response.redirect)
            {
                if (response.result)
                {
                    self.cancel = true
                    let now = Utils.toStringFromDate(Date(), "yyyy-MM-dd HH:mm:ss")
                    FileConfig.instance.saveWith(key: "fechaSinc",
                         value: now,
                         result: { (value: Bool) in
                            print("value successfully saved into plist.")
                    })
                    
                    DispatchQueue.main.async {
                        self.btnSincronizar.isEnabled =  true
                        self.activityView.stopAnimating()
                        self.mostrar(mensaje: "")
                        self.lblTextUltSinc.text = "Ult Sinc: \(now)"
                    }
                }
                else
                {
                    self.cancel = false
                    DispatchQueue.main.async {
                        self.btnSincronizar.isEnabled =  true
                        self.activityView.stopAnimating()
                        self.mostrarMensaje("Error en la sincronización")
                    }
                }
            }
        })
    }
    
    func mostrar(mensaje: String)
    {
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync
            {
                self.lblProgress.text = mensaje
            }
        })
    }
    
    fileprivate func mostrarMensaje(_ mensaje: String = "")
    {
        let alert = UIAlertController(title: "Alerta",
                                      message: mensaje,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Ok")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func redirect()
    {
        DispatchQueue.main.async {
            self.btnSincronizar.isEnabled = true
            self.performSegue(withIdentifier: "irSincronizarSchedulerSegue", sender: self.idAbogado)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Sincronizar"
        
        let fechaSincronizada = FileConfig.instance.fetch(key: "fechaSinc")
        lblTextUltSinc.text = "Ult Sin: \(fechaSincronizada)"
    
        self.activityView.isHidden = true
        self.activityView.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let viewController = segue.destination as! SchedulerViewController
        viewController.idAbogado = self.idAbogado
        viewController.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
        viewController.indexSemana = 1
        viewController.reloadRegistroHoras()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return self.cancel
    }
    */
 }
