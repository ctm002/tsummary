import UIKit
import SearchTextField
import ActionSheetPicker_3_0

class EditRegistroHoraViewController: UIViewController, IListViewProyecto, IEditViewHora, UITextFieldDelegate{

    @IBOutlet weak var vToolsBar: UIView!
    @IBOutlet weak var mySearchTextField: SearchTextField!
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var lblHoraInicio: UILabel!
    @IBOutlet weak var lblHoraFin: UILabel!
    @IBOutlet weak var lblHoraTotal: UILabel!
    var mProyectos = [ClienteProyecto]()
    var presenterProyecto : PresenterProyecto?
    var presenterHora : PresenterRegistroHoras?
    var indexSemana : Int = -1
    
    @IBOutlet weak var viewNotas: UIView!
    @IBOutlet weak var viewInicio: UIView!
    @IBOutlet weak var viewFin: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewProyectos: UIView!
    @IBOutlet weak var viewRepetir: UIView!
    
    private var mModel: ModelController!
    var model : ModelController { get { return self.mModel } set { self.mModel = newValue } }

    let calendar : Calendar = {
        let locale = Locale(identifier: "es_CL")
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        return calendar
    }()
    
    func setList(proyectos: [ClienteProyecto])
    {
        self.mProyectos = proyectos
        let proyectosItems: [SearchTextFieldItemExt] = proyectos.map
        {
            SearchTextFieldItemExt(title: $0.nombreCliente, subtitle:$0.nombreProyecto, id: $0.id)
        }
        
        mySearchTextField.filterItems(proyectosItems)
        mySearchTextField.itemSelectionHandler =
        {
            filteredResults, itemPosition in
            let itemSelected = filteredResults[itemPosition] as! SearchTextFieldItemExt
            self.mySearchTextField.text = itemSelected.title + " " + itemSelected.subtitle!
            self.proyectoId = itemSelected.Id
            
            self.model.idProyecto = self.proyectoId
            self.model.nombreCliente = itemSelected.title
            self.model.nombreProyecto = itemSelected.subtitle!
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title =  Utils.toStringFromDate(model.fechaHoraInicio, "dd MMMM yyyy")
        self.presenterProyecto = PresenterProyecto(self)
        self.presenterHora = PresenterRegistroHoras(self)
    
        setupSearchTextField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.viewProyectos.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editarProyectos)))
        
        self.viewNotas.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editarNotas)))
        self.viewInicio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirTimePicker1)))
        self.viewFin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirTimePicker2)))
        self.viewTotal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(abrirTimePicker3)))
        self.viewRepetir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editarDias)))
        
        self.viewRepetir.isHidden = true //(self.model.id != 0)
    }
    
    @objc func editarProyectos()
    {
        let model =  self.model
        self.performSegue(withIdentifier: "irEditarHoraProyectoSegue", sender: model)
    }
    
    @objc func editarDias()
    {
        let model =  self.model
        self.performSegue(withIdentifier: "irEditarHoraDiaSegue", sender: model)
    }
    
    @objc func editarNotas()
    {
        let model =  self.model
        self.performSegue(withIdentifier: "irEditarHoraNotaSegue", sender: model)
    }
    
    @objc func abrirTimePicker1()
    {
        let newDate = Date()
        let datePicker = ActionSheetDatePicker(title: "Hora inicio:\(model.horaInicio)", datePickerMode: UIDatePickerMode.time, selectedDate: newDate, target: self, action: #selector(datePicked1), origin: self.view.superview)
        datePicker?.minuteInterval = 15
        datePicker?.show()
    }
    
    @objc func datePicked1(_ obj: Date) {
        let minutes = (self.calendar.component(.minute, from: obj)/15) * 15
        let hours = self.calendar.component(.hour, from: obj)
        lblHoraInicio.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
        self.calcularTotal()
    }
    
    @objc func abrirTimePicker2()
    {
        let newDate = Date()
        let datePicker = ActionSheetDatePicker(title: "Hora termino: \(model.horaFin)" , datePickerMode: UIDatePickerMode.time, selectedDate: newDate, target: self, action: #selector(datePicked2), origin: self.view.superview)
        datePicker?.minuteInterval = 15
        datePicker?.show()
    }
    
    @objc func datePicked2(_ obj: Date)
    {
        let minutes = (self.calendar.component(.minute, from: obj)/15) * 15
        let hours = self.calendar.component(.hour, from: obj)
        lblHoraFin.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
        self.calcularTotal()
    }
    
    @objc func abrirTimePicker3()
    {
        let datePicker = ActionSheetDatePicker(title:  "Horas total: \(model.horaTotal)", datePickerMode: UIDatePickerMode.countDownTimer, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            let minutesTemp = (value as! Int)/60
            let hours = minutesTemp/60
            let minutes = minutesTemp%60
            self.lblHoraTotal.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
            
            
            let aTimeStart = self.lblHoraInicio.text?.components(separatedBy: ":")
            let totalMinStart = (Int(aTimeStart![0])!*60) + Int(aTimeStart![1])!
            
            let totalHoursEnd = (totalMinStart+minutesTemp) / 60
            let totalMinutesEnd = (totalMinStart+minutesTemp) % 60
            self.lblHoraFin.text = "\(String(format: "%02d",totalHoursEnd)):\(String(format: "%02d",totalMinutesEnd))"
            return
        }, cancel: { ActionStringCancelBlock in return }, origin:  view.superview)
        
        datePicker?.minuteInterval = 15
        datePicker?.countDownDuration = 10
        datePicker?.show()
    }
    
    @objc func datePicked3(_ obj: Date)
    {
        var minutes = (self.calendar.component(.minute, from: obj)/15) * 15
        var hours = self.calendar.component(.hour, from: obj)
        lblHoraTotal.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
    
        let aTimeStart = lblHoraInicio.text?.components(separatedBy: ":")
        let totalMinStart = (Int(aTimeStart![0])!*60) + Int(aTimeStart![1])!
        
        let totalMinEnd = ((hours*60)+minutes)+totalMinStart
        hours = (totalMinEnd/60)
        minutes = (totalMinEnd%60)
        lblHoraFin.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
    }
    
    func calcularTotal()
    {
        let aTimeStart = lblHoraInicio.text?.components(separatedBy: ":")
        let aTimeEnd = lblHoraFin.text?.components(separatedBy: ":")
        
        let totalMinStart = (Int(aTimeStart![0])!*60) + Int(aTimeStart![1])!
        let totalMinEnd = (Int(aTimeEnd![0])!*60) + Int(aTimeEnd![1])!
        
        let hours = ((totalMinEnd-totalMinStart)/60)
        let minutes = ((totalMinEnd-totalMinStart)%60)
        lblHoraTotal.text = "\(String(format: "%02d",hours)):\(String(format: "%02d",minutes))"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loadData()
        self.presenterProyecto!.obtListProyectos()
        if self.idHora == 0
        {
            //btnEliminar.isEnabled = false
            print("test")
        }
        else
        {
            bloquearBotones(model.modificable)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func loadData()
    {
        self.idHora = model.id
        self.horaInicio = "\(model.horaInicio)"
        self.horaFin = "\(model.horaFin)"
        self.horaTotal = "\(model.horaTotal)"
        self.asunto = model.asunto
        self.proyectoId = model.idProyecto
        self.timCorrelativo = model.correlativo
        self.fechaHoraIngreso = model.fechaHoraInicio
        self.idAbogado = model.idAbogado
        self.setNombreProyecto(model)
    }
    
    func setupSearchTextField()
    {
        mySearchTextField.theme = SearchTextFieldTheme.darkTheme()
        mySearchTextField.theme.bgColor = UIColor.white
        mySearchTextField.theme.borderColor =  UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        mySearchTextField.theme.separatorColor =  UIColor.black
        mySearchTextField.theme.fontColor = UIColor.black
        mySearchTextField.theme.cellHeight = 50
        mySearchTextField.theme.font = UIFont.boldSystemFont(ofSize: 16)
        mySearchTextField.comparisonOptions = [.caseInsensitive]
        mySearchTextField.maxNumberOfResults = 10
        mySearchTextField.maxResultsListHeight = 500
        mySearchTextField.highlightAttributes = [
            NSAttributedStringKey.backgroundColor: UIColor.yellow,
            NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12),
        ]
        mySearchTextField.forceRightToLeft = false
        
        mySearchTextField.clearsOnBeginEditing = false
        mySearchTextField.clearButtonMode = .whileEditing
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func bloquearBotones(_ estado: Bool)
    {
        vToolsBar.isHidden = !estado
        viewProyectos.isUserInteractionEnabled = estado
        viewNotas.isUserInteractionEnabled = estado
        viewInicio.isUserInteractionEnabled = estado
        viewFin.isUserInteractionEnabled = estado
        viewTotal.isUserInteractionEnabled = estado
        mySearchTextField.isEnabled = estado
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func setNombreProyecto(_ model : ModelController)
    {
        if model.idProyecto != 0
        {
        
            let attributedText = NSMutableAttributedString(string: model.nombreCliente, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        
            attributedText.append(NSAttributedString(string: ",\(model.nombreProyecto)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
            self.mySearchTextField.attributedText = attributedText
        }
    }
    
    private var mResponse : Response!
    public var response : Response
    {
        set
        {
            self.mResponse = newValue
            
            if self.mResponse.result
            {
                mostrarMensaje(titulo: "TSummary", mensaje: response.mensaje)
            }
            else
            {
                mostrarMensaje(titulo: "Advertencia", mensaje: response.mensaje)
            }
        }
        get
        {
            return self.mResponse
        }

    }
    
    func mostrarMensaje(titulo: String, mensaje: String )
    {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "irEditarHoraSchedulerSegue", sender: self.model)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnGuardar_Click(_ sender: UIButton?)
    {
        //self.vToolsBar.isEnabled = false
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.view.addSubview(activityView)
        activityView.center = self.view.center
        activityView.color  = UIColor.blue
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        activityView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        activityView.startAnimating()
        presenterHora!.guardar()
        //self.vToolsBar.isEnabled = true
    }
    
    @IBAction func btnEliminar_Click(_ sender: UIButton?)
    {
        let alert = UIAlertController(title: "Alerta",
                                      message: "Está seguro de eliminar el registro?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,
            handler: { (action: UIAlertAction!) in
                
                let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                self.view.addSubview(activityView)
                activityView.center = self.view.center
                activityView.color  = UIColor.red
                activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                activityView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                activityView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                activityView.startAnimating()
                self.presenterHora!.eliminar()
            }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCancelar_Click(_ sender: Any)
    {
        self.performSegue(withIdentifier: "irEditarHoraSchedulerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let identifier : String = segue.identifier!
        if (identifier == "irEditarHoraSchedulerSegue")
        {
            let controller : SchedulerViewController = segue.destination as! SchedulerViewController
            controller.idAbogado = self.idAbogado
            controller.fechaHoraIngreso = Utils.toStringFromDate(self.fechaHoraIngreso, "yyyy-MM-dd")
            controller.indexSemana = self.indexSemana
            controller.reloadRegistroHoras()
        }
        else if (identifier == "irEditarHoraNotaSegue")
        {
            let notaViewController : NotaViewController = segue.destination as! NotaViewController
            notaViewController.model = sender as! ModelController
            let backItem = UIBarButtonItem()
            backItem.title = "Editar"
            navigationItem.backBarButtonItem = backItem
            
        }
        else if (identifier == "irEditarHoraProyectoSegue")
        {
            let proyectoViewController  = segue.destination as! ProyectoViewController
            proyectoViewController.model = sender as! ModelController
            proyectoViewController.objects = ControladorLogica.instance.obtListProyectos()
            let backItem = UIBarButtonItem()
            backItem.title = "Editar"
            navigationItem.backBarButtonItem = backItem
        }
        else if (identifier == "irEditarHoraDiaSegue")
        {
            let proyectoViewController  = segue.destination as! DiaViewController
            proyectoViewController.model = sender as! ModelController
            proyectoViewController.objects = DateCalculator.instance.obtDias()
            let backItem = UIBarButtonItem()
            backItem.title = "Editar"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    //Inicio propiedades-------------------------------------------------
    private var mIdHora: Int32 = 0
    var idHora : Int32
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
    
    private var mProyectoId: Int32 = 0
    var proyectoId : Int32
    {
        get
        {
            return self.mProyectoId
        }
        set
        {
            self.mProyectoId = newValue
        }
    }
    
    var mFechaHoraIngreso: Date!
    var fechaHoraIngreso: Date
    {
        get
        {
            return self.mFechaHoraIngreso
        }
        set
        {
            self.mFechaHoraIngreso = newValue
        }
    }
    
    var horaInicio: String
    {
        get {
            return self.lblHoraInicio.text!
        }
        set {
           self.lblHoraInicio.text = newValue
        }
    }
    
    var horaFin: String
    {
        get {
            return self.lblHoraFin.text!
        }
        set {
            self.lblHoraFin.text = newValue
        }
    }
    
    var horaTotal: String
    {
        get {
            return self.lblHoraTotal.text!
        }
        set {
            self.lblHoraTotal.text = newValue
        }
    }
    
    var asunto: String
    {
        get
        {
            return self.lblAsunto.text!
            
        }
        set
        {
            self.lblAsunto.text = newValue
        }
    }
    
    private var mIdAbogado : Int32 = 0
    var idAbogado : Int32
    {
        get
        {
            return self.mIdAbogado
        }
        set
        {
            self.mIdAbogado = newValue
        }
    }
    
    private var mTimCorrelativo: Int32 = 0
    var timCorrelativo: Int32
    {
        get
        {
            return self.mTimCorrelativo
        }
        set
        {
            self.mTimCorrelativo = newValue
        }
    }
    //Fin propiedades-----------------------------------------------------
}
