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
            
            var detalle : Hora
            if let detalleHoraTemp = DataBase.horas.getById(id)
            {
                detalle = detalleHoraTemp
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
            
            ControladorLogica.instance.guardar(hora: detalle, callback: self.response)
        }
        catch let error
        {
            print("\(error)")
        }
    }
    
    @objc func response(result: Int)
    {
        switch result
        {
            case 1:
                print("Los datos fueron guardados en la nube")
            case 2:
                print("Los datos fueron guardados localmente")
            default:
                print("Error")
        }
    }
    
    func eliminar() -> Bool
    {
        let id: Int32  = self.mEditViewHora!.idHora
        ControladorLogica.instance.eliminarById(id, callback: response)
        return true
    }
}
