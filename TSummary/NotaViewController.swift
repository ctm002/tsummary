import UIKit

class NotaViewController: UIViewController {

    var model : ModelController!
    var tempNotas : String!
    @IBOutlet weak var txtNotas: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if model != nil
        {
            txtNotas.text = model.asunto
            self.tempNotas = model.asunto
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editarViewController = segue.destination as! EditRegistroHoraViewController
        editarViewController.model = sender as! ModelController
    }
    
    fileprivate func sendData(_ asunto: String) {
        model.asunto = asunto
        performSegue(withIdentifier: "irNotaEditarHoraSegue", sender: self.model)
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        sendData(tempNotas)
    }
    
    @IBAction func btnAceptarClick(_ sender: Any) {
        sendData(txtNotas.text)
    }
}
