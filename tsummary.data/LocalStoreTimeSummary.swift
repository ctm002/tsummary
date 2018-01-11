import SQLite3
import Foundation

enum Errores: Error {
    case ErrorDataBase
    case ErrorConexionDataBase
    case ErrorCreateTables
}

public class LocalStoreTimeSummary
{
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    static let instance = LocalStoreTimeSummary()
    var db: OpaquePointer?
    var fileURL: URL
    
    init() {
        do
        {
            fileURL = try! FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil, create: true).appendingPathComponent("tsummary.db")

            initialize()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    
    func initialize()
    {
        do
        {
            try open()
            try createTables()
            try deleteTables()
            close()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    func open() throws
    {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
           throw Errores.ErrorConexionDataBase
        }
    }
    
    func close()
    {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
    }
    
    func autentificar(imei:String, user:String, password: String) -> Usuario?
    {
        do
        {
            try open()
            var sql: String = "select * from Usuario where 1=1 "
            var statement: OpaquePointer?

        }catch{
        
        }
        return nil
    }
    
    func dropTables()->Bool
    {
        if sqlite3_exec(db, "drop table Cliente", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error dropping table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "drop table ClienteProyecto", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error dropping table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "drop table Usuario", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error dropping table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "drop table Horas", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error dropping table: \(errmsg)")
        }
        return true
    }
    
    func deleteTables() -> Bool
    {
        /*
        if sqlite3_exec(db, "delete from Cliente", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error deleting table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "delete from ClienteProyecto", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error deleting table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "delete from Usuario", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error deleting table: \(errmsg)")
        }
 
         if sqlite3_exec(db, "delete from Horas", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error deleting table: \(errmsg)")
        }
        */
        return true
    }
    
    func createTables() throws
    {
        if sqlite3_exec(db, """
                create table if not exists Cliente(
                cli_cod integer primary key,
                cli_nom text,
                pro_id int)
            """, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }

        if sqlite3_exec(db, """
                create table if not exists ClienteProyecto(
                pro_id integer primary key,
                cli_nom text,
                pro_nombre text,
                pro_idioma text)
            """, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, """
                create table if not exists Usuario(
                Id integer primary key,
                Nombre text, Grupo text,
                LoginName text,
                Password text,
                IMEI text,
                [Default] integer)
            """, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }

        if sqlite3_exec(db, """
                    create table if not exists Horas(
                    hora_id integer primary key,
                    tim_correl integer,
                    pro_id integer, tim_asunto text,
                    tim_horas text,
                    tim_minutos text,
                    abo_id integer,
                    Modificable integer,
                    OffLine integer,
                    tim_fecha_ing datetime,
                    estado  integer)
            """, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }

    func save(_ proyecto: ClienteProyecto) -> Bool
    {
        var statement: OpaquePointer?
            
        if sqlite3_prepare_v2(db, """
        insert into ClienteProyecto(pro_id, pro_nombre, cli_nom, pro_idioma)
        values (?, ?, ?, ?)
        """
            , -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
    
        if sqlite3_bind_int(statement, 1, Int32(proyecto.pro_id)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding pro_id: \(errmsg)")
        }
    
        if sqlite3_bind_text(statement, 2, proyecto.pro_nombre, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding cli_nom: \(errmsg)")
        }
    
        if sqlite3_bind_text(statement, 3, proyecto.cli_nom, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding pro_nombre: \(errmsg)")
        }
    
        if sqlite3_bind_text(statement, 4, proyecto.pro_idioma, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding pro_idioma: \(errmsg)")
        }
    
        if sqlite3_step(statement) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fallo al insertar en la tabla clienteproyecto: \(errmsg)")
        }
    
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        return true
    }
    
    func save(usuario: Usuario) -> Bool
    {
        do {
            try open()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, """
                insert into Usuario (Nombre, Grupo, Id, IMEI, LoginName, Password)
                values (?, ?, ?, ?, ?, ?)
                """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            
            let nombre: String? = usuario.Nombre
            if sqlite3_bind_text(statement, 1, nombre, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding nombre: \(errmsg)")
            }
            
            let grupo : String? = usuario.Grupo
            if sqlite3_bind_text(statement, 2, grupo , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding grupo: \(errmsg)")
            }
            
            let id : Int32 = Int32(usuario.Id)
            if sqlite3_bind_int(statement, 3,  id) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding id: \(errmsg)")
            }
            
            let imei : String? = usuario.IMEI
            if sqlite3_bind_text(statement, 4, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            if sqlite3_bind_null(statement, 5) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding username: \(errmsg)")
            }
            
            if sqlite3_bind_null(statement, 6) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding password: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo al insertar en la tabla usuario: \(errmsg)")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            close()
            return true
        }
        catch {
            print("Error:\(error)")
        }
        return false
    }
    
    func getUsuarioByIMEI(imei:String) -> Usuario? {
        var usuario: Usuario?
        do
        {
            try open()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db,"""
                select Id, Nombre, Grupo, IMEI from Usuario where IMEI=?
                """, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                usuario = Usuario()
                
                let id : Int32 = sqlite3_column_int(statement, 0)
                usuario?.Id  = id
                
                if let csString = sqlite3_column_text(statement,1)
                {
                   let nombre : String = String(cString: csString)
                    usuario?.Nombre = nombre
                }
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let grupo : String = String(cString: csString)
                    usuario?.Grupo = grupo
                }
                
                if let csString = sqlite3_column_text(statement,3)
                {
                    let imei : String = String(cString: csString)
                    usuario?.IMEI = imei
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo al consultar en la tabla usuario: \(errmsg)")
                usuario = nil
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            close()
        }
        catch{
            print("Error: \(error)")
        }
        return usuario
    }
    
    func update(horas: [Horas]) -> Bool
    {
        var statement: OpaquePointer?
        
        for hora in horas {
            
            let sql = """
                update
                    Horas
                set
                    pro_id=?,
                    tim_asunto=?,
                    tim_horas=?,
                    tim_minutos=?,
                    abo_id=?,
                    Modificable=?,
                    OffLine=?,
                    tim_fecha_ing=?,
                    estado=?
                where
                    tim_correl=?
                """
            
            if sqlite3_prepare_v2(db, sql , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
            }
            
            let prodId : Int32 = Int32(hora.proyecto.pro_id)
            if sqlite3_bind_int(statement, 1,  prodId) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding pro_id: \(errmsg)")
            }
            
            let asunto : String? = hora.tim_asunto
            if sqlite3_bind_text(statement, 2, asunto , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding tim_asunto: \(errmsg)")
            }
            
            let horas : Int32 = Int32(hora.tim_horas)
            if sqlite3_bind_int(statement, 3, horas) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding tim_horas: \(errmsg)")
            }
            
            let minutos : Int32 = Int32(hora.tim_minutos)
            if sqlite3_bind_int(statement, 4, minutos) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding tim_minutos: \(errmsg)")
            }
            
            let aboId : Int32 = Int32(hora.abo_id)
            if sqlite3_bind_int(statement, 5,  aboId) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            let modificable : Int32 = hora.Modificable ? 1 : 0
            if sqlite3_bind_int(statement, 6, modificable) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding modificable: \(errmsg)")
            }
            
