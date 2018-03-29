import UIKit

class SemanaView: UIView, IListViewSemana
{

    var objects :  [Dia]!
    var cellId1 = "cellId1"
    var presenterSemana: PresenterSemana!
    var previous: DetalleDiaCell!
    var current: DetalleDiaCell!
    var fechaHoraIngreso: String = ""
    var indexSemana : Int = -1
    
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
        self.addSubview(self.collectionView)
        self.collectionView.register(DetalleDiaCell.self, forCellWithReuseIdentifier: cellId1)
        self.collectionView.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.allowsMultipleSelection = false
        
        var contraints: [NSLayoutConstraint]  = [NSLayoutConstraint]()
        contraints.append(self.collectionView.topAnchor.constraint(equalTo: self.topAnchor))
        contraints.append(self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0))
        contraints.append(self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0))
        contraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0))
        contraints.append(self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        contraints.append(self.collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        NSLayoutConstraint.activate(contraints)
        self.addConstraints(contraints)
        
        presenterSemana = PresenterSemana(view: self)
        //presenterSemana.mostrar()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData()
    {
        let dias : [Dia] = DateCalculator.instance.obtDias()
        setList(semana: dias)
    }
    
    func setList(semana: [Dia])
    {
        self.objects = semana
    }
    
    func scrollToNext()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
            let contentOffset = self.collectionView.contentOffset
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
        }
    }
    
    func scrollToPrevious()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
            let contentOffset = self.collectionView.contentOffset;
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false)
        }
    }

    private func getDay(value: Int) -> Date
    {
        let locale = Locale(identifier: "es_CL")
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        let fechaCurrent = Utils.toDateFromString(self.fechaHoraIngreso, "yyyy-MM-dd")
        let fechaNew: Date = calendar.date(byAdding: Calendar.Component.day, value: value, to: fechaCurrent!)!
        return fechaNew
    }
    
    func nextDay()
    {
        let newDate = getDay(value: 1)
        if (newDate <= DateCalculator.instance.fechaTermino)
        {
            self.select(fecha: Utils.toStringFromDate(newDate, "yyyy-MM-dd"))
            self.delegate?.selectDay(fecha: self.fechaHoraIngreso, indexSemana: self.indexSemana)
        }
    }
    
    func prevDay()
    {
        let newDate = getDay(value: -1)
        if (newDate >= DateCalculator.instance.fechaInicio)
        {
            self.select(fecha: Utils.toStringFromDate(newDate, "yyyy-MM-dd"))
            self.delegate?.selectDay(fecha: self.fechaHoraIngreso, indexSemana: self.indexSemana)
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
        cell.isUserInteractionEnabled = true
        cell.indexPath = indexPath.item
        self.objects[indexPath.item].indexPath = indexPath
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        cell.addGestureRecognizer(gesture)
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        
        if self.fechaHoraIngreso == self.objects[indexPath.item].fecha
        {
            cell.isSelected = true
            self.current = cell
            self.previous = cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if objects == nil
        {
            return 0
        }
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
            
            if self.previous != nil
            {
                self.previous = self.current
                self.previous.isSelected = false

                cell.isSelected = true
                self.current = cell
                
                if let nro = cell.lblNro.text
                {
                    let dias: [Dia] = self.objects.filter {$0.nro == Int(nro)!}
                    let dia : Dia = dias[0]
                    
                    self.indexSemana = dia.indexSemana
                    self.fechaHoraIngreso = dia.fecha
                    delegate?.selectDay(fecha: dia.fecha, indexSemana: dia.indexSemana)
                }
            }
        }
    }
    
    func swapSemana()
    {
        if (self.indexSemana == 0)
        {
            self.scrollToPrevious()
        }
        else
        {
            self.scrollToNext()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.indexSemana = currentPage
        if (self.indexSemana == 0 || self.indexSemana == 1)
        {
            deselect()
        }
    }
    
    private func deselect()
    {
        for cell in self.collectionView.visibleCells {
            if let c = cell as? DetalleDiaCell
            {
                if self.previous != nil && c.indexPath == self.previous.indexPath
                {
                    c.isSelected = false
                }
            }
        }
    }
    
    public func moveScroll(_ pIndexSemana: Int)
    {
        let cellSize = CGSize(width: self.frame.width, height: self.frame.height)
        let contentOffset = self.collectionView.contentOffset
        var width : CGFloat = 0
        if pIndexSemana == 1
        {
            width = cellSize.width
        }
        let rect = CGRect(x: 0 + width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
        self.collectionView.scrollRectToVisible(rect, animated: false)
    }
    
    fileprivate func selectedItem(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func select(fecha: String)
    {
        if self.current != nil
        {
            self.current.isSelected = false
            if let dia = searchDay(fecha)
            {
                self.indexSemana = dia.indexSemana
                self.fechaHoraIngreso = dia.fecha
                moveScroll(dia.indexSemana)
                selectedItem(dia.index)
                delegate?.selectDay(fecha: dia.fecha, indexSemana: dia.indexSemana)
            }
        }
    }
    
    func selectInitial()
    {
        if let dia = searchDay(self.fechaHoraIngreso)
        {
            self.indexSemana = dia.indexSemana
            self.fechaHoraIngreso = dia.fecha
            self.swapSemana()
            delegate?.selectDay(fecha: dia.fecha, indexSemana: dia.indexSemana)
        }
    }
    
    func searchDay(_ fecha: String) -> Dia?
    {
        let found : [Dia] = self.objects.filter { $0.fecha ==  fecha }
        if found.count == 1
        {
            let dia : Dia = found[0]
            return dia
        }
        return nil
    }

}

class DetalleDiaCell: UICollectionViewCell
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


    class DetalleDiaCell: UICollectionViewCell
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
}
