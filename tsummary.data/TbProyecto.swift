import Foundation
import SQLite3

public class TbProyecto
{
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var db: OpaquePointer?
    var fileURL: URL
    
    static let instance = TbProyecto()
    
    init()
    {
        fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: true).appendingPathComponent("tsummary.db")
        
        createTableIfNotExists()
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
    
    public func dropTable() -> Bool
    {
        do
        {
            try open()
            let sql = "drop table ClienteProyecto"
            if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
                return false
            }
            close()
        }
        catch
        {
            print("\(error)")
        }
        return false
    }
    
    public func createTableIfNotExists() -> Bool
    {
        do
        {
            try open()
            let sql = """
                create table if not exists ClienteProyecto(
                pro_id integer primary key,
                cli_nom text,
                pro_nombre text,
                pro_idioma text)
            """
            if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
                return false
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
    
    public func guardar(_ proyectos: [ClienteProyecto])-> Bool
    {
        do
        {
            try open()
            for proyecto in proyectos
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
            }
            close()
            return true
        }
        catch{
            close()
            print("Error: save")
        }
        return false
    }
    
    public func guardar(_ proyecto: ClienteProyecto)-> Bool
    {
        do
        {
            try open()

            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db,
            """
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

            close()
            return true
        }
        catch{
            close()
            print("Error: save")
        }
        return false
    }
    
    
    public func obtById(_ id: Int32) -> ClienteProyecto?
    {
        do
        {
            try open()
            let query : String = """
                select
                    p.pro_id, p.pro_nombre, p.cli_nom
                from
                    ClienteProyecto p
                where p.pro_id=?
                order by p.cli_nom asc
            """
            
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list proyectos: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding pro_id: \(errmsg)")
            }
            
            var proyecto : ClienteProyecto!
            
            if sqlite3_step(statement) == SQLITE_ROW{
                
                proyecto = ClienteProyecto()
                
                let idProyecto : Int32 = sqlite3_column_int(statement, 0)
                proyecto.pro_id = idProyecto
                
                if let csString = sqlite3_column_text(statement,1)
                {
                    let nombreProyecto : String = String(cString: csString)
                    proyecto.pro_nombre = nombreProyecto
                }
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let nombreCliente : String = String(cString: csString)
                    proyecto.cli_nom = nombreCliente
                }
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            close()
            return proyecto
        }
        catch
        {
            close()
            print("Error: save")
        }
        return nil
    }
    
    func obtListProyectos() -> [ClienteProyecto]?
    {
        
        do
        {
            try open()
            
            let query : String = """
                select
                    p.pro_id, p.pro_nombre, p.cli_nom
                from
                    ClienteProyecto p
                order by p.cli_nom asc
            """
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list proyectos: \(errmsg)")
            }
            
            var proyectos = [ClienteProyecto]()
            while sqlite3_step(statement) == SQLITE_ROW {
                let proyecto = ClienteProyecto()
                
                let idProyecto : Int32 = sqlite3_column_int(statement, 0)
                proyecto.pro_id = idProyecto
                
                if let csString = sqlite3_column_text(statement,1)
                {
                    let nombreProyecto : String = String(cString: csString)
                    proyecto.pro_nombre = nombreProyecto
                }
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let nombreCliente : String = String(cString: csString)
                    proyecto.cli_nom = nombreCliente
                }
                proyectos.append(proyecto)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return proyectos
        }
        catch
        {
            close()
        }
        return nil
    }
    
    func eliminar()
    {
        do
        {
            try open()
            if sqlite3_exec(db, "delete from ClienteProyecto", nil, nil, nil) != SQLITE_OK
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
