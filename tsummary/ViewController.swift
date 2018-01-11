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
    
    @IBAction func Registrar(_ sender: Any) {
        btnRegistrar.isEnabled = false
        self.activity.startAnimating()
        
        WSTimeSummary.instance.registrar(
            imei: "863166032574597",
            userName: self.txtLoginName.text,
            password: self.txtPassword.text,
            callback: self.sincronizar
        )
    }
    
    func sincronizar(u: Usuario?)
    {
        if (u != nil)
        {
            do
            {
                self.codigo =  Int(u!.Id)
                self.sincronizar(String(self.codigo), callback: redirect)
            }
            catch
            {
                DispatchQueue.main.async {
                    self.btnRegistrar.isEnabled = true
                    self.activity.stopAnimating()
                }
                print("Error:\(error)")
            }
        }
    }
    
    func redirect(estado: Bool)
    {
        if (estado == true)
        {
            DispatchQueue.main.async {
                self.btnRegistrar.isEnabled = true
                self.activity.stopAnimating()
                let scheduler =  self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
                scheduler.IdAbogado = self.codigo
                self.navigationController?.pushViewController(scheduler, animated: true)
            }
        }
    }
    
    func sincronizar(_ codigo:String, callback: @escaping (Bool) -> Void)
    {
        ControladorLogica.instance.sincronizar(codigo, callback)
    }

    @IBAction func btnDeleteOnClick(_ sender: Any)
    {
        self.btnEliminar.isEnabled = false
        self.activity.startAnimating()
        DispatchQueue.main.async {
            ControladorLogica.instance.deleteAll()
            self.activity.stopAnimating()
            self.btnEliminar.isEnabled = true
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
