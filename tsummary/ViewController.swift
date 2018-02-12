import UIKit
class ViewController: UIViewController
{

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnEliminar: UIButton!
    var codigo: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.activity.center = self.view.center
        navigationItem.title = "TimeSummary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.txtPassword.isSecureTextEntry = true
        self.txtIMEI.isUserInteractionEnabled = false
        self.txtIMEI.text = getUIDevice()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setDataDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        autentificar(getUIDevice())
    }
    
    func autentificar(_ imei: String)
    {
        if let session = ControladorLogica.instance.obtSessionLocal(imei: imei)
        {
            if (!session.isExpired())
            {
                self.activity.startAnimating()
                self.sincronizar(session)
            }
            else
            {
                let sessionLocal = ControladorLogica.instance.obtSessionLocal()
                let user = sessionLocal?.usuario?.loginName
                let password = sessionLocal?.usuario?.password
                
                ApiClient.instance.registrar(
                    imei: imei,
                    userName: user,
                    password: password,
                    callback:{ (sessionLocal : SessionLocal?) in
                        if let session = sessionLocal
                        {
                            let resp = self.guardar(session)
                            if resp
                            {
                                self.sincronizar(session)
                            }
                        }
                    }
                )
            }
        }
    }
    
    func setDataDefaults(){
        self.txtPassword.text = "Car.2711"
        self.txtUserName.text = "Carlos_Tapia"
    }
    
    func getUIDevice() -> String
    {
        return "863166032574597" //UIDevice.current.identifierForVendor!.uuidString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registrar(_ sender: Any) {
        registrar()
    }
    
    fileprivate func registrar()
    {
        var mensaje : String!
        
        if txtUserName.text?.isEmpty ?? false {
            mensaje = "loginName vacio"
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
                    
                    btnRegistrar.isEnabled = false
                    self.activity.startAnimating()
                    ApiClient.instance.registrar(
                        imei: imei,
                        userName: user,
                        password: password,
                        callback: { (sessionLocal: SessionLocal?) -> Void in
                            if let session = sessionLocal
                            {
                                let resp = self.guardar(session)
                                if resp
                                {
                                    self.descargar(session)
                                }
                            }
                        }
                    )
                }
            }
        }
    }
    
    func guardar(_ session: SessionLocal) -> Bool
    {
        return ControladorLogica.instance.guardar(session)
    }
    
    func descargar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.codigo = u.id
            if Reachability.isConnectedToNetwork()
            {
                let fDesde : String =  "20180101"
                let fHasta : String =  "20181231"
                ControladorLogica.instance.descargar(
                    session: session,
                    fDesde: fDesde,
                    fHasta: fHasta,
                    redirect: self.redireccionar
                )
            }
            else
            {
                self.redireccionar(estado: true)
            }
        }
    }
    
    func sincronizar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.codigo = u.id
            if Reachability.isConnectedToNetwork()
            {
                self.sincronizar(session, callback: self.redireccionar)
            }
            else
            {
                self.redireccionar(estado: true)
            }
        }
    }
    
    func sincronizar(_ session: SessionLocal, callback: @escaping (Bool) -> Void)
    {
        ControladorLogica.instance.sincronizar(session, callback)
    }
    
    func redireccionar(estado: Bool)
    {
        if (estado)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                self.performSegue(withIdentifier: "irSchedulerSegue", sender: self.codigo)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SchedulerViewController
        controller.idAbogado = sender as! Int
        controller.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
    }
}
