import Foundation
import UIKit


public class AjustesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    public var idAbogado: Int!
    
    @IBOutlet weak var photoPerfil: UIImageView!
    
    var configuraciones: [Int:[String: String]] =  [
        0: ["key": "Cantidad de Semanas", "value": SessionLocal.shared.usuario!.nombre!],
        1: ["key": "Telefono", "value": ""],
        2: ["key": "Correo", "value" : "cariola@cariola.cl"],
        3: ["key": "Grupo" , "value" : SessionLocal.shared.usuario!.grupo!],
        4: ["key": "Id", "value" : String(SessionLocal.shared.usuario!.id)],]
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Ajustes"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        let datos : [String: String] = self.configuraciones[indexPath.row]!
        cell.textLabel?.text = datos["key"]
        cell.detailTextLabel?.text = datos["value"]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return configuraciones.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item : [String: String] = self.configuraciones[indexPath.row]!
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
