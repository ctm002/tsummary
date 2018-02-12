import Foundation

public class PresenterHora
{
    private var mView: IViewHora?
    private var mEditViewHora:IEditViewHora!
    
    init(_ view: IViewHora)
    {
        self.mView = view
        self.mEditViewHora = nil
    }
    
    init(_ view: IEditViewHora)
    {
        self.mView = nil
        self.mEditViewHora = view
    }
    
    
    func buscarHoras()
    {
        let fecha : String =  self.mView!.fechaHoraIngreso
        let codigo : Int = self.mView!.idAbogado
        if let hrs = ControladorLogica.instance.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo),fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    func guardar()
    {

        let id: Int32  = self.mEditViewHora!.idHora
        
        var detalle : Hora
        if let detalleDB = DataStore.horas.getById(id)
        {
            detalle = detalleDB
            detalle.estado = .actualizado
        }
        else
        {
            detalle = Hora()
            detalle.tim_correl = 0
            detalle.estado = .nuevo
            detalle.modificable = true
        }
        
        let proyectoId = self.mEditViewHora!.proyectoId
        let fechaIngreso = self.mEditViewHora!.fechaHoraIngreso
        let idAbogado = self.mEditViewHora!.idAbogado
        let asunto = self.mEditViewHora!.asunto
        let cantHoras = self.mEditViewHora!.horas
        let cantMinutos = self.mEditViewHora!.minutos
        
        detalle.proyecto.id = Int32(proyectoId)
        detalle.fechaHoraIngreso = fechaIngreso
        detalle.abogadoId = Int(idAbogado)
        detalle.asunto = asunto
        detalle.horasTrabajadas = Int(cantHoras)
        detalle.minutosTrabajados = Int(cantMinutos)
        detalle.offline = true
        detalle.fechaInsert = Date()
        
        ControladorLogica.instance.guardar(hora: detalle, callback: {(response: Response) in
            self.mEditViewHora.setResponse(response)
        })
    }
    
    func eliminar()
    {
        let id: Int32  = self.mEditViewHora!.idHora
        ControladorLogica.instance.eliminarById(id, callback: { (response:Response) in
                self.mEditViewHora.setResponse(response)
        })
    }
}



