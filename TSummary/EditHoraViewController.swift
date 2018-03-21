import UIKit
import SearchTextField

class EditHoraViewController: UIViewController, IListViewProyecto, IEditViewHora {

    @IBOutlet weak var mySearchTextField: SearchTextField!
    @IBOutlet weak var txtHoras: UITextField!
    @IBOutlet weak var txtMinutos: UITextField!
    @IBOutlet weak var txtAsunto: UITextView!
    @IBOutlet var btnEliminar: UIButton!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet var btnGuardar: UIButton!
    @IBOutlet var datePickerFechaIngreso: UIDatePicker!
    
    var mProyectos = [ClienteProyecto]()
    var presenterProyecto : PresenterProyecto?
    var presenterHora : PresenterRegistroHoras?
    var indexSemana : Int = -1
    
    private var mModel: ModelController!
    var model : ModelController { get { return self.mModel } set { self.mModel = newValue } }
    
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
    
    func setList(proyectos: [ClienteProyecto])
    {
        self.mProyectos = proyectos
        let proyectosItems: [SearchTextFieldItemExt] = proyectos.map
        {
            SearchTextFieldItemExt(title: $0.nombreCliente, subtitle:$0.nombre, id: $0.id)
        }
        
        mySearchTextField.filterItems(proyectosItems)
        mySearchTextField.itemSelectionHandler =
        {
            filteredResults, itemPosition in
            let itemSelected = filteredResults[itemPosition] as! SearchTextFieldItemExt
            self.mySearchTextField.text = itemSelected.title + " " + itemSelected.subtitle!
            self.proyectoId = itemSelected.Id
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title =  Utils.toStringFromDate(model.fechaHoraIngreso, "dd MMMM yyyy")
        self.presenterProyecto = PresenterProyecto(self)
        self.presenterHora = PresenterRegistroHoras(self)
    
        setupSearchTextField()
        
        txtHoras.text = "00"
        txtMinutos.text = "00"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        loadData()
        self.presenterProyecto!.obtListProyectos()
        if self.idHora == 0
        {
            btnEliminar.isEnabled = false
        }
        else
        {
            bloquearBotones(model.modificable)
        }
    }
    
    func loadData()
    {
        self.idHora = model.id
        self.horas = model.horas
        self.minutos = model.minutos
        self.asunto = model.asunto
        self.proyectoId = model.idProyecto
        self.timCorrelativo = model.correlativo
        self.fechaHoraIngreso = model.fechaHoraIngreso
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
        btnEliminar.isEnabled = estado
        btnGuardar.isEnabled = estado
        
        btnGuardar.isHidden = !estado
        btnEliminar.isHidden = !estado
        
        mySearchTextField.isEnabled = estado
        txtAsunto.isEditable = estado
        datePickerFechaIngreso.isEnabled = estado
        
        txtHoras.isEnabled = estado
        txtMinutos.isEnabled = estado
        
        stepper1.isEnabled = estado
        stepper2.isEnabled = estado
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
    public var response : Response {
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
            self.performSegue(withIdentifier: "volverSchedulerHoraSegue", sender: self.model)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnGuardar_Click(_ sender: UIButton?)
    {
        btnGuardar.isEnabled = false
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
        btnGuardar.isEnabled = true
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
        //self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "volverSchedulerHoraSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller : SchedulerViewController = segue.destination as! SchedulerViewController
        controller.idAbogado = self.idAbogado
        controller.fechaHoraIngreso = Utils.toStringFromDate(self.fechaHoraIngreso, "yyyy-MM-dd")
        controller.indexSemana = self.indexSemana
        controller.reloadRegistroHoras()
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
    
    var fechaHoraIngreso: Date
    {
        get
        {
            return self.datePickerFechaIngreso.date
        }
        set
        {
            self.datePickerFechaIngreso.date = newValue
        }
    }
    
    var horas: Int
    {
        get {
            return Int(self.txtHoras.text!)!
        }
        set {
            self.stepper1.value = Double(newValue)
            self.txtHoras.text = String(format:"%02d", newValue)
        }
    }
    
    var minutos: Int
    {
        get {
            return Int(self.txtMinutos.text!)!
        }
        set {
            self.stepper2.value = Double(newValue)
            self.txtMinutos.text = String(format:"%02d", newValue)
        }
    }
    
    var asunto: String
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
