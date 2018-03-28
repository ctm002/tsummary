
import Foundation
import SQLite3

public class TbHora
{
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var db: OpaquePointer?
    var fileURL: URL
    
    static let instance = TbHora()
    
    init()
    {
        fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: true).appendingPathComponent("tsummary.db")
        
        createTableIfNotExists()
    }
    
    private func createTableIfNotExists()
    {
        do
        {
            try open()
            let sql = """
                create table if not exists Horas(
                    hora_id integer primary key,
                    tim_correl integer,
                    pro_id integer,
                    tim_asunto text,
                    tim_horas text,
                    tim_minutos text,
                    abo_id integer,
                    modificable integer,
                    offline integer,
                    tim_fecha_ing datetime,
                    estado integer,
                    fecha_ult_mod datetime,
                    fecha_hora_inicio datetime)
            """
            if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    private func open() throws
    {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            throw  Errores.ErrorConexionDataBase
        }
    }
    
    private func close()
    {
        if sqlite3_close(db) != SQLITE_OK
        {
            print("error closing database")
        }
        db = nil
    }
    
    public func dropTable()
    {
        do
        {
            try open()
            let sql = "drop table Horas"
            if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    func eliminar(_ horas: [RegistroHora]) -> Bool
    {
        do
        {
            try open()
            for hora in horas
            {
                var statement: OpaquePointer?
                
                let sql = """
                    update Horas set offline=1, estado=? where hora_id=?
                """
                
                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing update: \(errmsg)")
                }
                
                if sqlite3_bind_int(statement, 1, Int32(hora.estado.rawValue)) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding estado: \(errmsg)")
                }
                
                if sqlite3_bind_int(statement, 2, hora.id) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding hora_id: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo preparing update: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
            }
            close()
            return true
        }
        catch
        {
            close()
            print("Error: delete")
        }
        return false
    }
    
    func guardar(_ horas:[RegistroHora]) -> Bool
    {
        do
        {
            try open()
            for hora in horas
            {
                var statement: OpaquePointer?
                let sql = """
                insert into Horas(
                        tim_correl,
                        pro_id,
                        tim_asunto,
                        tim_horas,
                        tim_minutos,
                        abo_id,
                        modificable,
                        offline,
                        tim_fecha_ing,
                        estado,
                        fecha_ult_mod,
                        fecha_hora_inicio)
                    values (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?)
                """
                
                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                }
                
                let correlativo: Int32 = hora.tim_correl
                if sqlite3_bind_int(statement, 1, correlativo) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.proyecto.id)
                if sqlite3_bind_int(statement, 2, prodId) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 3, hora.asunto, -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int = hora.horasTrabajadas
                if sqlite3_bind_int(statement, 4, Int32(horas)) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int = hora.minutosTrabajados
                if sqlite3_bind_int(statement, 5, Int32(minutos))  != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int32 = hora.abogadoId
                if sqlite3_bind_int(statement, 6, Int32(aboId)) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.modificable ? 1 : 0
                if sqlite3_bind_int(statement, 7, modificable) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.offline ? 1 : 0
                if sqlite3_bind_int(statement, 8, offline) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 9, Utils.toStringFromDate(hora.fechaInsert!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
                
                let estado : Int32 = Int32(hora.estado.rawValue)
                if sqlite3_bind_int(statement, 10, estado) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 11, Utils.toStringFromDate(hora.fechaUpdate!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_update: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 12, Utils.toStringFromDate(hora.fechaHoraInicio!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_hora_inicio: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo al insertar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
                
            }
            close()
            return true
        }
        catch
        {
            close()
            print("Error: delete")
        }
        return false
    }
    
    public func guardar(_ hora: RegistroHora)-> Bool
    {
        var resp: Bool = false
        do
        {
            try open()
            if hora.id == 0
            {
                var statement: OpaquePointer?
                let sql = """
                insert into Horas(
                        tim_correl,
                        pro_id,
                        tim_asunto,
                        tim_horas,
                        tim_minutos,
                        abo_id,
                        modificable,
                        offline,
                        tim_fecha_ing,
                        estado,
                        fecha_hora_inicio)
                    values (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?)
                """
                
                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                }
                
                let correlativo: Int32 = hora.tim_correl
                if sqlite3_bind_int(statement, 1, correlativo) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.proyecto.id)
                if sqlite3_bind_int(statement, 2,  prodId) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 3, hora.asunto, -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int = hora.horasTrabajadas
                if sqlite3_bind_int(statement, 4, Int32(horas)) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int = hora.minutosTrabajados
                if sqlite3_bind_int(statement, 5, Int32(minutos))  != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int32 = hora.abogadoId
                if sqlite3_bind_int(statement, 6,  Int32(aboId)) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.modificable ? 1 : 0
                if sqlite3_bind_int(statement, 7, modificable) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.offline ? 1 : 0
                if sqlite3_bind_int(statement, 8, offline) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 9, Utils.toStringFromDate(hora.fechaInsert!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
                
                let estado : Int32 = Int32(hora.estado.rawValue)
                if sqlite3_bind_int(statement, 10, estado) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 11, Utils.toStringFromDate(hora.fechaHoraInicio!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_hora_inicio: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo al insertar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
                resp = true
            }
            else
            {
                var statement: OpaquePointer?
                let sql = """
                update
                    Horas
                set
                    pro_id=?,
                    tim_asunto=?,
                    tim_horas=?,
                    tim_minutos=?,
                    abo_id=?,
                    modificable=?,
                    offline=?,
                    fecha_hora_inicio=?,
                    estado=?,
                    fecha_ult_mod=?
                where
                    hora_id=?
                """
                
                if sqlite3_prepare_v2(db, sql , -1, &statement, nil) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing update: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.proyecto.id)
                if sqlite3_bind_int(statement, 1,  prodId) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                let asunto : String? = hora.asunto
                if sqlite3_bind_text(statement, 2, asunto , -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int32 = Int32(hora.horasTrabajadas)
                if sqlite3_bind_int(statement, 3, horas) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int32 = Int32(hora.minutosTrabajados)
                if sqlite3_bind_int(statement, 4, minutos) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int32 = Int32(hora.abogadoId)
                if sqlite3_bind_int(statement, 5,  aboId) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.modificable ? 1 : 0
                if sqlite3_bind_int(statement, 6, modificable) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.offline ? 1 : 0
                if sqlite3_bind_int(statement, 7, offline) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 8, Utils.toStringFromDate(hora.fechaHoraInicio!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_hora_inicio: \(errmsg)")
                }
                
                let estado: Int32 = Int32(hora.estado.rawValue)
                if sqlite3_bind_int(statement, 9, estado) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding estado: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 10, Utils.toStringFromDate(hora.fechaUpdate!), -1, SQLITE_TRANSIENT) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_update: \(errmsg)")
                }
                
                let id: Int32 = hora.id
                if sqlite3_bind_int(statement, 11, id) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding hora_id: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo al actualizar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK
                {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
                resp = true
            }
            close()
        }
        catch
        {
            print("Error: save")
            close()
        }
        return resp
    }
    
    public func getById(_ id: Int32) -> RegistroHora?
    {
        var hora: RegistroHora!
        do
        {
            let query : String = """
            select
                h.tim_correl,
                h.pro_id,
                h.tim_asunto,
                h.tim_horas,
                h.tim_minutos,
                h.abo_id,
                h.modificable,
                h.offline,
                h.tim_fecha_ing,
                p.pro_nombre,
                p.cli_nom,
                h.hora_id,
                h.fecha_ult_mod,
                h.estado,
                h.fecha_hora_inicio
            from
                Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
            where
                 h.hora_id=?
            order by h.tim_fecha_ing asc
            """
            
            try open()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(id)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW
            {
                hora = getHoraFromRecord(&statement)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            close()
            return hora
        }
        catch
        {
            close()
        }
        return nil
    }
    
    public func eliminar(_ hora:RegistroHora) -> Bool
    {
        var result = true
        do
        {
            try self.open()
            
            var statement: OpaquePointer?
            
            let sql = """
                update Horas set offline=1, estado=? where hora_id=?
            """
            
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
                result = false
            }
            
            if sqlite3_bind_int(statement, 1, Int32(hora.estado.rawValue)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding estado: \(errmsg)")
                result = false
            }
            
            if sqlite3_bind_int(statement, 2, hora.id) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding hora_id: \(errmsg)")
                result = false
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo preparing update: \(errmsg)")
                result = false
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
                result = false
            }
        }
        catch
        {
            print("Error: delete")
            result = false
        }
        self.close()
        return result
    }
    
    private func getHoraFromRecord(_ record: inout OpaquePointer?) -> RegistroHora
    {
        let hora = RegistroHora()
        let tim_correl : Int32 = sqlite3_column_int(record, 0)
        hora.tim_correl = tim_correl
        
        let prodId : Int32 = sqlite3_column_int(record, 1)
        hora.proyecto.id = prodId
        
        if let csString = sqlite3_column_text(record,2)
        {
            let asunto : String = String(cString: csString)
            hora.asunto = asunto
        }
        
        let cantHoras : Int32 = sqlite3_column_int(record,3)
        hora.horasTrabajadas = Int(cantHoras)
        
        let minutos : Int32 = sqlite3_column_int(record,4)
        hora.minutosTrabajados = Int(minutos)
        
        let aboId : Int32 = sqlite3_column_int(record, 5)
        hora.abogadoId = aboId
        
        let modificable : Int32 = sqlite3_column_int(record, 6)
        hora.modificable = modificable == 1 ? true: false
        
        let offline : Int32 = sqlite3_column_int(record, 7)
        hora.offline = offline == 1 ? true: false
        
        if let csString = sqlite3_column_text(record, 8)
        {
            if let h = Utils.toDateFromString(String(cString: csString))
            {
                hora.fechaInsert = h
            }
        }
        
        if let csString = sqlite3_column_text(record, 9)
        {
            hora.proyecto.nombre = String(cString: csString)
        }
        
        if let csString = sqlite3_column_text(record, 10)
        {
            hora.proyecto.nombreCliente = String(cString: csString)
        }
        
        let id : Int32 = sqlite3_column_int(record, 11)
        hora.id = id
        
        if let csString = sqlite3_column_text(record, 12)
        {
            if let h = Utils.toDateFromString(String(cString: csString))
            {
                hora.fechaUpdate = h
            }
        }
        
        let estado : Int32 = sqlite3_column_int(record, 13)
        hora.estado = Estado(rawValue: Int(estado))!
        
        if let csString = sqlite3_column_text(record, 14)
        {
            if let h = Utils.toDateFromString(String(cString: csString))
            {
                hora.fechaHoraInicio = h
            }
        }
        
        return hora
    }
    
    public func getListDetalleHorasByIdAbogadoAndFecha(_ id: Int32, _ fecha: String) -> [RegistroHora]?
    {
        let query : String = """
            select
                h.tim_correl,
                h.pro_id,
                h.tim_asunto,
                h.tim_horas,
                h.tim_minutos,
                h.abo_id,
                h.modificable,
                h.offline,
                h.tim_fecha_ing,
                p.pro_nombre,
                p.cli_nom,
                h.hora_id,
                h.fecha_ult_mod,
                h.estado,
                h.fecha_hora_inicio
            from
                Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
            where
                h.estado!=2
                AND h.abo_id=?
                AND strftime('%Y-%m-%d',h.fecha_hora_inicio)=?
            order by h.fecha_hora_inicio asc
        """
        do
        {
            try open()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, id) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, fecha, -1, SQLITE_TRANSIENT) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding fecha: \(errmsg)")
            }
            
            var horas = [RegistroHora]()
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let hora = getHoraFromRecord(&statement)
                horas.append(hora)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return horas
        }
        catch
        {
            close()
            print("Error: getListDetalleHorasByCodAbogadoAndFecha")
        }
        return nil
    }
    
    public func getListDetalleHorasByIdAbogadoAndEstadoOffline(id: Int32) -> [RegistroHora]?
    {
        let query : String = """
            select
                h.tim_correl,
                h.pro_id,
                h.tim_asunto,
                h.tim_horas,
                h.tim_minutos,
                h.abo_id,
                h.modificable,
                h.offline,
                h.tim_fecha_ing,
                p.pro_nombre,
                p.cli_nom,
                h.hora_id,
                h.fecha_ult_mod,
                h.estado
            from
                Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
            where
                h.offline = 1 and h.abo_id=?
        """
        do
        {
            try open()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, id) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            var horas = [RegistroHora]()
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let hora = getHoraFromRecord(&statement)
                horas.append(hora)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return horas
        }
        catch
        {
            close()
            print("Error: getListDetalleHorasByCodAbogadoAndFecha")
        }
        return nil
    }
    
    func eliminarByIdAbogado(_ id: Int32)
    {
        do
        {
            try open()
            if sqlite3_exec(db, "delete from Horas where abo_id=\(id)", nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error deleting table: \(errmsg)")
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
    }

    func eliminar()
    {
        do
        {
            try open()
            if sqlite3_exec(db, "delete from Horas", nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error deleting table: \(errmsg)")
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    func eliminar(codigo: String, fechaDesde: String, fechaHasta: String) -> Bool
    {
        do
        {
            try open()
            var query : String = "delete Horas where abo_id=" +  codigo
            query = query + " and (strftime('%Y-%m-%d',h.tim_fecha_ing)>=" + fechaDesde
            query = query + " and strftime('%Y-%m-%d',h.tim_fecha_ing)<=" + fechaHasta + ")"
            if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error deleting table: \(errmsg)")
            }
            close()
            return true
        }
        catch
        {
            print("\(error)")
        }
        return false
    }
}
