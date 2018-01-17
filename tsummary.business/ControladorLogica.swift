import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func eliminarById(_ id: Int32)
    {
        if let hora = DataBase.horas.getById(id)
        {
            hora.Estado = .eliminado
            hora.offline = true
            DataBase.horas.eliminar(hora)
            
            /*
            WSTimeSummary.instance.eliminar(hora: hora, retorno: { (hora) -> Void in
                 DataBase.horas.eliminar(hora)
            })
            */
        }
    }
    
    func guardar(_ hora: Horas)
    {
        DataBase.horas.guardar(hora)
        
        /*
        WSTimeSummary.instance.guardar(hora: hora, retorno: { (hora)-> Void in
            if let hrs = hora
            {
                DataBase.horas.guardar(hrs)
            }
        })
         */
    }
    
    func sincronizar(_ codigo: String,_ callback: @escaping (Bool) -> Void)
    {
        sincronizarProyectos(codigo, callback)
    }
    
    private func sincronizarProyectos(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        WSTimeSummary.instance.obtListProyectosByCodAbogado(codigo: codigo, callback: { (proyectosRemotos) -> Void in
            
            let proyectosLocalesIds = DataBase.proyectos.obtListProyectos()?.map { $0.pro_id }
            let proyectosNuevos = proyectosRemotos?.filter {
                !((proyectosLocalesIds?.contains($0.pro_id))!)
            }
            let result = DataBase.proyectos.save(proyectosNuevos!)
            if (result)
            {
                print("proyectos actualizados")
            }
            self.sincronizarHoras(codigo, retorno)
        })
    }
    
    private func sincronizarHoras(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        WSTimeSummary.instance.obtListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            var resp : Bool = false
            if let hrsLocales = DataBase.horas.obtListHorasByCodAbogado(codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    resp = DataBase.horas.guardar(nuevos)
                }
                
                let eliminados : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: hrsRemotas!)
                if (eliminados.count > 0)
                {
                    resp = DataBase.horas.eliminar(eliminados)
                }
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                        resp = DataBase.horas.guardar(hrs)
                    }
                }
            }
            print("horas descargadas")
            retorno(resp)
        }, Date(), Date())
    }
    
    func minus(arreglo1:[Horas], arreglo2:[Horas]) -> [Horas]
    {
        var resultado = [Horas]()
        
        var exists : Bool = false
        for i in arreglo1
        {
            for j in arreglo2 {
                if i.tim_correl == j.tim_correl
                {
                    exists = true
                }
            }
            if (exists == false)
            {
                resultado.append(i)
            }
            exists = false
        }
        return resultado
    }
    
    func eliminarTodo()
    {
        DataBase.horas.eliminarTodo()
    }
}
