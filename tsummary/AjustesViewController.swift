import Foundation
import UIKit

public class AjustesViewController: UIViewController
{
    
    public var idAbogado: Int!
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Ajustes"
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func btnCancelar_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
