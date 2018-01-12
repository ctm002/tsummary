import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func eliminarById(_ id:Int32)-> Bool
    {
        if let hora = DataBase.horas.getById(id)
        {
            hora.Estado = .eliminado
            hora.offline = true
            DataBase.horas.eliminar(hora)
            return true
        }
        return false
    }
    
    func guardar(_ hora: Horas)
    {
        WSTimeSummary.instance.guardar(hora: hora, retorno: { (hora)-> Void in
            if let hrs = hora
            {
                DataBase.horas.guardar(hrs)
            }
        })
    }
    
    func sincronizar(_ codigo: String,_ callback: @escaping (Bool) -> Void)
    {
        sincronizarProyectos(codigo, callback)
    }
    
    private func sincronizarProyectos(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        WSTimeSummary.instance.obtListProyectosByCodAbogado(codigo: codigo, callback: { (proyectos) -> Void in
            for p in proyectos!
            {
                let exists = DataBase.proyectos.obtById(p.pro_id)
                if (exists == nil)
                {
                   DataBase.proyectos.guardar(p)
                }
            }
            print("proyectos descargados")
            self.sincronizarHoras(codigo, retorno)
        })
    }
    
    private func sincronizarHoras(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        WSTimeSummary.instance.obtListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            if let hrsLocales = DataBase.horas.obtListHorasByCodAbogado(codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    DataBase.horas.guardar(nuevos)
                }
                
                let eliminados : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: hrsRemotas!)
                if (eliminados.count > 0)
                {
                    DataBase.horas.eliminar(eliminados)
                }
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                        DataBase.horas.guardar(hrs)
                    }
                }
            }
            print("horas descargadas")
            retorno(true)
        })
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
