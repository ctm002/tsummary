import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func eliminarById(_ id: Int32) -> Response
    {
        var result: Response!
        if let hora = DataBase.horas.getById(id)
        {
            if Reachability.isConnectedToNetwork()
            {
                ApiClient.instance.eliminar(hora: hora,
                    responseOK: { (hora) -> Void in
                        hora.estado = .eliminado
                        hora.offline = false
                        let rowAffected = DataBase.horas.eliminar(hora)
                        if rowAffected
                        {
                            result = Response(estado: 3, mensaje: "Se elimino remotamente y localmente", result: true)
                        }
                        else
                        {
                            result = Response(estado: 2, mensaje: "Se elimino remotamente pero no localmente", result: false)
                        }
                    },
                    responseError: { (hora) -> Void in
                        hora.estado = .eliminado
                        hora.offline = true
                        let rowAffected = DataBase.horas.eliminar(hora)
                        if rowAffected
                        {
                            result = Response(estado: 1, mensaje: "No se elimino remotamente pero si localmente",  result: false)
                        }
                        else
                        {
                            result = Response(estado: 0, mensaje: "No se elimino remotamente ni localmente", result: false)
                        }
                    }
                )
            }
            else
            {
                hora.estado = .eliminado
                hora.offline = true
                let rowAffected = DataBase.horas.eliminar(hora)
                if (rowAffected)
                {
                    result = Response(estado: 1, mensaje: "No se elimino remotamente pero si localmente", result: false)
                }
                else
                {
                    result = Response(estado: 0, mensaje: "No se elimino remotamente ni localmente", result: false)
                }
            }
        }
        return result
    }
    
    func guardar(hora: Hora, callback: @escaping (Response) -> Void)
    {
        var result: Response!

        if Reachability.isConnectedToNetwork()
        {
            ApiClient.instance.guardar(hora: hora
            , responseOK: { (hora) -> Void in
                hora.estado = .antiguo
                hora.offline = false
                let rowAffected = DataBase.horas.guardar(hora)
                if rowAffected
                {
                    result = Response(estado: 0, mensaje: "Se guardo remotamente y localmente", result: true)
                }
                else
                {
                    result = Response(estado: 0, mensaje: "Se guardo remotamente pero no localmente", result: false)
                }
                callback(result)
                
            }, responseError: { (hora) -> Void in
                let rowAffected = DataBase.horas.guardar(hora)
                if rowAffected
                {
                    result = Response(estado: 0, mensaje: "No se guardo remotamente pero si localmente", result: false)
                }
                else
                {
                    result = Response(estado: 0, mensaje: "No se guardo remotamente ni localmente", result: false)
                }
                callback(result)
            })
        }
        else
        {
            let rowAffected = DataBase.horas.guardar(hora)
            if rowAffected
            {
                result = Response(estado: 1, mensaje: "No se guardo remotamente pero si localmente", result: false)
            }
            else
            {
                result = Response(estado: 0, mensaje: "No se guardo remotamente ni localmente", result: false)
            }
           callback(result)
        }
    }
    
    func sincronizar(_ session: SessionLocal,_ callback: @escaping (Bool) -> Void)
    {
        self.sincronizarProyectos(session, callback)
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
                self.sincronizarHoras(session, retorno)
            }
        })
    }
    
    private func sincronizarHoras(_ session: SessionLocal,_ retorno: @escaping (Bool) -> Void)
    {
        let codigo : String = String(describing: session.usuario?.id)
        let fDesde : String =  "20180101" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        let fHasta : String =  "20181231" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        
        if let horas : [Hora] = DataBase.horas.getListDetalleHorasOffline(codigo: codigo)
        {
            if horas.count > 0
            {
                var aHorasTS : [HoraTS] = [HoraTS]()
                for h in horas
                {
                    let horaTS = HoraTS(
                        tim_correl: h.tim_correl,
                        pro_id: h.proyecto.id,
                        tim_fecha_ing: Utils.toStringFromDate(h.fechaHoraIngreso),
                        tim_asunto: h.asunto,
                        tim_horas: h.horasTrabajadas,
                        tim_minutos: h.minutosTrabajados,
                        abo_id: h.abogadoId,
                        OffLine: h.offline,
                        FechaInsert: Utils.toStringFromDate(h.fechaInsert!),
                        Estado: h.estado.rawValue)
                    
                    aHorasTS.append(horaTS)
                }
                
                let dataSend = DataSend(
                    Fecha: Utils.toStringFromDate(Date()),
                    Lista: aHorasTS)
                ApiClient.instance.sincronizar(session, dataSend)
                
                
                DataBase.horas.eliminar()
                
                ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta
                , callback:{(hrsRemotas)->Void in
                    let result : Bool = DataBase.horas.guardar(hrsRemotas!)
                })
            }
        }
        retorno(true)
        
        /*
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
                    ApiClient.instance.guardar(hora: hrs, responseOK: {(hora: Hora?) -> Void in
                        if let hr = hora
                        {
                            print("hora actualizada remotamente -> \(hr.tim_correl)")
                            DataBase.horas.guardar(hr)
                        }
                    }, responseError: { (hora: Hora?) -> Void in
                        
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
                            ApiClient.instance.guardar(hora: hrs, responseOK: {(hora: Hora?) -> Void in
                                if let hr = hora
                                {
                                    print("\(hr.tim_correl)")
                                }
                            }, responseError: { (hora: Hora?) -> Void in
                                
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
        */
        retorno(true)
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
    
    func obtSessionLocal(loginName: String = "", password: String = "", imei: String = "") -> SessionLocal?
    {
        return DataBase.usuarios.obtSessionLocal(imei: imei, loginName: loginName, password: password)
    }
    
    func guardar(_ session: SessionLocal) -> Bool
    {
        let s =  DataBase.usuarios.obtSessionLocal(loginName: (session.usuario?.loginName)!)
        if s != nil
        {
            return DataBase.usuarios.actualizar(sessionLocal: session)
        }
        else
        {
            return DataBase.usuarios.guardar(sessionLocal: session)
        }
    }
    
    func getListDetalleHorasByCodAbogadoAndFecha(codigo: String, fecha: String) -> [Hora]?
    {
        return DataBase.horas.getListDetalleHorasByCodAbogadoAndFecha(codigo: codigo,fecha: fecha)
    }
}
