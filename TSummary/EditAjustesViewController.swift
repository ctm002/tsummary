import UIKit

class EditAjustesViewController: UIViewController {

    @IBOutlet weak var txtNombreServidor: UITextField!
    public var idAbogado: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ajustes"
        
        txtNombreServidor.text = FileConfig.instance.fetch(key: "newValue")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func btnGuardar_OnClick(_ sender: Any)
    {
        FileConfig.instance.saveWith(key: "newValue", value: txtNombreServidor.text!, result: { (value: Bool) in
                print("Value successfully saved into plist.")
            }
        )
    }
}
