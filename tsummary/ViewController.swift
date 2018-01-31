import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtIMEI: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
   
    var codigo: Int = 0
    
    @IBOutlet weak var btnEliminar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.txtPassword.isSecureTextEntry = true
        self.activity.center = self.view.center
        self.txtLoginName.text = "carlos_tapia"
        self.txtPassword.text = "Car.2711"
        self.txtIMEI.text = getUIDevice()
        self.txtIMEI.isUserInteractionEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        autentificar()
    }
    
    func getUIDevice() -> String
    {
        return "863166032574597" //UIDevice.current.identifierForVendor!.uuidString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func autentificar() {
        btnRegistrar.isEnabled = false
        self.activity.startAnimating()
        if let usuario = ControladorLogica.instance.autentificar(self.txtLoginName.text!, self.txtPassword.text!, self.txtIMEI.text!)
        {
            sincronizar(usuario)
        }
        else
        {
            ApiClient.instance.registrar(
                imei: txtIMEI.text,
                userName: self.txtLoginName.text,
                password: self.txtPassword.text,
                callback: self.setUsuario
            )
        }
    }
    
    @IBAction func registrar(_ sender: Any) {
        autentificar()
    }
    
    func setUsuario(usuario: Usuario?)
    {
        if let u = usuario
        {
            let response = ControladorLogica.instance.guardar(u)
            if (response)
            {
                self.sincronizar(u)
            }
        }
    }
    
    func sincronizar(_ usuario: Usuario)
    {
        self.codigo = Int(usuario.Id)
        self.sincronizar(usuario, callback: redireccionar)
    }
    
    func redireccionar(estado: Bool)
    {
        if (estado)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                let scheduler = self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
                scheduler.idAbogado = self.codigo
                self.navigationController?.pushViewController(scheduler, animated: true)
            }
        }
    }
    
    func sincronizar(_ usuario: Usuario, callback: @escaping (Bool) -> Void)
    {
        ControladorLogica.instance.sincronizar(usuario, callback)
    }

    @IBAction func btnDeleteOnClick(_ sender: Any)
    {
        self.btnEliminar.isEnabled = false
        self.activity.startAnimating()
        DispatchQueue.main.async {
            ControladorLogica.instance.eliminarTodo()
            self.activity.stopAnimating()
            self.btnEliminar.isEnabled = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
