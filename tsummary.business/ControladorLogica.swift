import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func eliminarById(_ id: Int32)
    {
        if let hora = DataBase.horas.getById(id)
        {
            hora.estado = .eliminado
            hora.offline = true
            DataBase.horas.eliminar(hora)
            
            /*
            WSTimeSummary.instance.eliminar(hora: hora, retorno: { (hora) -> Void in
                 DataBase.horas.eliminar(hora)
            })
            */
        }
    }
    
    func guardar(_ hora: Hora) -> Bool
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
    
    func sincronizar(_ session: SessionLocal,_ callback: @escaping (Bool) -> Void)
    {
        sincronizarProyectos(session, callback)
    }
    
    private func sincronizarProyectos(_ session: SessionLocal,_ retorno: @escaping (Bool) -> Void)
    {
        ApiClient.instance.obtListProyectosByCodAbogado(session, callback: { (proyectosRemotos) -> Void in
            
            let proyectosLocalesIds = DataBase.proyectos.obtListProyectos()?.map { $0.id }
            let proyectosNuevos = proyectosRemotos?.filter {!((proyectosLocalesIds?.contains($0.id))!)}
            let result = DataBase.proyectos.guardar(proyectosNuevos!)
            if (result)
            {
                print("proyectos descargados")
            }
            self.sincronizarHoras(session, retorno)
        })
    }
    
    private func sincronizarHoras(_ session: SessionLocal,_ retorno: @escaping (Bool) -> Void)
    {
        let codigo : String = String(describing: session.usuario?.id)
        let fDesde : String =  "20180101" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        let fHasta : String =  "20181231" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        
        ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta, callback:{(hrsRemotas)->Void in
            
            var resp : Bool = false
            if let hrsLocales = DataBase.horas.obtListHorasByCodAbogado(codigo, fDesde, fHasta)
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
                    ApiClient.instance.guardar(hrs, {(hora: Hora?) -> Void in
                        if let hr = hora
                        {
                            print("hora actualizada remotamente -> \(hr.tim_correl)")
                            DataBase.horas.guardar(hr)
                        }
                    })
                }
                
                //Actualizar hora locales que han sido actualizadas remotamente
                hrsLocales.forEach { hrs in
                    let hrsResult = hrsRemotas?.filter( {$0.tim_correl == hrs.tim_correl && $0.fechaInsert! > hrs.fechaInsert!})
                    if let hrsResult = hrsResult
                    {
                        if hrsResult.count > 0
                        {
                            let hr = hrsResult[0]
                            hr.offline = false
                            hr.id = hrs.id
                            
                            print("hora actualizada localmente -> \(hr.tim_correl)")
                            DataBase.horas.guardar(hr)
                        }
                    }
                }
                
                //Actualizar horas remotas que han sido actualizadas localmente
                hrsLocales.forEach { hrs in
                    let hrsResult = hrsRemotas?.filter( {$0.tim_correl == hrs.tim_correl && $0.fechaInsert! < hrs.fechaInsert!})
                    if let hrsRemotas = hrsResult
                    {
                        if hrsRemotas.count > 0
                        {
                            ApiClient.instance.guardar(hrs, {(hora: Hora?) -> Void in
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
        })
    }
    
    func eliminarDatos()
    {
        DataBase.horas.eliminar()
        DataBase.proyectos.eliminar()
        DataBase.usuarios.eliminar()
    }
    
    func borrarTablas()
    {
        DataBase.horas.dropTable()
        DataBase.proyectos.dropTable()  
        DataBase.usuarios.dropTable()
    }
    
    func autentificar(_ user: String, _ password: String, _ imei: String) -> SessionLocal?
    {
        return DataBase.usuarios.autentificar(imei: imei, user: user, password: password)
    }
    
    func validar(_ imei: String) -> SessionLocal?
    {
        return DataBase.usuarios.validar(imei)
    }
    
    func guardar(_ session: SessionLocal) -> Bool
    {
        return DataBase.usuarios.guardar(sessionLocal: session)
    }
}