            let offline : Int32 = hora.OffLine ? 1 : 0
            if sqlite3_bind_int(statement, 7, offline) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding offline: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 8, hora.tim_fecha_ing, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding fecha_insert: \(errmsg)")
            }
           
            let estado: Int32 = Int32(hora.Estado.rawValue)
            if sqlite3_bind_int(statement, 9, estado) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding estado: \(errmsg)")
            }
            
            let correlativo: Int32 = hora.tim_correl
            if sqlite3_bind_int(statement, 9, correlativo) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding tim_correl: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo al insertar en la tabla horas: \(errmsg)")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
        }
        return true
    }
    
    func getListDetalleHorasByCodAbogadoOffline(codigo: String) -> [Horas]?
    {
        let query : String = """
            select
                h.tim_correl,
                h.pro_id,
                h.tim_asunto,
                h.tim_horas,
                h.tim_minutos,
                h.abo_id,
                h.Modificable,
                h.OffLine,
                h.tim_fecha_ing,
                p.pro_nombre,
                p.cli_nom,
                h.hora_id
            from
                Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
            where
                h.abo_id=? AND OffLine = 0 AND estado=1
        """
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing get list horas: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 1, Int32(codigo)!) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding abo_id: \(errmsg)")
        }
        
        var horas = [Horas]()
        while sqlite3_step(statement) == SQLITE_ROW {
            let hora = getHoraFromRecord(&statement)
            horas.append(hora)
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        return horas
    }
    
    private func getHoraFromRecord(_ record: inout OpaquePointer?) -> Horas {
        let hora = Horas()
        
        let tim_correl : Int32 = sqlite3_column_int(record, 0)
        hora.tim_correl = tim_correl
        
        let prodId : Int32 = sqlite3_column_int(record, 1)
        hora.proyecto.pro_id = prodId
        
        if let csString = sqlite3_column_text(record,2)
        {
            let asunto : String = String(cString: csString)
            hora.tim_asunto = asunto
        }
        
        let cantHoras : Int32 = sqlite3_column_int(record,3)
        hora.tim_horas = Int(cantHoras)
        
        let minutos : Int32 = sqlite3_column_int(record,4)
        hora.tim_minutos = Int(minutos)
        
        let aboId : Int32 = sqlite3_column_int(record, 5)
        hora.abo_id = Int(aboId)
        
        let modificable : Int32 = sqlite3_column_int(record, 6)
        hora.Modificable = modificable == 1 ? true: false
        
        let offline : Int32 = sqlite3_column_int(record, 7)
        hora.OffLine = offline == 1 ? true: false
        
        if let csString = sqlite3_column_text(record, 8)
        {
            hora.tim_fecha_ing = String(cString: csString)
        }
        
        if let csString = sqlite3_column_text(record, 9)
        {
            hora.proyecto.pro_nombre = String(cString: csString)
        }
        
        if let csString = sqlite3_column_text(record, 10)
        {
            hora.proyecto.cli_nom = String(cString: csString)
        }
        
        let id : Int32 = sqlite3_column_int(record, 11)
        hora.IdHora = id
        
        return hora
    }
}
