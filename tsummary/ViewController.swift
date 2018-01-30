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
        
        //datos de pruebas
        self.txtLoginName.text = "carlos_tapia"
        self.txtPassword.text = "Car.2711"
        self.txtIMEI.text = getUIDevice()
        self.txtIMEI.isUserInteractionEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func getUIDevice() -> String
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registrar(_ sender: Any) {
        btnRegistrar.isEnabled = false
        self.activity.startAnimating()
        
        ApiClient.instance.registrar(
            imei: "863166032574597",
            userName: self.txtLoginName.text,
            password: self.txtPassword.text,
            callback: self.sincronizar
        )
    }
    
    func sincronizar(usuario: Usuario?)
    {
        if let u = usuario {
            self.codigo = Int(u.Id)
            self.sincronizar(u, callback: redireccionar)
        }
    }
    
    func redireccionar(estado: Bool)
    {
        if (estado)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                let scheduler = self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
                scheduler.IdAbogado = self.codigo
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
