import UIKit
import Foundation

class PerfilViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoPerfil: UIImageView!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblGrupo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNroProyectos: UILabel!
    @IBOutlet weak var lblCantHorasTrabajadas: UILabel!
    
    public var idAbogado: Int32 = 0
    var datos = [Int:[String: String]]()

    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Perfil"
        
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
                            self.photoPerfil.image = #imageLiteral(resourceName: "foto por defecto")
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
            
            lblNombre.text =  u.nombre!
            lblTipo.text = u.perfil
            lblGrupo.text = u.grupo!
            lblEmail.text = u.email
        }
    
        let cantProyectos = ControladorLogica.instance.obtCantidadProyectosWithHorasAsignadasAndIdAbogado(id)
        lblNroProyectos.text = "\(String(format:"%02d", cantProyectos))"
        
        let hora = ControladorLogica.instance.obtCantidadTotalHorasAndIdAbogado(id)!
        lblCantHorasTrabajadas.text = "\(String(format:"%02d",hora.horas)):\(String(format:"%02d", hora.minutos))"
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let viewController = segue.destination as! SchedulerViewController
        viewController.idAbogado = self.idAbogado
        viewController.fechaHoraIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
        viewController.indexSemana = 1
        viewController.reloadRegistroHoras()
    }

}
