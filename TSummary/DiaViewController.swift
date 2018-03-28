//
//  DiaViewController.swift
//  tsummary
//
//  Created by OTRO on 27-03-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import UIKit

class DiaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var objects : [Dia]!
    let cellId1 : String = "cellId1"
    var model: ModelController!
    
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
        navigationItem.title = "Repetir"
        
        self.view.addSubview(collectionView)
        collectionView.register(DetalleDiaCheckCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsSelection = false
        collectionView.allowsMultipleSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! DetalleDiaCheckCell
        if let dias = self.objects {
            let dia = dias[indexPath.item]
            let fecha = Utils.toDateFromString(dia.fecha, "yyyy-MM-dd")
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_CL")
            formatter.dateStyle = .full
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            
            cell.fecha = dia.fecha
            cell.lblText.text = "\(formatter.string(from: fecha!))"
            cell.lblImg.image = Utils.toStringFromDate(model.fechaHoraInicio, "yyyy-MM-dd") != dia.fecha ?  #imageLiteral(resourceName: "casilla desactiva") : #imageLiteral(resourceName: "casilla activa")
            cell.cellSelected = Utils.toStringFromDate(model.fechaHoraInicio, "yyyy-MM-dd") != dia.fecha ?  false : true
            let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            cell.addGestureRecognizer(gesture)
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        }
        return cell
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        if let cell = gestureRecognizer.view as? DetalleDiaCheckCell {
            if cell.fecha != Utils.toStringFromDate(Date(), "yyyy-MM-dd")
            {
                cell.lblImg.image = cell.cellSelected ? #imageLiteral(resourceName: "casilla desactiva") : #imageLiteral(resourceName: "casilla activa")
                cell.cellSelected = !cell.cellSelected
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hrs = objects
        {
            return hrs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width-10, height: 40)
    }
}

class DetalleDiaCheckCell: UICollectionViewCell
{
    var indexPath: Int = -1
    var cellSelected : Bool = false
    var fecha: String!
    
    let lblText : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = UIColor.black
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        return lbl
    }()
    
    let lblImg : UIImageView = {
        let lbl = UIImageView() //UILabel(frame:.zero)
        return lbl
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout()
    {
        contentView.addSubview(lblText)
        contentView.addSubview(lblImg)
        
        lblText.translatesAutoresizingMaskIntoConstraints = false
        lblText.textAlignment = .left
        lblText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        lblText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        
        lblImg.translatesAutoresizingMaskIntoConstraints = false
        lblImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lblImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        lblImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        contentView.addConstraint(NSLayoutConstraint(item: lblText, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal,
                                                     toItem: lblImg, attribute: NSLayoutAttribute.leading, multiplier: 1,
                                                     constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblImg, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal,
                                                     toItem: lblText, attribute: NSLayoutAttribute.trailing, multiplier: 1,
                                                     constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblText, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal,
                                                     toItem: lblImg, attribute: NSLayoutAttribute.height, multiplier: 1,
                                                     constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
