//
//  SchedulerViewController.swift
//  tsummary
//
//  Created by Soporte on 07-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit


class SchedulerViewController:
    UIViewController,
    //UITableViewController,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDataSource,UITableViewDelegate,
    IListViewSemana, IViewHora {
    
    
    var mTVHoras: UITableView = {
        let tv = UITableView(frame: CGRect(x:0, y: 100, width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.height - 100) ,
                             style: UITableViewStyle.plain)
        tv.backgroundColor = UIColor.yellow
        return tv
    }()
    
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
    
    var mFechaActual: String = {
        let date = Date()
        let locale = Locale(identifier: "es_CL")
        let tz = TimeZone(abbreviation: "UTC")!
        var dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = tz
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
        
    }()
    
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
        
        
        let vCalendario = UIView(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: 100))
        vCalendario.translatesAutoresizingMaskIntoConstraints = false

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        if (mCVDias == nil)
        {
            mCVDias = UICollectionView(frame: vCalendario.frame, collectionViewLayout: layout)
        }
        
        mCVDias.register(CustomCell.self, forCellWithReuseIdentifier:cellId1)
        mCVDias.dataSource = self
        mCVDias.delegate = self
        mCVDias.backgroundColor = UIColor.red
        vCalendario.addSubview(mCVDias)
        self.view.addSubview(vCalendario)
        
        mTVHoras.register(TVCDetalleHora.self, forCellReuseIdentifier:cellId2)
        mTVHoras.delegate = self
        mTVHoras.dataSource = self
        
        mTVHoras.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(mTVHoras)
        
        presenterSemana = PresenterSemana(view: self)
        let now = Date()
        presenterSemana.setDate(fecha: now)
        presenterSemana.mostrarSemana(cantidad: 14)
        self.presenterHora = PresenterHora(view:self)
        self.presenterHora.buscar()
    }

    func setList(horas: [Horas]) {
        print(horas)
        self.horas = horas
        DispatchQueue.main.async {
            self.mTVHoras.reloadData()
        }
    }
    
    //TableCell
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hrs = self.horas
        {
            return  hrs.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTVHoras.dequeueReusableCell(withIdentifier: cellId2, for:indexPath) as! TVCDetalleHora
        if let hrs = self.horas {
            cell.lblCliente.text = hrs[indexPath.row].NombreCliente
            cell.lblProyecto.text = hrs[indexPath.row].NombreProyecto
            cell.lblDetalleHora.text =  String(format: "%02d", hrs[indexPath.row].tim_horas) + ":" + String(format: "%02d",  hrs[indexPath.row].tim_minutos)
            cell.lblAsunto.text = hrs[indexPath.row].tim_asunto
        }
        return cell
    }
    
    //collectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  semana.count
    }
 
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! CustomCell
        print(self.semana[indexPath.row].nombre)
        
        cell.lblDia.text = self.semana[indexPath.row].nombre
        cell.lblNro.text = String(self.semana[indexPath.row].nro)
        cell.lblNro.isUserInteractionEnabled = true
        cell.lblNro.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(SchedulerViewController.handleTap)))
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/7, height: 50)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
