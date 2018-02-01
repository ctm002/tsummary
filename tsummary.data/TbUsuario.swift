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
            let sql : String = """
                select Id, Nombre, Grupo, LoginName, IMEI, Perfil, Token
                from Usuario where 1=1
                    and LoginName=? and Password=? and IMEI=?
                """
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, user, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding user: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, password, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding password: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 3, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            var usuario: Usuario!
            if sqlite3_step(statement) == SQLITE_ROW
            {
                usuario = getUsuarioFromRecord(&statement)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return usuario
        }
        catch
        {
            print("\(error)")
        }
        return nil
    }
    
    func validar(_ imei: String) -> Usuario?
    {
        do
        {
            try open()
            let sql : String = """
                select Id, Nombre, Grupo, LoginName, IMEI, Perfil, Token
                from Usuario where 1=1 and IMEI=?
                """
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            var usuario: Usuario!
            if sqlite3_step(statement) == SQLITE_ROW
            {
                usuario = getUsuarioFromRecord(&statement)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return usuario
        }
        catch
        {
            print("\(error)")
        }
        return nil
    }
    
    func getUsuarioFromRecord(_ statement: inout OpaquePointer?)->Usuario
    {
        let usuario = Usuario()
        let id : Int32 = sqlite3_column_int(statement, 0)
        usuario.id  = id
        
        if let csString = sqlite3_column_text(statement,1)
        {
            let nombre : String = String(cString: csString)
            usuario.nombre = nombre
        }
        
        if let csString = sqlite3_column_text(statement,2)
        {
            let grupo : String = String(cString: csString)
            usuario.grupo = grupo
        }
        
        if let csString = sqlite3_column_text(statement,3)
        {
            let loginName : String = String(cString: csString)
            usuario.loginName = loginName
        }
        
        if let csString = sqlite3_column_text(statement,4)
        {
            let imei : String = String(cString: csString)
            usuario.imei = imei
        }
        
        if let csString = sqlite3_column_text(statement,5)
        {
            let perfil : String = String(cString: csString)
            usuario.perfil = perfil
        }
        
        if let csString = sqlite3_column_text(statement,6)
        {
            let token : String = String(cString: csString)
            usuario.token = token
        }
        
        
        return usuario
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
                Perfil text,
                Token text,
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
                insert into Usuario (Nombre, Grupo, Id, IMEI, LoginName, Password, Token)
                values (?, ?, ?, ?, ?, ?)
                """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, usuario.nombre, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding nombre: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, usuario.grupo, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding grupo: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 3, Int32(usuario.id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding id: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 4, usuario.imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 5, usuario.loginName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding username: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 6, usuario.password, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding password: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 7, usuario.token, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding token: \(errmsg)")
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
    
    func eliminar()
    {
        do
        {
            try open()
            if sqlite3_exec(db, "delete from Usuario", nil, nil, nil) != SQLITE_OK
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
}
