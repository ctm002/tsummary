//
//  SchedulerViewController.swift
//  tsummary
//
//  Created by Soporte on 07-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit


class SchedulerViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDataSource,UITableViewDelegate,
    IListViewSemana, IViewHora {
    
    /*
    var mTVHoras: UITableView = {
        let tv = UITableView()
        return tv
    }()
    */
    
    @IBOutlet weak var mTVHoras2: UITableView!
    var mTVHoras: UITableView!
    
    
    var mCVDias: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    var presenterHora: PresenterHora!
    var semana : [Dia]!
    var horas : [Horas]!
    
    let cantDias: CGFloat = 7
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    var mIdAbo: Int=20
    func getIdAbogado()->Int {
        return mIdAbo
    }
    
    var mFechaActual: String = "2017-12-11"
    func getFechaActual() -> String{
        return mFechaActual
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SCHEDULER"
        navigationController?.navigationBar.isTranslucent = false
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth/cantDias), height: (screenWidth/cantDias))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        if (mCVDias == nil)
        {
            mCVDias = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        }
        
        mCVDias.dataSource = self
        mCVDias.delegate = self
        mCVDias.register(CustomCell.self, forCellWithReuseIdentifier:cellId1)
        self.view.addSubview(mCVDias)
        

        if mTVHoras == nil
        {
            mTVHoras = UITableView()
        }
        
        //mTVHoras.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        mTVHoras.dataSource = self
        mTVHoras.delegate = self

        mTVHoras.register(TVCDetalleHora.self, forCellReuseIdentifier:cellId2)
        self.view.addSubview(mTVHoras)
        
        presenterSemana = PresenterSemana(view: self)
        let now = Date()
        presenterSemana.setDate(fecha: now)
        presenterSemana.mostrarSemana()
        self.presenterHora = PresenterHora(view:self)
    }

    
    func setList(horas: [Horas]) {
        self.horas = horas
        
        DispatchQueue.main.async {
            self.mTVHoras.reloadData()
        }
    }
    
    //TableCell
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hrs = self.horas
        {
            return  hrs.count
        }
        else
        {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTVHoras.dequeueReusableCell(withIdentifier: cellId2, for:indexPath) as! TVCDetalleHora
        if let hrs = self.horas {
            cell.lblCliente.text = hrs[indexPath.row].NombreCliente
            cell.lblProyecto.text = hrs[indexPath.row].NombreProyecto
            cell.lblDetalleHora.text =  String(format: "%02d", hrs[indexPath.row].tim_horas) + ":" + String(format: "%02d",  hrs[indexPath.row].tim_minutos)
            cell.lblAsunto.text = hrs[indexPath.row].tim_asunto
            return cell
        }
        return cell
    }
    
    
    //collectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return semana.count
    }
 
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! CustomCell
        cell.lblDia.text = self.semana[indexPath.row].nombre
        
        cell.lblNro.text = String(self.semana[indexPath.row].nro)
        cell.lblNro.isUserInteractionEnabled = true
        cell.lblNro.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(SchedulerViewController.handleTap)))
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.1
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/cantDias, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if let theLabel = gestureRecognizer.view as? UILabel {
            if let nro = theLabel.text
            {
                let dias: [Dia] =  self.semana.filter {$0.nro == Int(nro)!}
                self.mFechaActual = dias[0].Fecha
                self.presenterHora.buscar()
            }
        }
    }

    func setList(semana: [Dia]) {
        self.semana = semana
    }
}
