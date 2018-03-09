import UIKit

class SchedulerViewController: UIViewController, IViewHora {
    
    var sideMenuConstraint: NSLayoutConstraint!
    var isSlideMenuHidden = true
    
    var mLblTextFecha: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    var cellPrevious: DetalleDiaCell!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    var presenterHora: PresenterHora!
    var semana : [Dia]!
    var horas : [RegistroHora]!
    
    let cantDias: Int = 14
    let diasBySemana: CGFloat = 7
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    let vCalendario = UIView()
    let vMenu = UIView()
    var delegate : CalendarViewDelegate?
    var item : Int = 1 //Defecto
    
    let horaView : DetalleHoraView =
    {
        let view = DetalleHoraView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let semanaView : SemanaView =
    {
        let view = SemanaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var anchoMenu : CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Scheduler"
        navigationController?.navigationBar.isTranslucent = false
        setupConstraintMenu()
        
        self.view.addSubview(semanaView)
        self.semanaView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.semanaView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.semanaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.semanaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        self.semanaView.delegate = self
        self.delegate = semanaView
        
        let vFecha = UIView()
        self.view.addSubview(vFecha)
        vFecha.translatesAutoresizingMaskIntoConstraints = false
        vFecha.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vFecha.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vFecha.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        vFecha.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vFecha.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        
        vFecha.addSubview(self.mLblTextFecha)
        self.mLblTextFecha.centerXAnchor.constraint(equalTo: vFecha.centerXAnchor).isActive = true
        self.mLblTextFecha.centerYAnchor.constraint(equalTo: vFecha.centerYAnchor).isActive = true
        self.mLblTextFecha.trailingAnchor.constraint(equalTo:vFecha.trailingAnchor).isActive = true
        self.mLblTextFecha.leadingAnchor.constraint(equalTo: vFecha.leadingAnchor).isActive = true
        self.mLblTextFecha.topAnchor.constraint(equalTo:vFecha.topAnchor).isActive = true
        self.mLblTextFecha.bottomAnchor.constraint(equalTo:vFecha.bottomAnchor).isActive = true
        
        self.view.addConstraint(NSLayoutConstraint(item:vFecha, attribute: .top, relatedBy: .equal, toItem: self.semanaView, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.view.addSubview(self.horaView)
        self.horaView.translatesAutoresizingMaskIntoConstraints = false
        self.horaView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.horaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        //self.horaView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        self.horaView.delegate = self
        
        self.view.addConstraint(NSLayoutConstraint(item: self.horaView, attribute: .top, relatedBy: .equal, toItem: vFecha, attribute: .bottom, multiplier: 1, constant: 0))
       
        self.view.bringSubview(toFront: vMenu)
        
        self.presenterHora = PresenterHora(self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.delegate?.selected(fecha: self.fechaHoraIngreso)
        self.mLblTextFecha.text = self.formatearFecha(fecha: self.fechaHoraIngreso)
        self.presenterHora.buscarHoras()
        
        if (self.item == 0)
        {
            self.semanaView.scrollToPreviousCell()
        }
        else
        {
            self.semanaView.scrollToNextCell()
        }
    }
    
    fileprivate func setupConstraintMenu()
    {
        self.anchoMenu = view.frame.width / 2
        self.view.addSubview(vMenu)
        vMenu.translatesAutoresizingMaskIntoConstraints = false
        vMenu.topAnchor.constraint(equalTo: self.view.topAnchor, constant:0).isActive = true
        vMenu.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
        vMenu.widthAnchor.constraint(equalToConstant: self.anchoMenu).isActive = true
        sideMenuConstraint = vMenu.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -self.anchoMenu)
        sideMenuConstraint.isActive = true
        vMenu.backgroundColor = UIColor.white
        
        let btnPerfil : UIButton = UIButton(frame: vMenu.frame)
        vMenu.addSubview(btnPerfil)
        btnPerfil.translatesAutoresizingMaskIntoConstraints = false
        btnPerfil.topAnchor.constraint(equalTo: vMenu.topAnchor, constant: 20).isActive = true
        btnPerfil.leadingAnchor.constraint(equalTo: vMenu.leadingAnchor, constant: 10).isActive = true
        btnPerfil.trailingAnchor.constraint(equalTo: vMenu.trailingAnchor, constant: -10).isActive = true
        btnPerfil.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnPerfil.setTitle("Ver tu perfil", for: .normal)
        btnPerfil.addTarget(self, action: #selector(mostrarPerfil), for: .touchUpInside)
        btnPerfil.setTitleColor(UIColor.black, for: .normal)
        btnPerfil.contentHorizontalAlignment = .left
        
        let btnSincronizar : UIButton = UIButton(frame: vMenu.frame)
        vMenu.addSubview(btnSincronizar)
        btnSincronizar.translatesAutoresizingMaskIntoConstraints = false
        btnSincronizar.leadingAnchor.constraint(equalTo: vMenu.leadingAnchor, constant: 10).isActive = true
        btnSincronizar.trailingAnchor.constraint(equalTo: vMenu.trailingAnchor, constant: -10).isActive = true
        btnSincronizar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnSincronizar.setTitle("Sincronizar", for: .normal)
        btnSincronizar.addTarget(self, action: #selector(sincronizar), for: .touchUpInside)
        btnSincronizar.setTitleColor(UIColor.black, for: .normal)
        btnSincronizar.contentHorizontalAlignment = .left
        
        vMenu.addConstraint(NSLayoutConstraint(
            item: btnSincronizar,
            attribute: .top,
            relatedBy: .equal,
            toItem: btnPerfil,
            attribute:.bottom,
            multiplier: 1,
            constant: 10)
        )
        
        let btnAjustes : UIButton = UIButton(frame: vMenu.frame)
        vMenu.addSubview(btnAjustes)
        btnAjustes.translatesAutoresizingMaskIntoConstraints = false
        btnAjustes.leadingAnchor.constraint(equalTo: vMenu.leadingAnchor, constant: 10).isActive = true
        btnAjustes.trailingAnchor.constraint(equalTo: vMenu.trailingAnchor, constant: -10).isActive = true
        btnAjustes.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnAjustes.setTitle("Ajustes", for: .normal)
        btnAjustes.addTarget(self, action: #selector(ajustes), for: .touchUpInside)
        btnAjustes.setTitleColor(UIColor.black, for: .normal)
        btnAjustes.contentHorizontalAlignment = .left
        
        vMenu.addConstraint(NSLayoutConstraint(
            item: btnAjustes,
            attribute: .top,
            relatedBy: .equal,
            toItem: btnSincronizar,
            attribute: .bottom,
            multiplier: 1,
            constant: 10)
        )
        
        let btnCerrarSesion : UIButton = UIButton(frame: vMenu.frame)
        vMenu.addSubview(btnCerrarSesion)
        btnCerrarSesion.translatesAutoresizingMaskIntoConstraints = false
        btnCerrarSesion.leadingAnchor.constraint(equalTo: vMenu.leadingAnchor, constant: 10).isActive = true
        btnCerrarSesion.trailingAnchor.constraint(equalTo: vMenu.trailingAnchor, constant: -10).isActive = true
        btnCerrarSesion.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnCerrarSesion.setTitle("Cerrar sesión", for: .normal)
        btnCerrarSesion.addTarget(self, action: #selector(salir), for: .touchUpInside)
        btnCerrarSesion.setTitleColor(UIColor.black, for: .normal)
        btnCerrarSesion.contentHorizontalAlignment = .left
        
        vMenu.addConstraint(NSLayoutConstraint(
            item: btnCerrarSesion,
            attribute: .top,
            relatedBy: .equal,
            toItem: btnAjustes,
            attribute:.bottom,
            multiplier: 1,
            constant: 10)
        )
    }
    
    @objc func mostrarPerfil()
    {
        self.performSegue(withIdentifier: "perfilIrSegue", sender: self.idAbogado)
    }
    
    @objc func sincronizar()
    {
        self.performSegue(withIdentifier: "sincIrSegue", sender: self.idAbogado)
    }
    
    @objc func ajustes()
    {
        self.performSegue(withIdentifier: "ajustesIrSegue", sender: self.idAbogado)
    }
    
    @objc func salir()
    {
        performSegue(withIdentifier: "irLoginSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        sideMenuConstraint.constant = -self.anchoMenu
        isSlideMenuHidden = !isSlideMenuHidden
        
        let identifier : String = segue.identifier!
        switch identifier
        {
            case "editarHoraSegue":
                if let model = sender
                {
                    let model = model as! ModelController
                    let controller = segue.destination as! EditHoraViewController
                    controller.model = model
                    controller.item = self.item
                }
            
            case "perfilIrSegue":
                if let id = sender
                {
                    let controller  = segue.destination as! PerfilViewController
                    controller.idAbogado = id as! Int
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                }
            
            case "irLoginSegue":
                SessionLocal.shared.usuario = nil
                SessionLocal.shared.token = ""
                SessionLocal.shared.expiredAt = nil
                
                let controller = segue.destination as! LoginViewController
                controller.entrar = true
            
            case "sincIrSegue" :
                if let id = sender
                {
                    let controller = segue.destination as! SincViewController
                    controller.idAbogado = id as! Int
                }
            
            case "ajuestesIrSegue":
                if let id = sender
                {
                    let controller = segue.destination as! EditAjustesViewController
                    controller.idAbogado = id as! Int
                }
            
            default:
                print("default")
        }
    }
    
    func setList(horas: [RegistroHora])
    {
        self.horaView.objects = horas
        DispatchQueue.main.async {
            self.horaView.collectionView.reloadData()
        }
    }
    
    private var mIdAbogado : Int = 0
    var idAbogado : Int
    {
        get {
            return self.mIdAbogado
        }
        set {
            self.mIdAbogado = newValue
        }
    }
    
    var mFechaHoraIngreso: String = ""
    var fechaHoraIngreso : String
    {
        get {
            return self.mFechaHoraIngreso
        }
        set {
            self.mFechaHoraIngreso = newValue
        }
    }
    
    func formatearFecha(fecha: String) -> String
    {
        let date =  Utils.toDateFromString(fecha, "yyyy-MM-dd")
        if (date != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "es_CL")
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .full
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func getFechaHoraActual() -> Date
    {
        let now = Date()
        let hora = Utils.toStringFromDate(now, "HH")
        let sMinutos = Utils.toStringFromDate(now, "mm")
        let iMinutos = (Int(sMinutos)!/15)*15
        let time = "\(hora):\(iMinutos):00"
        return Utils.toDateFromString("\(self.fechaHoraIngreso) \(time)", "yyyy-MM-dd HH:mm:ss")!
    }
    
    @IBAction func add(_ sender: Any)
    {
        let model = ModelController(id: 0, abogadoId: self.idAbogado , fechaHoraIngreso : self.getFechaHoraActual())
        self.performSegue(withIdentifier: "editarHoraSegue", sender: model)
    }
    
    @IBAction func menuBtnPresed(_ sender: UIBarButtonItem)
    {
        if isSlideMenuHidden
        {
            sideMenuConstraint.constant = 0
        }
        else
        {
            sideMenuConstraint.constant = -self.anchoMenu
        }
        isSlideMenuHidden = !isSlideMenuHidden
    }

}

extension SchedulerViewController: DetalleHoraViewDelegate
{
    func editViewController(model: ModelController)
    {
        self.performSegue(withIdentifier: "editarHoraSegue", sender: model)
    }
}

extension SchedulerViewController: ListHorasViewDelegate
{
    func selectDay(fecha: String, item: Int) {
        
        self.fechaHoraIngreso = fecha
        self.item = item
        
        DispatchQueue.main.async {
            self.mLblTextFecha.text = self.formatearFecha(fecha: self.fechaHoraIngreso)
        }
        self.presenterHora.buscarHoras()
    }
}

protocol CalendarViewDelegate: class
{
    func selected(fecha: String)
}

protocol ListHorasViewDelegate: class
{
    func selectDay(fecha: String, item: Int)
}
