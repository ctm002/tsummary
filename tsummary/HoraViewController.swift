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
    let salutations = ["", "Mr.", "Ms.", "Mrs."]
    
    
    func setList(proyectos:[ClienteProyecto]) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "TimeSummary"
        

        // Do any additional setup after loading the view.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salutations.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salutations[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = salutations[row]
    }
}
