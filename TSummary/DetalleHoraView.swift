import UIKit
class DetalleHoraView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    var objects : [RegistroHora]!
    let cellId1 : String = "cellId1"
    weak var delegate: DetalleHoraViewDelegate?
    
    lazy var collectionView: UICollectionView =
    {
        let layout  = UICollectionViewFlowLayout()
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
            cell.lblCliente.text = hrs[indexPath.row].proyecto.nombreCliente
            cell.lblProyecto.text = hrs[indexPath.row].proyecto.nombre
            cell.lblHora.text =  String(format: "%02d", hrs[indexPath.row].horasTrabajadas) + ":" + String(format: "%02d",  hrs[indexPath.row].minutosTrabajados)
            cell.lblAsunto.text = hrs[indexPath.row].asunto
            cell.IdHora = hrs[indexPath.row].id
            cell.lblFechaIngreso.text = hrs[indexPath.row].fechaHoraIngresoToHHmm
            cell.imgEstado.image = hrs[indexPath.row].modificable ?  #imageLiteral(resourceName: "desbloquear") :  #imageLiteral(resourceName: "bloquear")
            cell.imgSinc.image = hrs[indexPath.row].offline ? #imageLiteral(resourceName: "sincronizar") : nil
            
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
            if let registroHora = DataStore.horas.getById(cell.IdHora)
            {
                let model = ModelController(
                    id: registroHora.id,
                    abogadoId: registroHora.abogadoId,
                    fechaHoraIngreso: registroHora.fechaHoraIngreso!,
                    idProyecto: registroHora.proyecto.id,
                    nombreProyecto: registroHora.proyecto.nombre,
                    nombreCliente: registroHora.proyecto.nombreCliente,
                    horas: registroHora.horasTrabajadas,
                    minutos: registroHora.minutosTrabajados,
                    asunto: registroHora.asunto,
                    correlativo: registroHora.tim_correl,
                    modificable : registroHora.modificable,
                    offline : registroHora.offline)
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
