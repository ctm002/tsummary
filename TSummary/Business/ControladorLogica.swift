import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    private var isConnected : Bool = false
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager), name: .flagsChanged, object: Network.reachability)
        self.statusManager()
    }
    
    @objc func statusManager()
    {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            self.isConnected = false
        case .wifi, .wwan:
            self.isConnected = true
        }
    }
    
    func eliminarById(_ id: Int32,  callback: @escaping (Response) -> Void)
    {
        var result: Response!
        if let hora = DataStore.horas.getById(id)
        {
            if self.isConnected
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
    
    func descargar(session: SessionLocal , fDesde: String, fHasta: String, redirect: @escaping (Response)->Void)
    {
        if self.isConnected
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
                                    if(resp)
                                    {
                                        redirect(Response(estado: 1, mensaje: "los datos fueron descargados y almacenados correctamente", result: true))
                                    }
                                }
                                else
                                {
                                    redirect(Response(estado: 1, mensaje: "Los datos no fueron descargados", result: true))
                                }
                            }
                        )
                    }
                    else
                    {
                        redirect(Response(estado: 1, mensaje: "Los proyectos no se guardaron localmente", result: false))
                    }
                }
                else
                {
                    redirect(Response(estado: 1, mensaje: "No se pudieron descargar los proyectos desde el webservice", result: false))
                }
            })
        }
    }
    
    func guardar(hora: RegistroHora, callback: @escaping (Response) -> Void)
    {
        var result: Response!

        if self.isConnected
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
    
    func sincronizar(_ session: SessionLocal,_ callback: @escaping (Response) -> Void)
    {
        self.sincronizarProyectos(session, callback)
    }
    
    private func sincronizarProyectos(_ session: SessionLocal,_ retorno: @escaping (Response) -> Void)
    {
        if self.isConnected
        {	
            ApiClient.instance.obtListProyectosByCodAbogado(session, callback: { (proyectosRemotos) -> Void in
                if proyectosRemotos != nil
                {
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
                }
                else
                {
                    retorno(Response(estado: 1, mensaje: "Error al descargar los proyectos desde el webservice", result: false))
                }
            })
        }
        else
        {
            retorno(Response(estado: 1, mensaje: "Sin conexion a internet", result: false))
        }
    }
    
    private func sincronizarHoras(_ session: SessionLocal,_ retorno: @escaping (Response) -> Void)
    {
        if self.isConnected
        {
            let idAbogado : Int32 = (session.usuario?.id)!
            let fDesde : String = Utils.toStringFromDate(DateCalculator.instance.fechaInicio,"yyyyMMdd")
            let fHasta : String = Utils.toStringFromDate(DateCalculator.instance.fechaTermino, "yyyyMMdd")
            
            if let horas : [RegistroHora] = DataStore.horas.getListDetalleHorasByIdAbogadoAndEstadoOffline(id: idAbogado)
            {
                if horas.count > 0
                {
                    var aHorasTS : [HoraTS] = [HoraTS]()
                    for h in horas
                    {
                        let horaTS = HoraTS(
                            tim_correl: h.tim_correl,
                            pro_id: h.proyecto.id,
                            tim_fecha_ing: Utils.toStringFromDate(h.fechaHoraIngreso!),
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
                    
                    DataStore.horas.eliminarByIdAbogado((session.usuario?.id)!)
                    
                    ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta
                    , callback:{(hrsRemotas)->Void in
                        if hrsRemotas != nil
                        {
                            let result : Bool = DataStore.horas.guardar(hrsRemotas!)
                            if (result)
                            {
                                retorno(Response(estado: 1, mensaje: "Los horas fueron guardados correctamente", result: true))
                            }
                            else
                            {
                                retorno(Response(estado: 1, mensaje: "", result: true))
                            }
                        }
                        else
                        {
                            retorno(Response(estado: 1, mensaje: "", result: true))
                        }
                    })
                }
                else
                {
                    DataStore.horas.eliminarByIdAbogado((session.usuario?.id)!)
                    
                    ApiClient.instance.obtListDetalleHorasByCodAbogado(session, fDesde, fHasta
                        , callback:{(hrsRemotas)->Void in
                            if hrsRemotas != nil
                            {
                                let result : Bool = DataStore.horas.guardar(hrsRemotas!)
                                if (result)
                                {
                                    retorno(Response(estado: 1, mensaje: "Los horas fueron guardados correctamente", result: true))
                                }
                                else
                                {
                                    retorno(Response(estado: 1, mensaje: "Las horas no fueron guardadas correctamente desde el webservices", result: true))
                                }
                            }
                            else
                            {
                               retorno(Response(estado: 1, mensaje: "Las horas no fueron recuperadas desde el webservices", result: true))
                            }
                    })
                }
            }
        }
        
    }
    
    func obtSessionLocal(userName: String = "", password: String = "", imei: String = "", defecto: Int = -1) -> SessionLocal?
    {
        return DataStore.usuarios.obtSessionLocal(imei: imei, userName: userName, password: password)
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
    
    func getListDetalleHorasByIdAbogadoAndFecha(_ id: Int32, _ fecha: String) -> [RegistroHora]?
    {
        return DataStore.horas.getListDetalleHorasByIdAbogadoAndFecha(id, fecha)
    }
    
    func descargarImagenByIdUsuario(id: Int, callback: @escaping (String)-> Void)
    {
        if self.isConnected
        {
            ApiClient.instance.obtImagePerfilById(id: id, callback: {(string64) in
                callback(string64)
            })
        }
        else
        {
            callback("")
        }
    }
    
    func actualizarImagen(id: Int32, string64: String) -> Bool
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
