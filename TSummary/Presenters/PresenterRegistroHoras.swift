import Foundation

public class PresenterRegistroHoras
{
    private var mView: IViewHora?
    private var mEditViewRegistroHora:IEditViewHora!
    
    init(_ view: IViewHora)
    {
        self.mView = view
        self.mEditViewRegistroHora = nil
    }
    
    init(_ view: IEditViewHora)
    {
        self.mView = nil
        self.mEditViewRegistroHora = view
    }
    
    
    func buscarHoras()
    {
        let fecha : String =  self.mView!.fechaHoraIngreso
        let id : Int32 = Int32(self.mView!.idAbogado)
        if let hrs = ControladorLogica.instance.getListDetalleHorasByIdAbogadoAndFecha(id, fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func guardar()
    {

        let id: Int32  = self.mEditViewRegistroHora!.idHora
        
        var registro : RegistroHora
        if let detalleDB = DataStore.horas.getById(id)
        {
            registro = detalleDB
            registro.estado = .actualizado
        }
        else
        {
            registro = RegistroHora()
            registro.tim_correl = 0
            registro.estado = .nuevo
            registro.modificable = true
        }
        
        let proyectoId = self.mEditViewRegistroHora!.proyectoId
        let fechaHoraInicio = self.mEditViewRegistroHora!.fechaHoraIngreso

        let idAbogado = self.mEditViewRegistroHora!.idAbogado
        let asunto = self.mEditViewRegistroHora!.asunto
        
        let horaInicio = self.mEditViewRegistroHora!.horaInicio
        let aHoraInicio = horaInicio.split(separator: ":")
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fechaHoraInicio)
        components.hour = Int(aHoraInicio[0])!
        components.minute = Int(aHoraInicio[1])!
        components.second = 00
        let newDate = calendar.date(from:components)!
        
        //let horaFin = self.mEditViewRegistroHora!.horaFin
        
        registro.proyecto.id = Int32(proyectoId)
        registro.fechaHoraInicio = newDate
        registro.abogadoId = idAbogado
        registro.asunto = asunto
        registro.offline = true
        registro.fechaInsert = Date()
        registro.fechaUpdate = Date()
        
        let horaTotal  = self.mEditViewRegistroHora.horaTotal
        let aTotalHora = horaTotal.split(separator: ":")
        registro.total = Hora(horas: Int(aTotalHora[0])!, minutos: Int(aTotalHora[1])!)
        ControladorLogica.instance.guardar(hora: registro, callback: {(response: Response) in
            self.mEditViewRegistroHora.response = response
        })
    }
    
    func eliminar()
    {
        let id: Int32  = self.mEditViewRegistroHora!.idHora
        ControladorLogica.instance.eliminarById(id, callback: { (response:Response) in
                self.mEditViewRegistroHora.response = response
        })
    }

}
