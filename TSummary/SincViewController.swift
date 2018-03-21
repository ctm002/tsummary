import UIKit

class SincViewController: UIViewController {

    var idAbogado: Int32 = 0
    
    @IBOutlet weak var lblTextUltSinc: UILabel!
    @IBOutlet weak var btnSincronizar: UIButton!
    
    @IBAction func btnSincronizar(_ sender: Any)
    {
        btnSincronizar.isEnabled =  false
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.view.addSubview(activityView)
        activityView.center = self.view.center
        activityView.color  = UIColor.red
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        activityView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        activityView.startAnimating()
        
        ControladorLogica.instance.sincronizar(SessionLocal.shared, { (resp: Response) -> Void in
            if (resp.result)
            {
                FileConfig.instance.saveWith(key: "fechaSinc",
                    value: Utils.toStringFromDate(Date(), "yyyy-MM-dd HH:mm:ss"),
                    result: { (value: Bool) in
                        print("Value successfully saved into plist.")
                })
                self.redirect()
            }
            else
            {
                self.mostrarMensaje("Sin conexion para la sincronización")
                self.btnSincronizar.isEnabled =  true
                activityView.stopAnimating()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.btnSincronizar.isEnabled = true
            self.performSegue(withIdentifier: "sincVolverSegue", sender: nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Sincronizar"
        
        let fechaSincronizada = FileConfig.instance.fetch(key: "fechaSinc")
        lblTextUltSinc.text = "Ult Sinc: \(fechaSincronizada)"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let viewController = segue.destination as! SchedulerViewController
        viewController.idAbogado = self.idAbogado
        viewController.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
        viewController.indexSemana = 1
        viewController.reloadRegistroHoras()
    }

}
