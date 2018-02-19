import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func eliminarById(_ id: Int32,  callback: @escaping (Response) -> Void)
    {
        var result: Response!
        if let hora = DataStore.horas.getById(id)
        {
            if  true//Reachability.isConnectedToNetwork()
            {
                ApiClient.instance.eliminar(hora: hora,
                    responseOK: { (hora) -> Void in
                        hora.estado = .eliminado
                        hora.offline = false
                        let rowAffected = DataStore.horas.eliminar(hora)
                        if rowAffected
                        {
                            result = Response(estado: 3, mensaje: "Se elimino remotamente y localmente", result: true)
                        }
                        else
                        {
                            result = Response(estado: 2, mensaje: "Se elimino remotamente pero no localmente", result: false)
                        }
                        callback(result)
                    },
                    responseError: { (hora) -> Void in
                        hora.estado = .eliminado
                        hora.offline = true
                        let rowAffected = DataStore.horas.eliminar(hora)
                        if rowAffected
                        {
                            result = Response(estado: 1, mensaje: "No se elimino remotamente pero si localmente",  result: false)
                        }
                        else
                        {
                            result = Response(estado: 0, mensaje: "No se elimino remotamente ni localmente", result: false)
                        }
                        callback(result)
                    }
                )
            }
            else
            {
                hora.estado = .eliminado
                hora.offline = true
                let rowAffected = DataStore.horas.eliminar(hora)
                if (rowAffected)
                {
                    result = Response(estado: 1, mensaje: "No se elimino remotamente pero si localmente", result: false)
                }
                else
                {
                    result = Response(estado: 0, mensaje: "No se elimino remotamente ni localmente", result: false)
                }
                callback(result)
            }
        }
    }
    
    func descargar(session: SessionLocal , fDesde: String, fHasta: String, redirect: @escaping (Bool)->Void)
    {
        ApiClient.instance.obtListProyectosByCodAbogado(session, callback: { (proyectosRemotos) -> Void in
            if let proyectos = proyectosRemotos
            {
                let resp = DataStore.proyectos.guardar(proyectos)
                if resp
                {
                    ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta,
                        callback:{(hrsRemotas)->Void in
                            if let horas = hrsRemotas
                            {
                                let resp : Bool = DataStore.horas.guardar(horas)
                                redirect(resp)
                            }
                        }
                    )
                }
            }
        })
    }
    
    func guardar(hora: Hora, callback: @escaping (Response) -> Void)
    {
        var result: Response!

        if  true //Reachability.isConnectedToNetwork()
        {
            ApiClient.instance.guardar(hora: hora
            , responseOK: { (hora) -> Void in
                hora.estado = .antiguo
                hora.offline = false
                let rowAffected = DataStore.horas.guardar(hora)
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
                let rowAffected = DataStore.horas.guardar(hora)
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
            let rowAffected = DataStore.horas.guardar(hora)
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
            let proyectosLocalesIds = DataStore.proyectos.obtListProyectos()?.map { $0.id }
            let proyectosNuevos = proyectosRemotos?.filter {!((proyectosLocalesIds?.contains($0.id))!)}
            if proyectosNuevos != nil
            {
                let result = DataStore.proyectos.guardar(proyectosNuevos!)
                if result
                {
                    print("proyectos descargados")
                }
            }
            self.sincronizarHoras(session, retorno)
        })
    }
    
    private func sincronizarHoras(_ session: SessionLocal,_ retorno: @escaping (Bool) -> Void)
    {
        let codigo : String = String(describing: session.usuario?.id)
        let fDesde : String =  "20180101" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        let fHasta : String =  "20181231" //Utils.toStringFromDate(Date(),"yyyyMMdd")
        
        if let horas : [Hora] = DataStore.horas.getListDetalleHorasOffline(codigo: codigo)
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
                
                DataStore.horas.eliminar()
                
                ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta
                , callback:{(hrsRemotas)->Void in
                    if hrsRemotas != nil
                    {
                        let result : Bool = DataStore.horas.guardar(hrsRemotas!)
                        if (result)
                        {
                            print("Los datos fueron guardados correctamente")
                        }
                    }
                })
            }
        }
        retorno(true)
    }
    
    func obtSessionLocal(loginName: String = "", password: String = "", imei: String = "") -> SessionLocal?
    {
        return DataStore.usuarios.obtSessionLocal(imei: imei, loginName: loginName, password: password)
    }
    
    func guardar(_ session: SessionLocal) -> Bool
    {
        let exists = DataStore.usuarios.existsSessionLocal(loginName: (session.usuario?.loginName)!)
        if exists
        {
            return DataStore.usuarios.actualizar(sessionLocal: session)
        }
        else
        {
            return DataStore.usuarios.guardar(sessionLocal: session)
        }
    }
    
    func getListDetalleHorasByCodAbogadoAndFecha(codigo: String, fecha: String) -> [Hora]?
    {
        return DataStore.horas.getListDetalleHorasByCodAbogadoAndFecha(codigo: codigo,fecha: fecha)
    }
    
    func descargarImagenByIdUsuario(id: Int, callback: @escaping (String)-> Void)
    {
        ApiClient.instance.obtImagePerfilById(id: id, callback: {(string64) in
            callback(string64)
        })
    }
    
    func actualizarFoto(id: Int32, string64: String) -> Bool
    {
       return DataStore.usuarios.actualizar(id: id, data: string64)
    }
    
    func obtUsuarioById(id: Int) -> Usuario?
    {
        return DataStore.usuarios.obtUsuarioById(id: id)
    }
    
    func eliminarDatos()
    {
        DataStore.horas.eliminar()
        DataStore.proyectos.eliminar()
        DataStore.usuarios.eliminar()
    }
    
    func borrarTablas()
    {
        DataStore.horas.dropTable()
        DataStore.proyectos.dropTable()
        DataStore.usuarios.dropTable()
    }

}
