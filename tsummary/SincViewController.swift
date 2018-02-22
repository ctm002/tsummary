import UIKit

class SincViewController: UIViewController {

    var idAbogado: Int = 0
    
    @IBOutlet weak var btnSincronizar: UIButton!
    
    @IBAction func btnSincronizar(_ sender: Any)
    {
        //Solo testing
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
        ControladorLogica.instance.sincronizar(SessionLocal.shared, { (resp: Bool) -> Void in
            self.redirect()
        })
    }
    
    func redirect()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.btnSincronizar.isEnabled = true
            self.performSegue(withIdentifier: "sincVolverSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sincronizar"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! SchedulerViewController
        viewController.idAbogado = self.idAbogado
        viewController.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
    }
}
