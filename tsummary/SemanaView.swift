import UIKit

class SemanaView: UIView, IListViewSemana
{
    var objects :  [Int:[Dia]]!
    var cellId1 = "cellId1"
    var presenterSemana: PresenterSemana!
    let cantDias: Int = 14
    
    weak var delegate : ListHorasViewDelegate?
    
    lazy var collectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SemanaCell.self, forCellWithReuseIdentifier: cellId1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:-0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        presenterSemana = PresenterSemana(view: self, cantidadDeDias: self.cantDias)
        presenterSemana.mostrar()
        
        self.scrollToNextCell()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setList(semanas: [Int:[Dia]])
    {
        self.objects = semanas
    }
    
    func scrollToNextCell(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //get cell size
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
        
            //get current content Offset of the Collection view
            let contentOffset = self.collectionView.contentOffset;
        
            //scroll to next cell
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false);
        }
    }
    
    func scrollToPreviousCell(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            //get cell size
            let cellSize = CGSize(width: self.frame.width, height: self.frame.height);
        
            //get current content Offset of the Collection view
            let contentOffset = self.collectionView.contentOffset;
        
            //scroll to next cell
            self.collectionView.scrollRectToVisible(CGRect(x: contentOffset.x, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: false);
        }
    }
}

extension SemanaView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId1, for: indexPath) as! SemanaCell
        let semana = objects[indexPath.row]
        cell.objects = semana
        cell.reloadData()
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: frame.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}

extension SemanaView : ListHorasViewDelegate
{
    func selectViewController(fecha: String) {
        delegate?.selectViewController(fecha: fecha)
    }
}

