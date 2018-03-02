
import UIKit

class DetalleHoraCell: UICollectionViewCell {
    var mostrar: Bool = false
    var delta : CGFloat = 2.0
    
    var lblCliente: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    var lblProyecto: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var lblHora: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    var lblAsunto: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var lblFechaIngreso: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(red:0.91, green:0.44, blue:0.05, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var IdHora: Int32 = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
            //UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor // UIColor.clear.cgColor //UIColor.yellow.cgColor //
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath

        
        self.addSubview(lblCliente)
        self.addSubview(lblHora)
        self.addSubview(lblProyecto)
        self.addSubview(lblAsunto)
        self.addSubview(lblFechaIngreso)
        
        lblCliente.textAlignment = .left
        lblCliente.topAnchor.constraint(equalTo: self.topAnchor, constant: delta).isActive = true
        lblCliente.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: delta).isActive = true
        lblCliente.numberOfLines = 0
        lblCliente.backgroundColor = mostrar ? UIColor.yellow : UIColor.white
        
        lblHora.textAlignment = .center
        lblHora.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lblHora.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblHora.topAnchor.constraint(equalTo: self.topAnchor, constant: delta).isActive = true
        lblHora.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -delta).isActive = true
        lblHora.backgroundColor = mostrar ?  UIColor.brown : UIColor.white
        
        
        lblProyecto.textAlignment = .left
        lblProyecto.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: delta).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -delta).isActive = true
        //lblProyecto.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        lblProyecto.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = mostrar ?  UIColor.purple : UIColor.white
        

        lblAsunto.textAlignment = .left
        lblAsunto.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: delta).isActive = true
        lblAsunto.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -delta).isActive = true
        lblAsunto.numberOfLines = 0
        lblAsunto.backgroundColor = mostrar ? UIColor.blue : UIColor.white
        
        lblFechaIngreso.textAlignment = .left
        lblFechaIngreso.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: delta).isActive = true
        lblFechaIngreso.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -delta).isActive = true
        lblFechaIngreso.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblFechaIngreso.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -delta).isActive = true
        lblFechaIngreso.backgroundColor = mostrar ? UIColor.green : UIColor.white
        
        self.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .height, relatedBy: .equal, toItem: lblHora, attribute: .height, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .trailing, relatedBy: .equal, toItem: lblHora, attribute: .leading, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lblHora, attribute: .leading, relatedBy: .equal, toItem: lblCliente, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: .top, relatedBy: .equal, toItem: lblCliente, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lblAsunto, attribute: .top, relatedBy: .equal, toItem: lblProyecto, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lblFechaIngreso, attribute: .top, relatedBy: .equal, toItem: lblAsunto, attribute: .bottom, multiplier: 1, constant: 0))
        
    }
}
