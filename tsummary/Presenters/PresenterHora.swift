import Foundation

public class PresenterHora{
    
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
        if let hrs = DataBase.horas.getListDetalleHorasByCodAbogadoAndFecha(codigo: String(codigo),fecha: fecha)
        {
            self.mView?.setList(horas: hrs)
        }
    }
    
    /*
    func buscar()
    {
        let id : Int32 = self.mEditViewHora!.idHora
        if let detalleHora : Hora = DataBase.horas.getById(id)
        {
            self.mEditViewHora.asunto = detalleHora.asunto
            self.mEditViewHora.minutos = detalleHora.minutosTrabajados
            self.mEditViewHora.horas = detalleHora.horasTrabajadas
            self.mEditViewHora.proyectoId = detalleHora.proyecto.id
            self.mEditViewHora.setNombreProyecto(detalleHora.proyecto)
            self.mEditViewHora.fechaHoraIngreso = detalleHora.fechaHoraIngreso
            self.mEditViewHora.bloquearBotones(detalleHora.modificable)
        }
    }
    */
    
    func guardar()
    {
        do
        {
            let id: Int32  = self.mEditViewHora!.idHora
            
            var detalleHora : Hora
            if let detalleHoraTemp = DataBase.horas.getById(id)
            {
                detalleHora = detalleHoraTemp
                detalleHora.estado = .actualizado
            }
            else
            {
                detalleHora = Hora()
                detalleHora.tim_correl = 0
                detalleHora.estado = .nuevo
                detalleHora.modificable = true
            }
            
            let proyectoId = self.mEditViewHora!.proyectoId
            let fechaIngreso = self.mEditViewHora!.fechaHoraIngreso
            let idAbogado = self.mEditViewHora!.idAbogado
            let asunto = self.mEditViewHora!.asunto
            let cantHoras = self.mEditViewHora!.horas
            let cantMinutos = self.mEditViewHora!.minutos
            
            detalleHora.proyecto.id = Int32(proyectoId)
            detalleHora.fechaHoraIngreso = fechaIngreso
            detalleHora.abogadoId = Int(idAbogado)
            detalleHora.asunto = asunto
            detalleHora.horasTrabajadas = Int(cantHoras)
            detalleHora.minutosTrabajados = Int(cantMinutos)
            detalleHora.offline = true
            detalleHora.fechaInsert = Date()
            
            let result : Bool = ControladorLogica.instance.guardar(detalleHora)
            if (result == true){ print("operacion exitosa") }
 
        }
        catch let error
        {
            print("\(error)")
        }
    }
    
    func eliminar() -> Bool
    {
        let id: Int32  = self.mEditViewHora!.idHora
        ControladorLogica.instance.eliminarById(id)
        return true
    }
}
