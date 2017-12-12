//
//  SchedulerViewController.swift
//  tsummary
//
//  Created by Soporte on 07-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit
 //UICollectionViewDelegate,
class SchedulerViewController:
    UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDelegate, UITableViewDataSource,
    IListViewSemana, IViewHora {
    
    @IBOutlet weak var mTVHoras: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //let dias = ["", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom", ""]
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    var presenterHora: PresenterHora!
    var semana : [Dia]!
    var horas : [Horas]!
    
    let cantDias: CGFloat = 7
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTVHoras.dequeueReusableCell(withIdentifier: "TVCHora", for:indexPath) as! TVCDetalleHora
        if let hrs = horas {
            cell.lblClienteProyecto.text = hrs[indexPath.row].tim_asunto
            cell.lblDetalleHora.text = "\(hrs[indexPath.row].tim_horas):\(hrs[indexPath.row].tim_minutos)"
            return cell
        }
        return cell
    }
    
    
    func setList(horas: [Horas]) {
        
    }
    
    func getIdAbogado()->Int {
        return 20
    }
    
    func getFechaActual() -> Date{
        return Date()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.dataSource = self
        collectionView.delegate = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth/cantDias), height: (screenWidth/cantDias))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        presenterSemana = PresenterSemana(view: self)
        let now = Date()
        presenterSemana.setDate(fecha: now)
        presenterSemana.mostrarSemana()
        
        self.presenterHora = PresenterHora(view:self)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return semana.count
    }
 
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.lblDia.text = self.semana[indexPath.row].nombre
        cell.lblNro.text = String(self.semana[indexPath.row].nro)
        
        cell.lblNro.isUserInteractionEnabled = true
        cell.lblNro.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SchedulerViewController.handleTap)))
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.1
        cell.frame.size.width = (screenWidth/cantDias)
        cell.frame.size.height = (screenWidth/cantDias)
        return cell
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.presenterHora.loadHorasByFecha(fecha: Date())
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    func setList(semana: [Dia]) {
        self.semana = semana
    }
}
