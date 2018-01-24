import UIKit

class SchedulerViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDataSource,UITableViewDelegate,
    IListViewSemana, IViewHora {
    
    var mCVDias : UICollectionView!
    
    
    var mTVHoras: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.yellow
        return tv
    }()
    
    var mLblTextFecha: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    var cellPrevious: CustomCell!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    var presenterHora: PresenterHora!
    var semana : [Dia]!
    var horas : [Horas]!
    
    let cantDias: Int = 14
    let diasBySemana: CGFloat = 7
    
    
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    private var mIdAbo : Int = 0
    var IdAbogado : Int {
        get {
            return self.mIdAbo
        }
        set {
            self.mIdAbo = newValue
        }
    }
    
    var mFechaIngreso: String = ""
    var FechaIngreso : String {
        get {
            return self.mFechaIngreso
        }
        set {
            self.mFechaIngreso = newValue
        }
    }
    
    let vCalendario = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isTranslucent = false
        
        let btnMenu: UIButton = UIButton.init(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "menu_24x") , for: .normal)
        btnMenu.addTarget(self, action: #selector(self.agregar), for: UIControlEvents.touchUpInside)
        //btnMenu.setTitle("Nuevo", for: .normal)
        btnMenu.setTitleColor(UIColor.darkGray, for: .normal)
        let barBtnMenu = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem  = barBtnMenu
        
        
        let btn: UIButton = UIButton.init(type: .custom)
        //btn.setImage(#imageLiteral(resourceName: "add_24x") , for: .normal)
        btn.addTarget(self, action: #selector(self.agregar), for: UIControlEvents.touchUpInside)
        btn.setTitle("Nuevo", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        let barBtn = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = barBtn
        
        self.view.addSubview(vCalendario)
        
        vCalendario.translatesAutoresizingMaskIntoConstraints = false
        vCalendario.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        vCalendario.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vCalendario.heightAnchor.constraint(equalToConstant: 50).isActive = true
        vCalendario.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vCalendario.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        if (self.mCVDias == nil)  {self.mCVDias = UICollectionView(frame: .zero, collectionViewLayout: layout)}
        
        vCalendario.addSubview(mCVDias)
        mCVDias.translatesAutoresizingMaskIntoConstraints = false
        mCVDias.centerXAnchor.constraint(equalTo: vCalendario.centerXAnchor).isActive = true
        mCVDias.centerYAnchor.constraint(equalTo: vCalendario.centerYAnchor).isActive = true
        mCVDias.heightAnchor.constraint(equalTo: vCalendario.heightAnchor).isActive = true
        mCVDias.leadingAnchor.constraint(equalTo: vCalendario.leadingAnchor, constant: 0).isActive = true
        mCVDias.trailingAnchor.constraint(equalTo: vCalendario.trailingAnchor, constant: -0).isActive = true
        mCVDias.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        mCVDias.register(CustomCell.self, forCellWithReuseIdentifier:cellId1)
        mCVDias.dataSource = self
        mCVDias.delegate = self
        
        let vFecha = UIView()
        self.view.addSubview(vFecha)
        vFecha.translatesAutoresizingMaskIntoConstraints = false
        vFecha.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vFecha.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vFecha.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        vFecha.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vFecha.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        
        vFecha.addSubview(self.mLblTextFecha)
        self.mLblTextFecha.translatesAutoresizingMaskIntoConstraints = false
        self.mLblTextFecha.centerXAnchor.constraint(equalTo: vFecha.centerXAnchor).isActive = true
        self.mLblTextFecha.centerYAnchor.constraint(equalTo: vFecha.centerYAnchor).isActive = true
        self.mLblTextFecha.trailingAnchor.constraint(equalTo:  vFecha.trailingAnchor).isActive = true
        self.mLblTextFecha.leadingAnchor.constraint(equalTo: vFecha.leadingAnchor).isActive = true
        
        self.view.addConstraint(NSLayoutConstraint(item:vFecha, attribute: .top, relatedBy: .equal, toItem: vCalendario, attribute: .bottom, multiplier: 1, constant: 0))
        
        let vHoras = UIView()
        self.view.addSubview(vHoras)
        vHoras.translatesAutoresizingMaskIntoConstraints = false
        vHoras.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vHoras.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        vHoras.backgroundColor = UIColor.purple
        
        self.view.addConstraint(NSLayoutConstraint(item:vHoras, attribute: .top, relatedBy: .equal, toItem: vFecha, attribute: .bottom, multiplier: 1, constant: 10))
        
        vHoras.addSubview(mTVHoras)
        mTVHoras.translatesAutoresizingMaskIntoConstraints = false
        mTVHoras.topAnchor.constraint(equalTo: vHoras.topAnchor).isActive = true
        mTVHoras.leadingAnchor.constraint(equalTo: vHoras.leadingAnchor, constant:0).isActive = true
        mTVHoras.trailingAnchor.constraint(equalTo: vHoras.trailingAnchor, constant:-0).isActive = true
        mTVHoras.bottomAnchor.constraint(equalTo: vHoras.bottomAnchor, constant: 0).isActive = true
        
        
        mTVHoras.register(TVCDetalleHora.self, forCellReuseIdentifier:cellId2)
        mTVHoras.delegate = self
        mTVHoras.dataSource = self
        mTVHoras.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        presenterSemana = PresenterSemana(view: self,  rangoDeDias: self.cantDias)
        presenterSemana.calcularSemana()
        
        self.FechaIngreso = Utils.toStringFromDate(Date(), "yyyy-MM-dd")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.presenterHora = PresenterHora(self)
        self.presenterHora.buscarHoras()
        self.mLblTextFecha.text = self.formatearFecha(fecha: self.FechaIngreso)
    }
    
    func setList(horas: [Horas]) {
        self.horas = horas
        DispatchQueue.main.async {
            self.mTVHoras.reloadData()
        }
    }
    
    //TableCell
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hrs = self.horas
        {
            return  hrs.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTVHoras.dequeueReusableCell(withIdentifier: cellId2, for:indexPath) as! TVCDetalleHora
        if let hrs = self.horas {
            cell.lblCliente.text = hrs[indexPath.row].proyecto.cli_nom
            cell.lblProyecto.text = hrs[indexPath.row].proyecto.pro_nombre
            cell.lblDetalleHora.text =  String(format: "%02d", hrs[indexPath.row].tim_horas) + ":" + String(format: "%02d",  hrs[indexPath.row].tim_minutos)
            cell.lblAsunto.text = hrs[indexPath.row].tim_asunto
            cell.IdHora = hrs[indexPath.row].IdHora
            cell.lblFechaIngreso.text = hrs[indexPath.row].tim_fecha_ing_hh_mm
            
            let gesture: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(selectedItemTableView))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(gesture)
        }
        return cell
    }
    
    @objc func selectedItemTableView(gestureRecognizer: UITapGestureRecognizer)
    {
        if let cell = gestureRecognizer.view as? TVCDetalleHora {
            let id = cell.IdHora
            let horaViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HoraViewController") as! HoraViewController
            horaViewController.IdAbogado = self.IdAbogado
            horaViewController.IdHora = id
            self.navigationController?.pushViewController(horaViewController, animated: true)
        }
    }
    //Fin de TableCell
    
    //collectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  semana.count
    }
 
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! CustomCell
        cell.lblDia.text = self.semana[indexPath.row].nombre
        cell.lblNro.text = String(self.semana[indexPath.row].nro)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        cell.isUserInteractionEnabled = true
        cell.indexPath = indexPath.row
        cell.addGestureRecognizer(gesture)
        
        if self.FechaIngreso == self.semana[indexPath.row].Fecha
        {
            cellPrevious = cell
            cell.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        }
        
        print("item->\(indexPath.item)")
        print("section->\(indexPath.section)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mCVDias.frame.width/7, height: self.mCVDias.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        if let cell = gestureRecognizer.view as? CustomCell {
            if cellPrevious == nil
            {
                cellPrevious = cell
            }
            else
            {
                if (cellPrevious.indexPath != cell.indexPath)
                {
                    cellPrevious.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
                    cellPrevious = cell
                }
            }
            
            cell.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
            
            if let nro = cell.lblNro.text
            {
                let dias: [Dia] =  self.semana.filter {$0.nro == Int(nro)!}
                self.FechaIngreso = dias[0].Fecha
                self.presenterHora.buscarHoras()
                
                DispatchQueue.main.async {
                    self.mLblTextFecha.text = self.formatearFecha(fecha: self.FechaIngreso)
                }
            }
        }
    }
    
    func setList(semana: [Dia]) {
        self.semana = semana
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
    
    @objc func agregar()
    {
        let horaViewController = self.storyboard?.instantiateViewController(withIdentifier: "HoraViewController") as! HoraViewController
        horaViewController.IdAbogado = self.IdAbogado
        let formatterHora = DateFormatter()
        formatterHora.dateFormat = "HH"
        horaViewController.mFechaIngreso = self.FechaIngreso + " " + formatterHora.string(from: Date()) + ":00"
        self.navigationController?.pushViewController(horaViewController, animated: true)
    }
}
