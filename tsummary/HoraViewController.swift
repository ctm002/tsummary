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
    IListViewProyecto
    
{
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var txtHoras: UITextField!
    @IBOutlet weak var txtMinutos: UITextField!
    
    @IBAction func stepper1(_ sender: UIStepper) {
        txtHoras.text = String(format:"%02d", Int(sender.value))
    }
    
    @IBAction func stepper2(_ sender: UIStepper) {
        txtMinutos.text = String(format:"%02d", Int(sender.value))
    }
    
    var mProyectos = [ClienteProyecto]()
    var mCodAbogado: Int = 20
    var presenter : PresenterProyecto?
    
    func getIdAbogado() -> Int {
        return self.mCodAbogado
    }
    
    func setList(proyectos: [ClienteProyecto]) {
        self.mProyectos = proyectos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        self.presenter = PresenterProyecto(view: self)
        txtHoras.text = "00"
        txtMinutos.text = "00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter!.getListProyectos()
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
}
