import Foundation

public class ControladorProyecto
{
    static let instance = ControladorProyecto()
    
    init() {}
    
    func syncronizer(_ codigo: String) -> Bool
    {
        //sincronizarProyectos(codigo: codigo)
        sincronizarHoras(codigo)
        return true
    }
    
    
    private func sincronizarHoras(_ codigo: String) -> Bool
    {
        WSTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            if let hrsLocales = LocalStoreTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    do
                    {
                        try  LocalStoreTimeSummary.instance.open()
                        for h in nuevos
                        {
                            LocalStoreTimeSummary.instance.save(h)
                        }
                        LocalStoreTimeSummary.instance.close()
                    }
                    catch
                    {
                        
                    }
                }
                
                
                let eliminados : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: hrsRemotas!)
                if (eliminados.count > 0)
                {
                    do
                    {
                        try LocalStoreTimeSummary.instance.open()
                        for e in eliminados
                        {
                            e.Estado = .eliminado
                            LocalStoreTimeSummary.instance.delete(e)
                        }
                        LocalStoreTimeSummary.instance.close()
                    }
                    catch{
                        
                    }
                }
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                        LocalStoreTimeSummary.instance.save(hrs)
                    }
                }
            }
         })
        return true
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
    
    func delete(_ horas: [Horas]) -> Bool
    {
        do
        {
            try LocalStoreTimeSummary.instance.open()
            for h in horas {
                LocalStoreTimeSummary.instance.delete(hora)
            }
            LocalStoreTimeSummary.instance.close()
        }
        catch
        {
            LocalStoreTimeSummary.instance.close()
            print("Error: delete")
        }
    }
    
    func save(_ horas:[Horas]) -> Bool
    {
        do
        {
            try LocalStoreTimeSummary.instance.open()
            for h in horas {
                LocalStoreTimeSummary.instance.save(hora)
            }
            LocalStoreTimeSummary.instance.close()
        }
        catch
        {
            LocalStoreTimeSummary.instance.close()
            print("Error: delete")
        }
    }
    
    private func sincronizarProyectos(_ codigo: String) -> Bool
    {
        var resp : Bool = false
        WSTimeSummary.instance.getListProyectosByCodAbogado(codigo: codigo, callback: { (proyectos) -> Void in
            do
            {
                try LocalStoreTimeSummary.instance.open()
                LocalStoreTimeSummary.instance.save(proyectos!)
                LocalStoreTimeSummary.instance.close()
                resp = true
            }
            catch{
                print("Error: sincronizarProyectos")
                LocalStoreTimeSummary.instance.close()
            }
        })
        return resp
    }
    
    public func save(_ hora: Horas)-> Bool
    {
        var resp: Bool = false
        do
        {
            try LocalStoreTimeSummary.instance.open()
            if hora.IdHora == 0
            {
                resp =  LocalStoreTimeSummary.instance.save(hora)
            }
            else{
                resp = LocalStoreTimeSummary.instance.update(hora)
            }
            LocalStoreTimeSummary.instance.close()
        }
        catch{
            print("Error: save")
            LocalStoreTimeSummary.instance.close()
        }
        return resp
    }
    
    public func getById(_ id: Int32)-> Horas?
    {
        do{
            try LocalStoreTimeSummary.instance.open()
            let hora =  LocalStoreTimeSummary.instance.getById(id)
            LocalStoreTimeSummary.instance.close()
            return hora
        }
        catch
        {
            print("Error: getById")
            LocalStoreTimeSummary.instance.close()
        }
        return nil
    }
    
    public func getListHorasByCodAbogado(_ codigo: String) -> [Horas]?
    {
        do
        {
            try LocalStoreTimeSummary.instance.open()
            let horas =  LocalStoreTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo)
            LocalStoreTimeSummary.instance.close()
            return horas
        }
        catch
        {
            print("Error: getListHorasByCodAbogado")
            LocalStoreTimeSummary.instance.close()
        }
        return nil
    }
    
    public func delete(_ hora:Horas) -> Bool
    {
        do
        {
            hora.Estado = .eliminado
            try LocalStoreTimeSummary.instance.open()
            LocalStoreTimeSummary.instance.delete(hora)
            LocalStoreTimeSummary.instance.close()
            return true
        }
        catch
        {
            print("Error: delete")
            LocalStoreTimeSummary.instance.close()
        }
        return false
    }
}
