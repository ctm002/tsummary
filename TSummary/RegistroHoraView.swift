import UIKit
class RegistroHoraView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    var objects : [RegistroHora]!
    let cellId1 : String = "cellId1"
    weak var delegate: DetalleHoraViewDelegate?
    
    lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection  = .vertical
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(self.collectionView)
        self.collectionView.register(DetalleHoraCell.self, forCellWithReuseIdentifier: cellId1)
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        //self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hrs = objects
        {
            return hrs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! DetalleHoraCell
        if let hrs = self.objects {
            
            let registro = hrs[indexPath.row]
            
            cell.lblCliente.text =  registro.proyecto.nombreCliente.uppercased()
            cell.lblProyecto.text = registro.proyecto.nombre.uppercased()
            cell.lblHora.text =  String(format: "%02d", registro.total.horas) + ":" + String(format: "%02d",  registro.total.minutos)
            cell.lblAsunto.text = registro.asunto
            cell.IdHora = registro.id
            cell.lblFechaIngreso.text = String(format: "%02d", registro.inicio.horas) + ":" + String(format: "%02d",  registro.inicio.minutos)
            cell.imgEstado.image = registro.modificable ?  #imageLiteral(resourceName: "desbloquear") :  #imageLiteral(resourceName: "bloquear")
            cell.imgSinc.image = registro.offline ? #imageLiteral(resourceName: "sincronizar") : nil
            
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
        if let cell = gestureRecognizer.view as? DetalleHoraCell {
            if let registro = DataStore.horas.getById(cell.IdHora)
            {
                let model = ModelController(
                    id: registro.id,
                    abogadoId: registro.abogadoId,
                    fechaHoraInicio: registro.fechaHoraInicio!,
                    idProyecto: registro.proyecto.id,
                    nombreProyecto: registro.proyecto.nombre,
                    nombreCliente: registro.proyecto.nombreCliente,
                    horaInicio: "\(String(format: "%02d", registro.inicio.horas)):\(String(format: "%02d", registro.inicio.minutos))",
                    horaFin: "\(String(format: "%02d", registro.fin.horas)):\(String(format: "%02d", registro.fin.minutos))",
                    horaTotal: "\(String(format: "%02d", registro.total.horas)):\(String(format: "%02d", registro.total.minutos))",
                    asunto: registro.asunto,
                    correlativo: registro.tim_correl,
                    modificable : registro.modificable,
                    offline : registro.offline)
                self.delegate?.editViewController(model: model)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.frame.width-10, height: 150)
    }

}

protocol DetalleHoraViewDelegate: class
{
    func editViewController(model: ModelController)
}


class DetalleHoraCell: UICollectionViewCell
{
    var mostrar: Bool = false
    var delta : CGFloat = 10.0
    
    var lblCliente: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        //lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.font = UIFont(name: "Verdana-Bold", size: 13)
        return lbl
    }()
    
    var lblProyecto: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor =  UIColor.darkGray
        //lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.font = UIFont(name:"Verdana-Bold", size: 13)
        return lbl
    }()
    
    var lblHora: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        lbl.font =  UIFont.systemFont(ofSize:14) //UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    var lblAsunto: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor =  UIColor.gray //UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        //lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.font = UIFont(name: "Helvetica", size: 14)
        return lbl
    }()
    
    var lblFechaIngreso: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.91, green:0.44, blue:0.05, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var  imgEstado : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    var  imgSinc : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    var IdHora: Int32 = 0
    
    var containerViews : UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
        self.addSubview(self.containerViews)
        
        self.containerViews.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.containerViews.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.containerViews.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.containerViews.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.containerViews.backgroundColor = UIColor.white
        
        self.containerViews.addSubview(lblCliente)
        self.containerViews.addSubview(lblHora)
        self.containerViews.addSubview(lblProyecto)
        self.containerViews.addSubview(lblAsunto)
        self.containerViews.addSubview(lblFechaIngreso)
        self.containerViews.addSubview(imgSinc)
        self.containerViews.addSubview(imgEstado)
        
        lblCliente.textAlignment = .left
        lblCliente.topAnchor.constraint(equalTo: self.containerViews.topAnchor, constant: delta).isActive = true
        lblCliente.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblCliente.numberOfLines = 0
        lblCliente.backgroundColor = mostrar ? UIColor.yellow : UIColor.white
        //lblCliente.lineBreakMode = .byWordWrapping
        //lblCliente.minimumScaleFactor = 0.5
        //lblCliente.adjustsFontSizeToFitWidth = true
        
        
        lblHora.textAlignment = .right
        lblHora.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //lblHora.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblHora.topAnchor.constraint(equalTo: self.containerViews.topAnchor, constant: delta).isActive = true
        lblHora.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblHora.backgroundColor = mostrar ?  UIColor.brown : UIColor.white
        
        lblProyecto.textAlignment = .left
        lblProyecto.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblProyecto.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = mostrar ?  UIColor.purple : UIColor.white
        
        lblAsunto.textAlignment = .justified
        lblAsunto.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblAsunto.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblAsunto.numberOfLines = 0
        lblAsunto.backgroundColor = mostrar ? UIColor.blue : UIColor.white
        
        lblFechaIngreso.textAlignment = .left
        lblFechaIngreso.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblFechaIngreso.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblFechaIngreso.bottomAnchor.constraint(equalTo: self.containerViews.bottomAnchor, constant: -delta).isActive = true
        lblFechaIngreso.backgroundColor = mostrar ? UIColor.green : UIColor.white
        
        imgSinc.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgSinc.backgroundColor = mostrar ? UIColor.green : UIColor.white
        
        imgEstado.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgEstado.backgroundColor = mostrar ? UIColor.cyan : UIColor.white
        imgEstado.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        
        //        self.containerViews.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .height, relatedBy: .equal, toItem: lblHora, attribute: .height, multiplier: 1, constant: 0))
        
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblHora, attribute: .height, relatedBy: .equal, toItem: lblCliente, attribute: .height, multiplier: 1, constant: 0))
        
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .trailing, relatedBy: .equal, toItem: lblHora, attribute: .leading, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblHora, attribute: .leading, relatedBy: .equal, toItem: lblCliente, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: .top, relatedBy: .equal, toItem: lblCliente, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblAsunto, attribute: .top, relatedBy: .equal, toItem: lblProyecto, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblFechaIngreso, attribute: .top, relatedBy: .equal, toItem: lblAsunto, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblFechaIngreso, attribute: .trailing, relatedBy: .equal, toItem: imgSinc, attribute: .leading, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgEstado, attribute: .top, relatedBy: .equal, toItem: lblAsunto, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgEstado, attribute: .height, relatedBy: .equal, toItem: imgSinc, attribute: .height, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgEstado, attribute: .leading, relatedBy: .equal, toItem: imgSinc, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgSinc, attribute: .top, relatedBy: .equal, toItem: lblAsunto, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgSinc, attribute: .height, relatedBy: .equal, toItem: lblFechaIngreso, attribute: .height, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgSinc, attribute: .leading, relatedBy: .equal, toItem: lblFechaIngreso, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: imgSinc, attribute: .trailing, relatedBy: .equal, toItem: imgEstado, attribute: .leading, multiplier: 1, constant: 0))
        
    }

}

