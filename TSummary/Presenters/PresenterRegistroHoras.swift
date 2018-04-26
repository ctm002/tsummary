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
        let cantHoras = self.mEditViewRegistroHora!.horas
        let cantMinutos = self.mEditViewRegistroHora!.minutos
        let nombreProyecto = self.mEditViewRegistroHora!.proyectoNombre
        
        registro.proyecto.id = nombreProyecto == "" ? 0 : Int32(proyectoId)
        registro.fechaHoraInicio = fechaHoraInicio
        registro.fechaInsert = Date()
        registro.abogadoId = idAbogado
        registro.asunto = asunto
        registro.horasTrabajadas = Int(cantHoras)
        registro.minutosTrabajados = Int(cantMinutos)
        registro.offline = true
        registro.fechaInsert = Date()
        registro.fechaUpdate = Date()
        
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
