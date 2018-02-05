import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnEliminar: UIButton!
    var codigo: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.txtPassword.isSecureTextEntry = true
        self.activity.center = self.view.center
        
        self.txtIMEI.isUserInteractionEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.txtIMEI.text = getUIDevice()
        setDataDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        validar(getUIDevice())
    }
    
    func validar(_ imei: String)
    {
        if let s = ControladorLogica.instance.validar(imei)
        {
            self.activity.startAnimating()
            sincronizar(s)
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
    
    fileprivate func autentificar() {
        
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
                    if let session = ControladorLogica.instance.autentificar(user, password, imei)
                    {
                        sincronizar(session)
                    }
                    else
                    {
                        ApiClient.instance.registrar(
                            imei: imei,
                            userName: user,
                            password: password,
                            callback: self.setUsuario
                        )
                    }
                }
            }
        }
    }
    
    @IBAction func registrar(_ sender: Any) {
        autentificar()
    }
    
    func setUsuario(session: SessionLocal?)
    {
        if let session = session
        {
            let response = ControladorLogica.instance.guardar(session)
            if (response)
            {
                self.sincronizar(session)
            }
        }
    }
    
    func sincronizar(_ session: SessionLocal)
    {
        if let u = session.usuario
        {
            self.codigo = u.id
            if Reachability.isConnectedToNetwork() {
                self.sincronizar(session, callback: redireccionar)
            }
            else
            {
                redireccionar(estado: true)
            }
        }
    }
    
    func redireccionar(estado: Bool)
    {
        if (estado)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                self.performSegue(withIdentifier: "schedulerSegue", sender: self.codigo)
            }
        }
    }
    
    func sincronizar(_ session: SessionLocal, callback: @escaping (Bool) -> Void)
    {
        ControladorLogica.instance.sincronizar(session, callback)
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
