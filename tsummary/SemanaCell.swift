import Foundation
import UIKit

public class SemanaCell: UICollectionViewCell
{
    var fechaHoraIngreso: String = ""
    private var cellId1 : String = "cellId1"
    var objects : [Dia]!
    var item : Int = -1
    var cellPrevious: DetalleDiaCell!
    weak var delegate: ListHorasViewDelegate?
    
    lazy var collectionView: UICollectionView =
    {
        let layout  = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DetalleDiaCell.self, forCellWithReuseIdentifier: cellId1)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        self.addSubview(self.collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    public func reloadData()
    {
        self.collectionView.reloadData()
    }
}

extension SemanaCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let objs = objects
        {
            return objs.count
        }
        return 0;
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionView.frame.width/7 , height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
 
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId1, for: indexPath) as! DetalleDiaCell
        cell.lblDia.text = self.objects[indexPath.row].nombre
        cell.lblNro.text = String(self.objects[indexPath.row].nro)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        cell.isUserInteractionEnabled = true
        cell.indexPath = indexPath.item
        cell.addGestureRecognizer(gesture)
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        if self.fechaHoraIngreso == self.objects[indexPath.item].fecha
        {
            cell.isSelected = true
            cellPrevious = cell
        }
        
        return cell
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        if let cell = gestureRecognizer.view as? DetalleDiaCell {
            
            if cellPrevious == nil
            {
                cellPrevious = cell
            }
            else
            {
                if (cellPrevious.indexPath != cell.indexPath)
                {
                    cellPrevious.isSelected = false
                    cellPrevious = cell
                }
            }

            cell.isSelected = true

            if let nro = cell.lblNro.text
            {
                let dias: [Dia] =  self.objects.filter {$0.nro == Int(nro)!}
                self.fechaHoraIngreso = dias[0].fecha
                delegate?.selectDay(fecha: self.fechaHoraIngreso, item: self.item)
            }
        }
    }
}

protocol ListHorasViewDelegate: class
{
    func selectDay(fecha: String, item: Int)
}
