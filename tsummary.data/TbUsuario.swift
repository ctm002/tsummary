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
    
    func obtSessionLocal(imei:String = "", loginName:String = "", password: String = "") -> SessionLocal?
    {
        do
        {
            try open()
            
            var condicion : String = ""
            var statement: OpaquePointer?
            
            
            var consulta : String = """
                select Id, Nombre, Grupo, LoginName, IMEI, Perfil, Token, ExpiredAt, Password, IdUsuario
                from Usuario where 1=1
                """
            
            if (loginName != "")
            {
                condicion =  condicion + " and LoginName='" + loginName + "'"
            }
            
            if (password != "")
            {
                condicion =  condicion + " and Password='" + password + "'"
            }
            
            if (imei != "")
            {
                condicion =  condicion + " and IMEI='" + imei + "'"
            }
            
            consulta = consulta + condicion
            
            if sqlite3_prepare_v2(db, consulta, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            var sessionLocal: SessionLocal!
            if sqlite3_step(statement) == SQLITE_ROW
            {
                sessionLocal = self.getSessionLocalFromRecord(&statement)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return sessionLocal
        }
        catch
        {
            print("\(error)")
        }
        return nil
    }
    
    func existsSessionLocal(loginName:String) -> Bool
    {
        do
        {
            try open()
            
            var condicion : String = ""
            var statement: OpaquePointer?
            
            
            var consulta : String = """
                select Id
                from Usuario where 1=1
                """
            
            if (loginName != "")
            {
                condicion =  condicion + " and LoginName='" + loginName + "'"
            }
            
            consulta = consulta + condicion
            
            if sqlite3_prepare_v2(db, consulta, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            var exists: Bool = false
            if sqlite3_step(statement) == SQLITE_ROW
            {
                exists = true
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return exists
        }
        catch
        {
            print("\(error)")
        }
        return false
    }
    
    func getSessionLocalFromRecord(_ statement: inout OpaquePointer?)-> SessionLocal
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
            SessionLocal.shared.token = token
        }
        
        if let csString = sqlite3_column_text(statement,7)
        {
            let expiredAt : String = String(cString: csString)
            SessionLocal.shared.expiredAt = Utils.toDateFromString(expiredAt)
        }
        
        if let csString = sqlite3_column_text(statement,8)
        {
            let password : String = String(cString: csString)
            usuario.password = password
        }
        
        let idUsuario : Int32 = sqlite3_column_int(statement, 9)
        usuario.idUsuario = Int(idUsuario)
        
        SessionLocal.shared.usuario = usuario
        return SessionLocal.shared
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
                ExpiredAt text,
                IdUsuario integer,
                Image text,
                [Default] integer)
            """, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }

    func guardar(sessionLocal: SessionLocal) -> Bool
    {
        do
        {
            
            if let usuario = sessionLocal.usuario
            {
                try open()
                var statement: OpaquePointer?
                
                if sqlite3_prepare_v2(db, """
                insert into Usuario (Nombre, Grupo, Id, IMEI, LoginName, Password, Token, ExpiredAt, IdUsuario)
                values (?, ?, ?, ?, ?, ?, ?, ?, ?)
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
                
                if sqlite3_bind_text(statement, 7, sessionLocal.token, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding token: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 8, Utils.toStringFromDate(sessionLocal.expiredAt!), -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding expiredAt: \(errmsg)")
                }
                
                let idIsuario : Int = usuario.idUsuario
                if sqlite3_bind_int(statement, 9, Int32(idIsuario)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding idUsuario: \(errmsg)")
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
        }
        catch
        {
            print("Error:\(error)")
        }
        return false
    }
    
    func actualizar(sessionLocal: SessionLocal) -> Bool
    {
        do {
            try open()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, """
                    update usuario set Nombre=?, Grupo=?, IMEI=?, Token=?, ExpiredAt=?
                    where Id=?
                """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, sessionLocal.usuario?.nombre, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding nombre: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, sessionLocal.usuario?.grupo, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding grupo: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 3, sessionLocal.usuario?.imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding imei: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 4, sessionLocal.token, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding token: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 5, Utils.toStringFromDate(sessionLocal.expiredAt!), -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding expiredAt: \(errmsg)")
            }
            
            let id = sessionLocal.usuario?.id as! Int32
            if sqlite3_bind_int(statement, 6, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding id: \(errmsg)")
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

    func actualizar(id: Int32, data: String) -> Bool
    {
        do {
            try open()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, """
                    update usuario set Image=?
                    where Id=?
                """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
            }
            

            if sqlite3_bind_int(statement, 1, id) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding Id: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo al actualizar en la tabla usuario: \(errmsg)")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            close()
            return true
        }
        catch
        {
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

    func obtUsuarioById(id: Int) -> Usuario?
    {
        do
        {
            try open()
            
            var condicion : String = ""
            var statement: OpaquePointer?
            
            
            var consulta : String = """
                select Id, Nombre, Grupo, LoginName, IMEI, Perfil, IdUsuario, Image
                from Usuario where Id=\(id)
                """
            
            if sqlite3_prepare_v2(db, consulta, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            var usuario: Usuario!
            if sqlite3_step(statement) == SQLITE_ROW
            {
                usuario = Usuario()
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
                
                let idUsuario : Int32 = sqlite3_column_int(statement, 6)
                usuario.idUsuario = Int(idUsuario)
            
                if let csString = sqlite3_column_text(statement,7)
                {
                    let image : String = String(cString: csString)
                    usuario.data = image
                }
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

}
