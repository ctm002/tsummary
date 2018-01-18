import SQLite3
import Foundation

enum Errores: Error {
    case ErrorDataBase
    case ErrorConexionDataBase
    case ErrorCreateTables
}

public class TbUsuario
{
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    static let instance = TbUsuario()
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
            try createTableIfNoExists()
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

        }
        catch{
            print("\(error)")
        }
        return nil
    }
    
    
    func dropTable()->Bool
    {
        do
        {
            try open()
            if sqlite3_exec(db, "drop table Usuario", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error dropping table: \(errmsg)")
                return false
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
        return true
    }
    
    func createTableIfNoExists() throws
    {
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
    }

    func guardar(usuario: Usuario) -> Bool
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
    
    func obtUsuarioByIMEI(imei:String) -> Usuario? {
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
}
