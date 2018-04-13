import Foundation
struct ModelController
{
    var id : Int32
    var idAbogado : Int32
    var fechaHoraIngreso : Date
    var idProyecto : Int32
    var nombreProyecto : String
    var nombreCliente : String
    var horas : Int
    var minutos : Int
    var asunto : String
    var correlativo: Int32
    var modificable : Bool
    var offline : Bool
    
    init(id: Int32, abogadoId: Int32, fechaHoraIngreso: Date)
    {
        self.id = id
        self.idAbogado = abogadoId
        self.fechaHoraIngreso = fechaHoraIngreso
        self.horas = 0
        self.minutos = 0
        self.asunto = ""
        self.correlativo = 0
        self.modificable = true
        self.offline = false
        self.idProyecto = 0
        self.nombreProyecto = ""
        self.nombreCliente = ""
    }
    
    init(id: Int32, abogadoId: Int32, fechaHoraIngreso: Date,
         idProyecto: Int32, nombreProyecto: String, nombreCliente: String, horas: Int, minutos: Int,
         asunto: String, correlativo : Int32, modificable: Bool, offline: Bool) {
        
        self.init(id: id, abogadoId: abogadoId, fechaHoraIngreso: fechaHoraIngreso)
        
        self.horas = horas
        self.minutos = minutos
        self.asunto = asunto
        self.correlativo = correlativo
        self.modificable = modificable
        self.offline = offline
        self.idProyecto = idProyecto
        self.nombreProyecto = nombreProyecto
        self.nombreCliente = nombreCliente
    }
}
