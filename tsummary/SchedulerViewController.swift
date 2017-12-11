//
//  SchedulerViewController.swift
//  tsummary
//
//  Created by Soporte on 07-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit
 //UICollectionViewDelegate,
class SchedulerViewController: UIViewController, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{


    @IBOutlet weak var collectionView: UICollectionView!
    
    let dias = ["", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom", ""]
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.dataSource = self
        collectionView.delegate = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/10, height: screenWidth/10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //collectionView!.backgroundColor = UIColor.green
        collectionView!.collectionViewLayout = layout
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dias.count
    }
 
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.lblDia.text = dias[indexPath.row]
        cell.lblNro.text = "1"
        
        cell.lblNro.isUserInteractionEnabled = true
        cell.lblNro.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SchedulerViewController.handleTap)))
        
        
        cell.backgroundColor = UIColor.white
        //cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 0.1
        cell.frame.size.width = screenWidth / 10
        cell.frame.size.height = screenWidth / 10
        return cell
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
