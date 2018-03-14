import UIKit
import Foundation

class PerfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoPerfil: UIImageView!
    
    public var idAbogado: Int!
    var datos = [Int:[String: String]]()
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Perfil"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        photoPerfil.layer.cornerRadius = photoPerfil.frame.height / 2
        photoPerfil.layer.masksToBounds = true
        self.activityIndicator.hidesWhenStopped = true
        
        let id : Int32 = (SessionLocal.shared.usuario?.id)!
        if let u : Usuario = ControladorLogica.instance.obtUsuarioById(id: Int(id))
        {
            if u.data == ""
            {
                self.activityIndicator.startAnimating()
                let idUsuario : Int = (SessionLocal.shared.usuario?.idUsuario)!
                ControladorLogica.instance.descargarImagenByIdUsuario(id: idUsuario, callback: { (dataString64: String) in
                    if (dataString64 != "")
                    {
                        let resp: Bool = ControladorLogica.instance.actualizarImagen(id: id, string64: dataString64)
                        if resp
                        {
                            let data = Data(base64Encoded: dataString64, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                            DispatchQueue.main.async
                            {
                                self.photoPerfil.image = UIImage(data: data!)!
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async
                        {
                            self.photoPerfil.image = nil
                            self.activityIndicator.stopAnimating()
                        }
                    }
                })
            }
            else
            {
                self.activityIndicator.startAnimating()
                let data = Data(base64Encoded: u.data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                DispatchQueue.main.async
                {
                    self.photoPerfil.image = UIImage(data: data!)!
                    self.activityIndicator.stopAnimating()
                }
            }
        
            self.datos[0] = ["key":"Nombres", "value" : u.nombre!]
            self.datos[1] = ["key":"Perfil", "value" : u.perfil]
            self.datos[2] = ["key":"Grupo", "value" : u.grupo!]
            self.datos[3] = ["key":"Nombre de Usuario", "value" : u.loginName!]
            self.datos[4] = ["key":"Correo", "value" : u.email]
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        let datos : [String: String] = self.datos[indexPath.row]!
        cell.textLabel?.text = datos["key"]
        cell.detailTextLabel?.text = datos["value"]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datos.count
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
