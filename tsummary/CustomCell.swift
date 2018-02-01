import UIKit

class CustomCell: UICollectionViewCell
{
    var indexPath: Int = -1
    
    let lblNro : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        return lbl
    }()
    
    let lblDia : UILabel = {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 12.0)
        return lbl
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout()
    {
        contentView.addSubview(lblNro)
        contentView.addSubview(lblDia)
        
        lblNro.translatesAutoresizingMaskIntoConstraints = false
        lblNro.textAlignment = .center
        lblNro.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lblNro.heightAnchor.constraint(equalToConstant: 20).isActive = false
        
        lblDia.translatesAutoresizingMaskIntoConstraints = false
        lblDia.textAlignment = .center
        
        lblDia.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lblDia.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addConstraint(NSLayoutConstraint(item: lblDia, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal,
                                                     toItem: lblNro, attribute: NSLayoutAttribute.bottom, multiplier: 1,
                                                     constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
