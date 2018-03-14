
import UIKit

class DetalleHoraCell: UICollectionViewCell {
    var mostrar: Bool = false
    var delta : CGFloat = 10.0
    
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
    
    var lblHora: UILabel =
    {
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
        
        lblHora.textAlignment = .center
        lblHora.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lblHora.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblHora.topAnchor.constraint(equalTo: self.containerViews.topAnchor, constant: delta).isActive = true
        lblHora.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblHora.backgroundColor = mostrar ?  UIColor.brown : UIColor.white
        
        lblProyecto.textAlignment = .left
        lblProyecto.leadingAnchor.constraint(equalTo: self.containerViews.leadingAnchor, constant: delta).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: self.containerViews.trailingAnchor, constant: -delta).isActive = true
        lblProyecto.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = mostrar ?  UIColor.purple : UIColor.white
        
        lblAsunto.textAlignment = .left
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
        
        self.containerViews.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .height, relatedBy: .equal, toItem: lblHora, attribute: .height, multiplier: 1, constant: 0))
        
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
