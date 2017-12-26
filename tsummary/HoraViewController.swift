//
//  HoraViewController.swift
//  tsummary
//
//  Created by OTRO on 18-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class HoraViewController: UIViewController,
    UIPickerViewDataSource, UIPickerViewDelegate,
    IListViewProyecto, IEditViewHora{
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var txtHoras: UITextField!
    @IBOutlet weak var txtMinutos: UITextField!
    @IBOutlet weak var txtHoraInicio: UILabel!
    @IBOutlet weak var txtAsunto: UITextView!
    
    var mProyectos = [ClienteProyecto]()
    var presenterProyecto : PresenterProyecto?
    var presenterHora : PresenterHora?
    var horaInicial: Int = 0
    var mIdAbo : Int = 0
    
    var minutosTotales: Int
    {
        get {
            var minutos : Int = 0
            minutos = Int(txtHoras.text!)!*60 + Int(txtMinutos.text!)!
            return minutos
        }
    }

    @IBAction func stepper1(_ sender: UIStepper) {
        txtHoras.text = String(format:"%02d", Int(sender.value))
        
        var horasTermino : Int = self.horaInicial*60 + self.minutosTotales
        setTextHoras(horaDeInicio: self.horaInicial, horaDeTermino: &horasTermino)
    }
    
    @IBAction func stepper2(_ sender: UIStepper) {
        txtMinutos.text = String(format:"%02d", Int(sender.value))
        
        var horasTermino : Int = self.horaInicial*60 + self.minutosTotales
        setTextHoras(horaDeInicio: self.horaInicial, horaDeTermino: &horasTermino)
        
    }
    
    @IBAction func slider(_ sender: UISlider) {
        self.horaInicial = Int(sender.value)
        var horasTermino : Int = self.horaInicial*60 + self.minutosTotales
        setTextHoras(horaDeInicio: self.horaInicial, horaDeTermino: &horasTermino)
    }
    
    func setTextHoras(horaDeInicio inicio: Int, horaDeTermino termino: inout Int)
    {
        var horaTerminoTemp: Int = 0
        var minutoTerminoTemp: Int = 0
        if (termino > 0)
        {
            horaTerminoTemp = (termino/60) > 23 ? 23 : (termino/60)
            minutoTerminoTemp = (termino%60)
        }else
        {
            horaTerminoTemp = (termino/60)
            minutoTerminoTemp = 0
        }
        
        let horasInicialText = String(format:"%02d", inicio)
        let horasTerminoText = String(format:"%02d", horaTerminoTemp) + ":" + String(format:"%02d", minutoTerminoTemp)
        
        let text : String =  "Desde las " + horasInicialText + ":00 hrs. Hasta las " + horasTerminoText + " hrs."
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        txtHoraInicio.attributedText = attributedText
    }
    
    func setList(proyectos: [ClienteProyecto]) {
        self.mProyectos = proyectos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        self.presenterProyecto = PresenterProyecto(self)
        self.presenterHora = PresenterHora(self)
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        
        txtHoras.text = "00"
        txtMinutos.text = "00"
        txtHoraInicio.text = "00:00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenterProyecto!.getListProyectos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mProyectos.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.mProyectos[row].cli_nom) \(self.mProyectos[row].pro_nombre)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let attributedText = NSMutableAttributedString(string: self.mProyectos[row].cli_nom, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        attributedText.append(NSAttributedString(string: ",\(self.mProyectos[row].pro_nombre)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        pickerTextField.attributedText =  attributedText
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return  50
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var lbl: UILabel?  =  (view as? UILabel)
        if lbl == nil
        {
            lbl = UILabel()
        }

        lbl?.textAlignment = .center
        	lbl?.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: self.mProyectos[row].cli_nom, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\n\(self.mProyectos[row].pro_nombre)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        lbl?.attributedText = attributedText
        return lbl!
    }
    
    @IBAction func btnGuardar(_ sender: UIButton) {
        presenterHora!.save()
    }
    
    
    private var mIdHora: Int = 0
    var IdHora : Int { get { return self.mIdHora }  set { self.mIdHora = newValue }}
    
    private var mProyectoId: Int = 0
    var ProyectoId : Int { get { return self.mProyectoId } set { self.mProyectoId = newValue }}
    
    private var mFechaIngreso: Date = {
        return Date()
    }()
    
    var FechaIngreso : Date { get { return mFechaIngreso } set { self.mFechaIngreso = newValue }}
    
    var Horas : String { get { return self.txtHoras.text! } set { self.txtHoras.text = newValue }}
    
    var Minutos : String { get { return self.txtMinutos.text! } set { self.txtMinutos.text = newValue }}
    
    var Asunto : String { get { return self.txtAsunto.text! } set { self.txtAsunto.text = newValue }}
    
    var IdAbogado : Int { get { return self.mIdAbo } set { self.mIdAbo = newValue }}
}
