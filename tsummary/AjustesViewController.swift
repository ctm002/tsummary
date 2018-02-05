import Foundation
import UIKit

public class AjustesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    public var idAbogado: Int!
    
    let configuraciones: [Int:[String: String]] =  [
        0: ["key": "Nombres", "value": SessionLocal.shared.usuario!.nombre!],
        1: ["key": "Telefono", "value": ""],
        2: ["key": "Correo", "value" : ""],
        3: ["key": "Grupo" , "value" : SessionLocal.shared.usuario!.grupo!],
        4: ["key": "Id", "value" : String(SessionLocal.shared.usuario!.id)],
        5: ["key": "Semana", "value" : "10"],]
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Ajustes"
        
        /*
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        */
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        let datos : [String: String] = self.configuraciones[indexPath.row]!
        cell.textLabel?.text = datos["key"]
        cell.detailTextLabel?.text = datos["value"]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuraciones.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item : [String: String] = self.configuraciones[indexPath.row]!
        if item["key"] == "Semana"
        {
            self.performSegue(withIdentifier: "editarSemanaSegue", sender: 2)
        }
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarSemanaSegue"
        {
            let controller = segue.destination as! SemanaViewController
            controller.cantidadSemanas = sender as! Int
        }
    }
}
