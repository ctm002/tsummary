import Foundation

public class Usuario
{
    init()
    {
        self.mId=0
        self.mNombre=""
        self.mGrupo = ""
        self.mLoginName = ""
        self.mPassword=""
        self.mIMEI=""
        self.mDefault=0
        self.mPerfil = ""
        self.mIdUsuario = 0
        self.mData = ""
        self.mEmail = ""
    }
    
    private var mId : Int32
    var id : Int32
    {
        get{ return self.mId } set{ self.mId=newValue }
    }
    
    private var mNombre: String?
    var nombre : String?
    {
        get{ return self.mNombre} set {self.mNombre=newValue }
        
    }
    
    private var mGrupo:String?
    var grupo : String?
    {
        get {return self.mGrupo } set{ self.mGrupo=newValue }
        
    }
    
    private var mLoginName:String?
    var loginName : String?
    {
        get{ return self.mLoginName } set { self.mLoginName=newValue }
    }
    
    private var mPassword:String?
    var password : String?
    {
        get {return self.mPassword } set { self.mPassword = newValue }
    }
    
    private var mIMEI:String?
    var imei : String?
    {
        get { return self.mIMEI } set { self.mIMEI = newValue }
    }
    
    private var mDefault:Int?
    var defaults : Int?
    {
        return self.mDefault
        
    }
    
    private var mPerfil: String
    var perfil : String
    {
        get
        { return self.mPerfil } set { self.mPerfil = newValue }
        
    }
    
    private var mIdUsuario : Int
    var idUsuario : Int
    {
        get
        {
            return self.mIdUsuario
        }
        set
        {
            self.mIdUsuario = newValue
        }
    }

    private var mData: String
    var data : String
    {
        get
        {
            return self.mData
        }
        set
        {
            self.mData = newValue
        }
    }
    
    private var mEmail: String
    var email: String
    {
        get { return mEmail }
        set { mEmail = newValue }
    }
}

public class Cliente
{
    init()
    {
        self.mCodigo = 0
        self.mNombre=""
    }
    
    private var mCodigo:Int
    public var codigo : Int
    {
        get
        {
            return self.mCodigo
        }
        set
        {
            self.mCodigo = newValue
        }
    }
    
    private var mNombre:String
    var nombre: String
    {
        get
        {
            return self.mNombre
        }
        set
        {
            self.mNombre = newValue
        }
    }
}

public class ClienteProyecto
{
    
    init()
    {
        self.mIdProyecto = 0
        self.mNombreProyecto  = ""
        self.mIdiomaCliente = ""
        self.mCliente = Cliente()
        self.mEstado = 0
    }
    
    private var mCliente: Cliente
    public var nombreCliente: String
    {
        get
        {
            return self.mCliente.nombre
        }
        set
        {
            self.mCliente.nombre = newValue
        }
    }
    
    public var codigoCliente: Int
    {
        get
        {
            return self.mCliente.codigo
        }
        set
        {
            self.mCliente.codigo=newValue
        }
    }
    
    private var mIdProyecto: Int32
    public var id: Int32
    {
        get
        {
            return self.mIdProyecto
        }
        set
        {
            self.mIdProyecto=newValue
        }
    }
    
    private var mNombreProyecto: String
    public var nombre: String
    {
        get
        {
            return self.mNombreProyecto
        }
        set
        {
            self.mNombreProyecto=newValue
        }
    }
    
    private var  mIdiomaCliente: String
    public var idiomaCliente: String
    {
        get
        {
            return self.mIdiomaCliente
        }
        set
        {
            self.mIdiomaCliente=newValue
        }
    }
    
    private var mEstado: Int
    public var estado: Int
    {
        get
        {
            return self.mEstado
        }
        set
        {
            self.mEstado = newValue
        }
    }
}

enum Estado: Int
{
    case nuevo = 0
    case actualizado = 1
    case eliminado = 2
    case antiguo = 3
}

