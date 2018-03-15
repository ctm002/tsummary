import UIKit
class LoginViewController: UIViewController
{
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var lblVersionSoftware: UILabel!
    
    var codigo: Int32 = 0
    public var entrar: Bool = false
    private var isConnected : Bool = false
    public var fDesde : String = ""
    public var fHasta : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.center = self.view.center
        navigationItem.title = "Login"
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        if !entrar
        {
            btnRegistrar.setTitle("Registrar", for: .normal)
            autentificar(getUIDevice())
        }
        else
        {
            btnRegistrar.setTitle("Entrar", for: .normal)
        }
        
        self.txtIMEI.isHidden = true
        self.lblVersionSoftware.isHidden = false
        lblVersionSoftware.text = "Version: \(Bundle.main.releaseVersionNumber!) Build: \(Bundle.main.buildVersionNumber!)"
        self.btnEliminar.isHidden = true
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
    
    func autentificar(_ imei: String)
    {
        if let session = ControladorLogica.instance.obtSessionLocal(imei: imei)
        {
            btnRegistrar.isEnabled = false
            self.activity.startAnimating()
            
            if (!session.isExpired())
            {
                self.sincronizar(session)
            }
            else
            {
                let sessionLocal = ControladorLogica.instance.obtSessionLocal()
                let user = sessionLocal?.usuario?.loginName
                let password = sessionLocal?.usuario?.password
                
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
    }
    
    func refresh(mensaje: String)
    {
        DispatchQueue.main.async
        {
            self.activity.stopAnimating()
            self.mostrarMensaje(mensaje: mensaje)
            self.btnRegistrar.isEnabled = true
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
    
    @IBAction func registrar(_ sender: Any)
    {
        registrar()
    }
    
    fileprivate func registrar()
    {
        var mensaje : String!
        
        if txtUserName.text?.isEmpty ?? false {
            mensaje = "Nombre de usuario vacio"
        }
        else
        {
            if txtPassword.text?.isEmpty ?? false {
                mensaje = mensaje + "\n" + "contraseña vacia"
            }
            else
            {
                if self.txtIMEI.text?.isEmpty ?? false {
                    mensaje = mensaje + "\n" + "imei vacio"
                }
                else
                {
                    let user = txtUserName.text!
                    let password = txtPassword.text!
                    let imei = txtIMEI.text!
                    if self.isConnected
                    {
                        self.btnRegistrar.isEnabled = false
                        self.activity.startAnimating()
                        
                        ApiClient.instance.registrar(
                            imei: imei,
                            userName: user,
                            password: password,
                            callback: { (sessionLocal: AnyObject?) -> Void in
                                if let session = sessionLocal as? SessionLocal
                                {
                                    let resp = self.guardar(session)
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
                    else
                    {
                        self.refresh(mensaje: "Sin acceso a internet")
                    }
                }
            }
        }
        
        if let msje = mensaje
        {
            mostrarMensaje(mensaje: msje)
        }
    }
    
    private func guardar(_ session: SessionLocal) -> Bool
    {
        return ControladorLogica.instance.guardar(session)
    }
    
    func descargar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.codigo = u.id
            if self.isConnected
            {
                ControladorLogica.instance.descargar(
                    session: session,
                    fDesde: fDesde,
                    fHasta: fHasta,
                    redirect: self.redireccionar
                )
            }
            else
            {
                self.mostrarMensaje(mensaje: "Sin acceso a internet")
            }
        }
    }
    
    func sincronizar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.codigo = u.id
            if self.isConnected
            {
                 ControladorLogica.instance.sincronizar(session, self.redireccionar)
            }
            else
            {
                redireccionar(response: Response(estado: 1, mensaje: "", result: true))
            }
        }
    }
    
    func redireccionar(response : Response)
    {
        if (response.result)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                if self.codigo != 0
                {
                    self.performSegue(withIdentifier: "irSchedulerSegue", sender: self.codigo)
                }
            }
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
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller = segue.destination as! SchedulerViewController
        controller.idAbogado = sender as! Int
        controller.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
    }
}
