	import UIKit
class LoginViewController: UIViewController
{
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var lblVerApp: UILabel!

    var idAbogado: Int32 = 0
    public var entrar: Bool = false
    private var defaults : Int = 1
    
    private var isConnected : Bool = false
    public var fDesde : String = ""
    public var fHasta : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "TSummary"
        navigationItem.hidesBackButton = true
        
        self.txtPassword.isSecureTextEntry = true
        self.txtIMEI.isUserInteractionEnabled = false
        self.txtIMEI.text = getUIDevice()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setDataDefaults()
        
        self.fDesde = Utils.toStringFromDate(DateCalculator.instance.fechaInicio, "yyyyMMdd")
        self.fHasta = Utils.toStringFromDate(DateCalculator.instance.fechaTermino, "yyyyMMdd")
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        statusManager()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.txtIMEI.isHidden = true
        self.btnEliminar.isHidden = true
        
        self.lblVerApp.isHidden = false
        self.lblVerApp.text = "Version: \(Bundle.main.releaseVersionNumber!) Build: \(Bundle.main.buildVersionNumber!)"
        self.lblVerApp.isHidden = false
        self.txtIMEI.text = getUIDevice()
        
        self.defaults = !entrar ? 1 : 0
        btnRegistrar.setTitle( !entrar ? "Registrar" : "Entrar", for: .normal)
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
    
    func getSessionBy(imei: String = "", userName: String = "", password: String = "", defecto: Int = 0) -> SessionLocal?
    {
        return ControladorLogica.instance.obtSessionLocal(userName: userName, password: password, imei: imei, defaults: defecto)
    }
    
    func autentificar(_ sesionLocal: SessionLocal)
    {
        btnRegistrar.isEnabled = false
        self.activity.startAnimating()
        if self.isConnected
        {
            if (sesionLocal.isExpired())
            {
                ApiClient.instance.getNewToken(imei: sesionLocal.usuario?.imei, id: sesionLocal.usuario?.idAbogado, callback: { (sesionLocal : AnyObject?) in
                    if let nuevaSesionLocal = sesionLocal as? SessionLocal
                    {
                        ControladorLogica.instance.actualizarSesionLocal(nuevaSesionLocal)
                        self.sincronizar(nuevaSesionLocal)
                    }
                })
            }
            else
            {
                self.sincronizar(sesionLocal)
            }
        }
        else
        {
            redireccionar(response: Response(estado: 1, mensaje: "Puede entrar", result: true, redirect: true))
        }
        
    }
    
    func refresh(mensaje: String)
    {
        DispatchQueue.main.async
        {
            self.activity.stopAnimating()
            self.btnRegistrar.isEnabled = true
            self.mostrarMensaje(mensaje: mensaje)
        }
    }
    
    func setDataDefaults()
    {
        self.txtPassword.text = ""
        self.txtUserName.text = ""
    }
    
    func getUIDevice() -> String
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    		
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
 
    func isValidInput() -> Bool
    {
        var mensaje : String = ""
        if txtUserName.text?.isEmpty ?? false {
            mensaje = "Nombre de usuario vacio"
        }

        if txtPassword.text?.isEmpty ?? false {
            mensaje = mensaje + "\n" + "contraseña vacia"
        }
    
        if self.txtIMEI.text?.isEmpty ?? false {
            mensaje = mensaje + "\n" + "imei vacio"
        }
        
        return (mensaje == "")
    }
    
    fileprivate func registrar(_ _userName: String,_ _password: String,_ _imei: String)
    {
        let os = ProcessInfo().operatingSystemVersion
        let strVersionSistemaOperativo : String = "iOS >= (\(os.majorVersion),\(os.minorVersion),\(os.patchVersion))"
        
        ApiClient.instance.registrar(
            imei: _imei,
            userName: _userName,
            password: _password,
            equipo: strVersionSistemaOperativo,
            callback: { (sessionLocal: AnyObject?) -> Void in
                if let session = sessionLocal as? SessionLocal
                {
                    session.usuario?.defaults = self.defaults
                    let resp = ControladorLogica.instance.guardarSesionLocal(session)
                    if resp
                    {
                        self.descargar(session)
                    }
                }
                else
                {
                    self.refresh(mensaje: (sessionLocal as! String))
                }
            }
        )
    }
    
    func descargar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.idAbogado = u.idAbogado
            ControladorLogica.instance.descargar(
                session: session,
                fDesde: fDesde,
                fHasta: fHasta,
                redirect: self.redireccionar
            )
        }
    }
    
    func sincronizar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.idAbogado = u.idAbogado
            if self.isConnected
            {
                ControladorLogica.instance.sincronizar(session, self.redireccionar)
            }
            else
            {
                redireccionar(response: Response(estado: 1, mensaje: "Sin conexion a internet", result: true, redirect: false))
            }
        }
    }
    
    func redireccionar(response : Response)
    {
        if (response.result)
        {
            DispatchQueue.main.async(execute:
                {
                    self.btnRegistrar.isEnabled = true
                    self.activity.stopAnimating()
                
                    if self.idAbogado != 0
                    {
                        self.performSegue(withIdentifier: "irLoginSchedulerSegue", sender: self.idAbogado)
                    }
                }
            )
        }
        else
        {
            DispatchQueue.main.async
            {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
            }
        }
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller = segue.destination as! SchedulerViewController
        let fecha = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
        controller.idAbogado = sender as! Int32
        controller.fechaHoraIngreso = fecha
        controller.indexSemana = 1
        controller.reloadRegistroHoras()
    }
    
    @IBAction func registrar(_ sender: Any)
    {
        if isValidInput()
        {
            DispatchQueue.main.async {
                self.activity.startAnimating()
                self.btnRegistrar.isEnabled = false
            }
            
            let userName = txtUserName.text!
            let password = txtPassword.text!
            let imei = txtIMEI.text!
            
            if let sesionLocal = getSessionBy(imei: imei, userName: userName, password: password)
            {
                self.autentificar(sesionLocal)
            }
            else
            {
                if (self.isConnected)
                {
                    self.registrar(userName, password, imei)
                }
                else
                {
                    self.mostrarMensaje(mensaje: "Sin acceso a internet para registrar su cuenta!!")
                }
            }
        }
        else
        {
            self.mostrarMensaje(mensaje: "Ingreso incorrecto!")
        }
    }
    
    @IBAction func btnDeleteOnClick(_ sender: Any)
    {
        self.btnEliminar.isEnabled = false
        self.activity.startAnimating()
        DispatchQueue.main.async {
            ControladorLogica.instance.eliminarDatos()
            self.activity.stopAnimating()
            self.btnEliminar.isEnabled = true
        }
    }
    
}
