import UIKit

class SplashScreenViewController: UIViewController {

    private var isConnected : Bool = false
    var idAbogado : Int32 = 0
    
    @IBOutlet weak var lblProgress: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        statusManager()
        
        //DispatchQueue.global().async  {
        self.showNavController()
        //}
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNavController()
    {
        self.autentificar(imei: self.getUIDevice(), defecto: 1)
    }
    
    func getSessionBy(imei: String, userName: String, password: String, defecto: Int = -1) -> SessionLocal?
    {
        return ControladorLogica.instance.obtSessionLocal(userName: userName, password: password, imei: imei, defecto: defecto)
    }
   
    func getUIDevice() -> String
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    @objc func statusManager()
    {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            self.isConnected = false
        case .wifi, .wwan:
            self.isConnected = true
        }
    }
    
    func autentificar(imei: String, userName: String = "", password: String="", defecto: Int = -1)
    {
        self.lblProgress.text = "Comprobando sesion..."
        if let session = getSessionBy(imei: imei, userName: userName, password: password, defecto: defecto)
        {
            if (!session.isExpired())
            {
                self.sincronizar(session)
            }
            else
            {
               self.lblProgress.text = "Generando nuevo token de sesion..."
                let user = session.usuario?.loginName
                let password = session.usuario?.password
                
                if self.isConnected
                {
                    ApiClient.instance.registrar(
                        imei: imei,
                        userName: user,
                        password: password,
                        callback: { (sessionLocal : AnyObject?) in
                            if let session = sessionLocal as? SessionLocal
                            {
                                let resp = self.guardar(session)
                                if resp
                                {
                                    self.sincronizar(session)
                                }
                            }
                            else
                            {
                                self.refresh(mensaje: (sessionLocal as! String))
                            }
                    }
                    )
                }
                else
                {
                    self.refresh(mensaje: "Sin conexión a internet")
                }
            }
        }
        else
        {
            performSegue(withIdentifier: "irSplashScreenLoginSegue", sender: nil)
        }
    }

    private func guardar(_ session: SessionLocal) -> Bool
    {
        return ControladorLogica.instance.guardar(session)
    }

    func sincronizar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.idAbogado = u.id
            if self.isConnected
            {
                ControladorLogica.instance.sincronizar(session, self.redireccionar)
            }
            else
            {
                performSegue(withIdentifier: "irSplashScreenSchedulerSegue", sender: self.idAbogado)
            }
        }
    }

    func redireccionar(response : Response)
    {
        mostrar(mensaje: response.mensaje)
        if (response.redirect)
        {
            if (response.result)
            {
                if self.idAbogado != 0
                {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "irSplashScreenSchedulerSegue", sender: self.idAbogado)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "irSplashScreenLoginSegue", sender: nil)
                }
            }
        }
    }
    
    func refresh(mensaje: String)
    {
        DispatchQueue.main.async 
        {
            self.mostrarMensaje(mensaje: mensaje)
        }
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
    
    fileprivate func mostrarMensaje(mensaje: String = "")
    {
        let alert = UIAlertController(title: "Alerta",
                                      message: mensaje,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Ok")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let identifier : String = segue.identifier!
        switch identifier
        {
            case "irSplashScreenLoginSegue":
                let controller = segue.destination as! LoginViewController
                controller.entrar = false
            case "irSplashScreenSchedulerSegue" :
                let controller = segue.destination as! SchedulerViewController
                let fecha = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
                controller.idAbogado = sender as! Int32
                controller.fechaHoraIngreso = fecha
                controller.indexSemana = 1
                controller.reloadRegistroHoras()
            default:
                print("")
        }
    }

}