public class RegistroHora
{
    init()
    {
        self.mCorrelativo = 0
        self.mAsunto = ""
        self.mHoras = 0
        self.mMinutos = 0
        self.mAbogadoId = 0
        self.mModificable = false
        self.mOffLine = false
        self.mFechaHoraIngreso = Date()
        self.mId = 0
        self.mEstado = .nuevo
        self.mProyectoId = 0
        self.proyecto = ClienteProyecto()
        self.fechaInsert = nil
    }
    
    private var mEstado: Estado
    var estado: Estado
    {
        get
        {
            return self.mEstado
        }
        set
        {
            self.mEstado = newValue
            
        }
    }
    
    private var mId: Int32
    var id: Int32
    {
        get
        {
            return self.mId
        }
        set
        {
            self.mId = newValue
        }
    }
    
    private var mCorrelativo:Int32
    var tim_correl: Int32
    {
        get
        {
            return self.mCorrelativo
        }
        set
        {
            self.mCorrelativo = newValue
        }
    }
    
    private var mFechaHoraIngreso: Date?
    var fechaHoraIngreso: Date?
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
    
    var fechaHoraIngresoToHHmm : String
    {
        get
        {
            let strFechaIng : String =  Utils.toStringFromDate(self.mFechaHoraIngreso!, "HH:mm")
            return strFechaIng
        }
    }
    
    
    private var mAsunto: String
    var asunto: String
    {
        get
        {
            return self.mAsunto
        }
        set
        {
            self.mAsunto = newValue
        }
    }
    
    private var mHoras:Int
    var horasTrabajadas:Int
    {
        get
        {
            return self.mHoras
        }
        set
        {
            self.mHoras=newValue
        }
    }
    
    private var mMinutos:Int
    var minutosTrabajados: Int
    {
        get
        {
            return self.mMinutos
            
        }
        set
        {
            self.mMinutos = newValue
        }
    }
    
    private var mAbogadoId:Int
    var abogadoId: Int
    {
        get
        {
            return self.mAbogadoId
        }
        set
        {
            self.mAbogadoId = newValue
        }
    }
    
    private var mModificable: Bool
    var modificable: Bool
    {
        get
        {
            return self.mModificable
        }
        set
        {
            self.mModificable = newValue
        }
    }
    
    private var mOffLine: Bool
    var offline: Bool
    {
        get
        {
            return self.mOffLine
        }
        set
        {
            self.mOffLine = newValue
        }
    }
    
    private var mProyectoId:Int32
    var proyectoId: Int32
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
    
    private var mProyecto: ClienteProyecto!
    var proyecto: ClienteProyecto
    {
        get
        {
            return self.mProyecto
        }
        set
        {
            self.mProyecto = newValue
        }
    }
    
    private var mFechaInsert: Date?
    var fechaInsert: Date?
    {
        get
        {
            return self.mFechaInsert
        }
        set
        {
            self.mFechaInsert = newValue
        }
    }
    
    public func isValid() -> Bool
    {
        if self.mCorrelativo == 0 { return false }
        
        if self.mHoras == 0  { return false }
        
        if self.mMinutos == 0 { return false }
        
        if self.asunto == "" { return false }
        
        if self.mFechaHoraIngreso  == nil { return false }
        
        if self.mProyectoId == 0 { return false }
        
        return true
    }
}

public class Dia
{
    init()
    {
        self.mNombre = ""
        self.mNro = 0
        self.mFecha = ""
    }
    
    private var mNombre:String
    var nombre:String
    {
        get
        {
            return self.mNombre
        }
        set
        {
            self.mNombre = newValue
        }
    }
    
    private var mNro:Int
    var nro: Int
    {
        get
        {
            return self.mNro
        }
        set
        {
            self.mNro = newValue
        }
    }

    private var mFecha: String
    var fecha: String
    {
        get
        {
            return self.mFecha
        }
        set
        {
            self.mFecha=newValue
        }
    }
}

public class CabeceraHora
{
    var estado: Int!
    var mensaje: String!
    var data : [RegistroHora]!
}
