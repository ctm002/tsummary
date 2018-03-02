import UIKit

class SemanaView: UIView, IListViewSemana
{
    var objects :  [Dia]!
    var cellId1 = "cellId1"
    var presenterSemana: PresenterSemana!
    let cantDias: Int = 14
    var cellPrevious: DetalleDiaCell!
    var fechaHoraIngreso: String = ""
    var item : Int = -1
    
    weak var delegate : ListHorasViewDelegate?
    
    lazy var collectionView : UICollectionView =
    {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(self.collectionView)
        self.collectionView.register(DetalleDiaCell.self, forCellWithReuseIdentifier: cellId1)
        self.collectionView.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        
        var contraints: [NSLayoutConstraint]  = [NSLayoutConstraint]()
        contraints.append(self.collectionView.topAnchor.constraint(equalTo: self.topAnchor))
        contraints.append(self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0))
        contraints.append(self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0))
        contraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0))
        contraints.append(self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        contraints.append(self.collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        NSLayoutConstraint.activate(contraints)
        self.addConstraints(contraints)
        
        presenterSemana = PresenterSemana(view: self, cantidadDeDias: self.cantDias)
        presenterSemana.mostrar()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setList(semana: [Dia])
    {
        self.objects = semana
    }
    
    func scrollToNextCell()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
        
            let contentOffset = self.collectionView.contentOffset
            
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false);
        }
    }
    
    func scrollToPreviousCell()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
            let contentOffset = self.collectionView.contentOffset;
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false);
        }
    }
}

extension SemanaView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId1, for: indexPath) as! DetalleDiaCell
        cell.lblDia.text = self.objects[indexPath.item].nombre
        cell.lblNro.text = String(self.objects[indexPath.item].nro)
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:frame.width/7, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.item = currentPage
        print("\(currentPage)")
    }
}

extension SemanaView : ListHorasViewDelegate
{
    func selectDay(fecha: String, item: Int)
    {
        delegate?.selectDay(fecha:fecha, item: item)
    }
}

extension SemanaView : CalendarViewDelegate
{
    func selected(fecha: String)
    {
        self.fechaHoraIngreso = fecha
    }
}

