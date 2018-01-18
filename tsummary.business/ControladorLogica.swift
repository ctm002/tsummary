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
    
    func guardar(_ hora: Horas) -> Bool
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
        return true
    }
    
    func sincronizar(_ codigo: String,_ callback: @escaping (Bool) -> Void)
    {
        sincronizarProyectos(codigo, callback)
    }
    
    private func sincronizarProyectos(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        ApiClient.instance.obtListProyectosByCodAbogado(codigo: codigo, callback: { (proyectosRemotos) -> Void in
            let proyectosLocalesIds = DataBase.proyectos.obtListProyectos()?.map { $0.pro_id }
            let proyectosNuevos = proyectosRemotos?.filter {
                !((proyectosLocalesIds?.contains($0.pro_id))!)
            }
            let result = DataBase.proyectos.guardar(proyectosNuevos!)
            if (result)
            {
                print("proyectos actualizados")
            }
            self.sincronizarHoras(codigo, retorno)
        })
    }
    
    private func sincronizarHoras(_ codigo: String,_ retorno: @escaping (Bool) -> Void)
    {
        ApiClient.instance.obtListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            var resp : Bool = false
            if let hrsLocales = DataBase.horas.obtListHorasByCodAbogado(codigo)
            {
                let hrsLocalesIds = hrsLocales.map { $0.tim_correl }
                let hrsRemotasIds = hrsRemotas?.map { $0.tim_correl }
                
                let hrsNuevas = hrsRemotas?.filter {
                     !hrsLocalesIds.contains($0.tim_correl)
                }
                
                if let hrsNuevas = hrsNuevas {
                    resp = DataBase.horas.guardar(hrsNuevas)
                }
                
                let hrsEliminadas = hrsLocales.filter {
                    !(hrsRemotasIds?.contains($0.tim_correl))! && $0.tim_correl != 0
                }
                resp = DataBase.horas.eliminar(hrsEliminadas)
            
                let hrsNuevasLocales = hrsLocales.filter { $0.tim_correl == 0}
                hrsNuevasLocales.forEach { hrs in
                    ApiClient.instance.guardar(hrs, {(hora: Horas?) -> Void in
                        if let hr = hora
                        {
                            print(hr.tim_correl)
                            DataBase.horas.guardar(hr)
                        }
                    })
                }
                
                //Actualizar hora locales que han sido actualizadas remotamente
                hrsLocales.forEach { hrs in
                    let hrsActualizadasLocales = hrsRemotas?.filter( {$0.tim_correl == hrs.tim_correl && $0.fechaUltMod! > hrs.fechaUltMod!})
                    if let hrs = hrsActualizadasLocales
                    {
                        if hrs.count > 0
                        {
                           DataBase.horas.guardar(hrs[0])
                        }
                    }
                }
                
                //Actualizar horas remotas que han sido actualizadas localmente
                hrsLocales.forEach { hrs in
                    let hrsActualizadasRemotas = hrsRemotas?.filter( {$0.tim_correl == hrs.tim_correl && $0.fechaUltMod! < hrs.fechaUltMod!})
                    if let hrs = hrsActualizadasRemotas
                    {
                        if hrs.count > 0
                        {
                            ApiClient.instance.guardar(hrs[0], {(hora: Horas?) -> Void in
                                if let hr = hora
                                {
                                    print("\(hr.tim_correl)")
                                }
                            })
                        }
                    }
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
    
    func eliminarTodo()
    {
        DataBase.horas.eliminar()
    }
}
