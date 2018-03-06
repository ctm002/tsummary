import UIKit
//import SwiftyPlistManager



class EditSemanaViewController: UIViewController {

    
    @IBOutlet weak var txtNombreServidor: UITextField!
    
    var cantidadSemanas: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftyPlistManager.shared.start(plistNames: ["Data"], logging: true)
    
        guard let fetchedValue = SwiftyPlistManager.shared.fetchValue(for: "newKey", fromPlistWithName: "Data") else { return }
        
        print("\(fetchedValue)")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
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
        //navigationController?.popViewController(animated: false)
    
        SwiftyPlistManager.shared.save(txtNombreServidor.text!, forKey: "newKey", toPlistWithName: "Data") { (err) in
            if err == nil {
                print("Value successfully saved into plist.")
            }
        }
        
    }
}
