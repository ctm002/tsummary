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
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDataSource,UITableViewDelegate,
    IListViewSemana, IViewHora {
    
    var mCVDias : UICollectionView!
    
    var mTVHoras: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.yellow
        return tv
    }()
    
    var mLblTextFecha: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        return lbl
    }()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var presenterSemana: PresenterSemana!
    var presenterHora: PresenterHora!
    var semana : [Dia]!
    var horas : [Horas]!
    
    let cantDias: Int = 14
    let diasBySemana: CGFloat = 7
    
    
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
        navigationItem.title = "TimeSummary"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Nuevo", style: .plain, target: self, action: #selector(self.addHora))
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        
        let vCalendario = UIView()
        self.view.addSubview(vCalendario)
        
        vCalendario.translatesAutoresizingMaskIntoConstraints = false
        vCalendario.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        vCalendario.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vCalendario.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //vCalendario.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        vCalendario.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vCalendario.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        if (self.mCVDias == nil)  {self.mCVDias = UICollectionView(frame: .zero, collectionViewLayout: layout)}
        
        vCalendario.addSubview(mCVDias)
        mCVDias.translatesAutoresizingMaskIntoConstraints = false
        mCVDias.centerXAnchor.constraint(equalTo: vCalendario.centerXAnchor).isActive = true
        mCVDias.centerYAnchor.constraint(equalTo: vCalendario.centerYAnchor).isActive = true
        mCVDias.heightAnchor.constraint(equalTo: vCalendario.heightAnchor).isActive = true
        mCVDias.leadingAnchor.constraint(equalTo: vCalendario.leadingAnchor, constant: 0).isActive = true
        mCVDias.trailingAnchor.constraint(equalTo: vCalendario.trailingAnchor, constant: -0).isActive = true
        mCVDias.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
        mCVDias.register(CustomCell.self, forCellWithReuseIdentifier:cellId1)
        mCVDias.dataSource = self
        mCVDias.delegate = self
        
        
        let vFecha = UIView()
        self.view.addSubview(vFecha)
        vFecha.translatesAutoresizingMaskIntoConstraints = false
        vFecha.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vFecha.heightAnchor.constraint(equalToConstant: 30).isActive = true
        vFecha.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        vFecha.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vFecha.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0).isActive = true
        
        vFecha.addSubview(self.mLblTextFecha)
        self.mLblTextFecha.translatesAutoresizingMaskIntoConstraints = false
        self.mLblTextFecha.centerXAnchor.constraint(equalTo: vFecha.centerXAnchor).isActive = true
        self.mLblTextFecha.centerYAnchor.constraint(equalTo: vFecha.centerYAnchor).isActive = true
        self.mLblTextFecha.trailingAnchor.constraint(equalTo:  vFecha.trailingAnchor).isActive = true
        self.mLblTextFecha.leadingAnchor.constraint(equalTo: vFecha.trailingAnchor).isActive = true
        
        self.view.addConstraint(NSLayoutConstraint(item:vFecha, attribute: .top, relatedBy: .equal, toItem: vCalendario, attribute: .bottom, multiplier: 1, constant: 0))
        
        let vHoras = UIView()
        self.view.addSubview(vHoras)
        vHoras.translatesAutoresizingMaskIntoConstraints = false
        vHoras.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        vHoras.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        vHoras.backgroundColor = UIColor.purple
        
        self.view.addConstraint(NSLayoutConstraint(item:vHoras, attribute: .top, relatedBy: .equal, toItem: vFecha, attribute: .bottom, multiplier: 1, constant: 10))
        
        vHoras.addSubview(mTVHoras)
        mTVHoras.translatesAutoresizingMaskIntoConstraints = false
        mTVHoras.topAnchor.constraint(equalTo: vHoras.topAnchor).isActive = true
        mTVHoras.leadingAnchor.constraint(equalTo: vHoras.leadingAnchor, constant:0).isActive = true
        mTVHoras.trailingAnchor.constraint(equalTo: vHoras.trailingAnchor, constant:-0).isActive = true
        mTVHoras.bottomAnchor.constraint(equalTo: vHoras.bottomAnchor, constant: 0).isActive = true
        
        
        mTVHoras.register(TVCDetalleHora.self, forCellReuseIdentifier:cellId2)
        mTVHoras.delegate = self
        mTVHoras.dataSource = self
        mTVHoras.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        presenterSemana = PresenterSemana(view: self)
        let now = Date()
        presenterSemana.setDate(fecha: now)
        presenterSemana.mostrarSemana(cantidad: self.cantDias)
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
        //cell.backgroundColor = UIColor.blue
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/7, height: 50)
    }
    */

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if let theLabel = gestureRecognizer.view as? UILabel {
            if let nro = theLabel.text
            {
                let dias: [Dia] =  self.semana.filter {$0.nro == Int(nro)!}
                self.mFechaActual = dias[0].Fecha
                DispatchQueue.main.async {
                    self.mLblTextFecha.text = self.toDateFormatter(fecha: self.mFechaActual)
                }
                self.presenterHora.buscar()
            }
        }
    }

    func setList(semana: [Dia]) {
        self.semana = semana
    }
    
    func toDateFormatter(fecha: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: fecha)
        dateFormatter.locale = Locale(identifier: "es_CL")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date!)
    }
    
    @objc func addHora()
    {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "HoraViewController") as! HoraViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
