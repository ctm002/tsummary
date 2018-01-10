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
            callback: self.redirect
        )
    }
    
    func redirect(u: Usuario?)
    {
        if (u != nil)
        {
            do
            {
                self.codigo =  Int(u!.Id)
                self.sincronizar(String(self.codigo))
                
                DispatchQueue.main.async {
                    self.btnRegistrar.isEnabled = true
                    self.activity.stopAnimating()
                    let scheduler =  self.storyboard?.instantiateViewController(withIdentifier: "SchedulerViewController") as! SchedulerViewController
                    scheduler.IdAbogado = self.codigo
                    self.navigationController?.pushViewController(scheduler, animated: true)
                }
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
    
    func sincronizar(_ codigo:String)
    {
        ControladorLogica.instance.syncronizer(codigo)
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
}
