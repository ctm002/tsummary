import UIKit

class EditAjustesViewController: UIViewController {

    @IBOutlet weak var txtNombreServidor: UITextField!
    public var idAbogado: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ajustes"
        
        SwiftyPlistManager.shared.start(plistNames: ["Data"], logging: true)
        guard let fetchedValue = SwiftyPlistManager.shared.fetchValue(for: "newKey", fromPlistWithName: "Data") else { return }
        
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

        SwiftyPlistManager.shared.save(txtNombreServidor.text!, forKey: "newKey", toPlistWithName: "Data")
        { (err) in
            if err == nil
            {
                //self.performSegue(withIdentifier: "ajustesSegue", sender: "")
                //navigationController?.popViewController(animated: false)
                print("Value successfully saved into plist.")
            }
        }
    }
}
