import UIKit

class HoraViewController: UIViewController,
    UIPickerViewDataSource, UIPickerViewDelegate,
    IListViewProyecto, IEditViewHora{
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var txtHoras: UITextField!
    @IBOutlet weak var txtMinutos: UITextField!
    @IBOutlet weak var txtAsunto: UITextView!
    @IBOutlet var btnEliminar: UIButton!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    
    @IBOutlet var datePickerFechaIngreso: UIDatePicker! =
    {
        let dt = UIDatePicker()
        return dt
    }()
    
    var mProyectos = [ClienteProyecto]()
    var presenterProyecto : PresenterProyecto?
    var presenterHora : PresenterHora?
    var horaInicial: Int = 0
    var mIdAbo : Int = 0
    
    private var mIdHora: Int32 = 0
    private var mProyectoId: Int32 = 0
    private var mTimCorrel: Int32 = 0
    
    var mFechaIngreso: String = ""
    
    var minutosTotales: Int
    {
        get
        {
            var minutos : Int = 0
            minutos = Int(txtHoras.text!)!*60 + Int(txtMinutos.text!)!
            return minutos
        }
    }

    @IBAction func stepper1(_ sender: UIStepper)
    {
        let s = Int(sender.value)
        txtHoras.text = String(format:"%02d", s)
    }
    
    @IBAction func stepper2(_ sender: UIStepper)
    {
        let s = Int(sender.value)
        txtMinutos.text = String(format:"%02d", s)
    }
    
    func setTextHoras(horaDeInicio inicio: Int, horaDeTermino termino: inout Int)
    {
        /*
        var horaTerminoTemp: Int = 0
        var minutoTerminoTemp: Int = 0
        if (termino > 0)
        {
            horaTerminoTemp = (termino/60) > 23 ? 23 : (termino/60)
            minutoTerminoTemp = (termino%60)
        }
        else
        {
            horaTerminoTemp = (termino/60)
            minutoTerminoTemp = 0
        }
        
         let horasInicialText = String(format:"%02d", inicio)
        let horasTerminoText = String(format:"%02d", horaTerminoTemp) + ":" + String(format:"%02d", minutoTerminoTemp)
        
        let text : String =  "Desde las " + horasInicialText + ":00 hrs. Hasta las " + horasTerminoText + " hrs."
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        */
    }
    
    func setList(proyectos: [ClienteProyecto])
    {
        self.mProyectos = proyectos
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
        self.presenterProyecto = PresenterProyecto(self)
        self.presenterHora = PresenterHora(self)
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
        
        txtHoras.text = "00"
        txtMinutos.text = "00"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.presenterProyecto!.obtListProyectos()
        
        if self.IdHora == 0
        {
            btnEliminar.isEnabled = false
            self.FechaIngreso = mFechaIngreso
        }else
        {
            btnEliminar.isEnabled = true
            presenterHora?.buscar()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.mProyectos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(self.mProyectos[row].cli_nom) \(self.mProyectos[row].pro_nombre)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let proyecto = self.mProyectos[row]
        self.setNombreProyecto(proyecto)
        self.ProyectoId = proyecto.pro_id
    }
    
    public func setNombreProyecto(_ proyecto : ClienteProyecto)
    {
        let attributedText = NSMutableAttributedString(string: proyecto.cli_nom, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        attributedText.append(NSAttributedString(string: ",\(proyecto.pro_nombre)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        pickerTextField.attributedText =  attributedText
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return  50
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return self.view.frame.width
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
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
    
    @IBAction func btnGuardar(_ sender: UIButton)
    {
        presenterHora!.guardar()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEliminar_Click(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Alerta", message: "Esta seguro de eliminar el registro?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let response : Bool =  self.presenterHora!.eliminar()
            if (response == true)
            {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(alert, animated: true, completion: nil)
    }
    

    
    var mFormatter : DateFormatter =
    {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_CL")
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()
    
    
    var IdHora : Int32
    {
        get
        {
            return self.mIdHora
            
        }
        set
        {
            self.mIdHora = newValue
        }
    }
    
    var ProyectoId : Int32 { get { return self.mProyectoId } set { self.mProyectoId = newValue }}
    
    var FechaIngreso : String
    {
        get
        {
            return self.mFormatter.string(from: self.datePickerFechaIngreso.date)
        }
        set
        {
            if let date = self.mFormatter.date(from: newValue)
            {
                self.datePickerFechaIngreso.date = date
            }
        }
    }
    
    var Horas : Int {
        get {
            return Int(self.txtHoras.text!)!
        }
        set {
            self.stepper1.value = Double(newValue)
            self.txtHoras.text = String(format:"%02d", newValue)
        }
    }
    
    var Minutos : Int
    {
        get {
            return Int(self.txtMinutos.text!)!
        }
        set {
             self.stepper2.value = Double(newValue)
            self.txtMinutos.text = String(format:"%02d", newValue)
        }
    }
    
    var Asunto : String
    {
        get
        {
            return self.txtAsunto.text!
            
        }
        set
        {
            self.txtAsunto.text = newValue
        }
    }
    
    var IdAbogado : Int
    {
        get
        {
            return self.mIdAbo
        }
        set
        {
            self.mIdAbo = newValue
        }
    }
    
    var TimCorrel: Int32
    {
        get
        {
            return self.mTimCorrel
        }
        set
        {
            self.mTimCorrel = newValue
        }
    }
}
