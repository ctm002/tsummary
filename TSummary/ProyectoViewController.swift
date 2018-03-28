import UIKit

class ProyectoViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var objects : [ClienteProyecto]!
    let cellId1 : String = "cellId1"
    var model: ModelController!
    @IBOutlet weak var vContainer: UIView!
    
    lazy var collectionView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Proyectos"
        vContainer.addSubview(collectionView)
        collectionView.register(DetalleProyectoCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: vContainer.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: vContainer.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: vContainer.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: vContainer.bottomAnchor, constant: 0).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hrs = objects
        {
            return hrs.count
        }
        return 0
    }
    
    @objc func selectedItemTableView(gestureRecognizer: UITapGestureRecognizer)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! DetalleProyectoCell
        if let proyecto = self.objects {
            
            let registro = proyecto[indexPath.row]
            cell.lblProyecto.text = registro.nombreProyecto.uppercased()
            cell.lblCliente.text =  registro.nombreCliente.uppercased()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width-10, height: 80)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

class DetalleProyectoCell: UICollectionViewCell
{
    var mostrar: Bool = false
    var delta : CGFloat = 10.0
     var IdHora: Int32 = 0
    
    var containerViews : UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lblCliente: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
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
        self.containerViews.addSubview(lblProyecto)

        lblCliente.textAlignment = .left
        lblCliente.topAnchor.constraint(equalTo: self.containerViews.topAnchor, constant: delta).isActive = true
        lblCliente.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblCliente.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblCliente.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblCliente.numberOfLines = 0
        lblCliente.backgroundColor = mostrar ? UIColor.yellow : UIColor.white

        lblProyecto.textAlignment = .left
        lblProyecto.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = mostrar ?  UIColor.purple : UIColor.white
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: .top, relatedBy: .equal, toItem: lblCliente, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: .height, relatedBy: .equal, toItem: lblCliente, attribute: .height, multiplier: 1, constant: 0))
    }

}

