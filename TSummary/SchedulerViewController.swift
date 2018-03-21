import UIKit

class SchedulerViewController: UIViewController, IViewHora {
    
    var sideMenuConstraint: NSLayoutConstraint!
    var isSlideMenuHidden = true
    var anchoMenu : CGFloat = 0
    
    var indexSemana : Int = 1
    var idAbogado : Int32 = 0
    var fechaHoraIngreso : String = ""
    
    var mLblTextFecha: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    
    lazy var presenterHora: PresenterRegistroHoras = {
        var p =  PresenterRegistroHoras(self)
        return p
    }()
    
    let vCalendario = UIView()
    let vMenu = UIView()
    
    let containerRegistroHorasView : DetalleHoraView =
    {
        let view = DetalleHoraView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var containerSemanasView : SemanaView =
    {
        //let view = SemanaView.init(frame: self.view.frame)
        let view = SemanaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Scheduler"
        navigationController?.navigationBar.isTranslucent = false
        self.setupConstraintsMenu()
        self.setupConstrainsContainers()
        
        self.containerSemanasView.fechaHoraIngreso = self.fechaHoraIngreso
        self.containerSemanasView.indexSemana = self.indexSemana
        self.containerSemanasView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.mLblTextFecha.text = self.formatearFecha(fecha: self.fechaHoraIngreso)
        self.view.layoutIfNeeded()
        self.containerSemanasView.selectInitial()
    }
    
    @objc func viewSwipe(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                prevDay()
            case UISwipeGestureRecognizerDirection.left:
                nextDay()
            default:
                break
            }
        }
    }
    
    func nextDay()
    {
        self.containerSemanasView.nextDay()
    }
    
    func prevDay()
    {
        self.containerSemanasView.prevDay()
    }
    
    func setupConstrainsContainers()
    {
        self.view.addSubview(containerSemanasView)
        self.containerSemanasView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.containerSemanasView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.containerSemanasView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.containerSemanasView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        
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
        
        self.view.addConstraint(NSLayoutConstraint(item:vFecha, attribute: .top, relatedBy: .equal, toItem: self.containerSemanasView, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.view.addSubview(self.containerRegistroHorasView)
        self.containerRegistroHorasView.translatesAutoresizingMaskIntoConstraints = false
        self.containerRegistroHorasView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.containerRegistroHorasView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.containerRegistroHorasView.delegate = self
        
        self.view.addConstraint(NSLayoutConstraint(item: self.containerRegistroHorasView, attribute: .top, relatedBy: .equal, toItem: vFecha, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.view.bringSubview(toFront: vMenu)
    
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipe))
        swipeLeft.direction = .left
        self.containerRegistroHorasView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipe))
        swipeRight.direction = .right
        self.containerRegistroHorasView.addGestureRecognizer(swipeRight)
    }
    
    func reloadRegistroHoras()
    {
        if let horas = ControladorLogica.instance.getListDetalleHorasByIdAbogadoAndFecha(self.idAbogado, self.fechaHoraIngreso)
        {
            setList(horas: horas)
        }
    }
    
    fileprivate func setupConstraintsMenu()
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
            toItem: btnSincronizar,
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
                    controller.indexSemana = self.indexSemana
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
                if let id = sender as? Int32
                {
                    let controller = segue.destination as! SincViewController
                    controller.idAbogado = id
                }
            
            default:
                print("default")
        }
    }
    
    func setList(horas: [RegistroHora])
    {
        self.containerRegistroHorasView.objects = horas
        DispatchQueue.main.async {
            self.containerRegistroHorasView.collectionView.reloadData()
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
    func selectDay(fecha: String, indexSemana: Int) {
        
        self.fechaHoraIngreso = fecha
        self.indexSemana = indexSemana

        DispatchQueue.main.async {
            self.mLblTextFecha.text = self.formatearFecha(fecha: self.fechaHoraIngreso)
        }
        
        self.reloadRegistroHoras()
    }
}

protocol ListHorasViewDelegate: class
{
    func selectDay(fecha: String, indexSemana: Int)
}
