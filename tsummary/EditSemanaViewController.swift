import UIKit

class EditSemanaViewController: UIViewController {

    
    @IBOutlet weak var txtCantSemanas: UITextField!
    
    var cantidadSemanas: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtCantSemanas.text = String(cantidadSemanas)
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ajustesSegue"
        {
            let controller = segue.destination as! AjustesViewController
            //let backItem = UIBarButtonItem()
            //backItem.title = ""
            //navigationItem.backBarButtonItem = backItem
        }
    }
    */
    
    @IBAction func btnGuardar_OnClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "ajustesSegue", sender: "")
     navigationController?.popViewController(animated: false)
    }
}
