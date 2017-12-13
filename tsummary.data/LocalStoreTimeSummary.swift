//
//  LocalStoreTimeSummary.swift
//  tsummary
//
//  Created by Soporte on 04-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import SQLite3
import Foundation

enum Errores: Error {
    case ErrorDataBase
    case ErrorConexionDataBase
    case ErrorCreateTables
}

class LocalStoreTimeSummary
{
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    static let Instance = LocalStoreTimeSummary()
    var dataBase: OpaquePointer?
    var fileURL: URL
    
    init() {
        do
        {
            fileURL = try! FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil, create: true).appendingPathComponent("tsummary.db")
            
            
            try openDB()
            try createTables()
            //deleteTables()
            closeDB()
        }
        catch
        {
            print("\(error)")
        }
    }
    
    func openDB() throws
    {
        if sqlite3_open(fileURL.path, &dataBase) != SQLITE_OK {
            throw  Errores.ErrorConexionDataBase
        }
    }
    
    func closeDB()
    {
        if sqlite3_close(dataBase) != SQLITE_OK {
            print("error closing database")
        }
        dataBase = nil
    }
    
    func autentificar(imei:String, user:String, password: String) -> Usuario?
    {
        do
        {
            try openDB()
            var sql: String = "select * from Usuario where 1=1 "
            var statement: OpaquePointer?

        }catch{
        
        }
        return nil
    }
    
    func deleteTables() -> Bool
    {
        do
        {
            try openDB()

            if sqlite3_exec(dataBase, "delete from Cliente", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error deleting table: \(errmsg)")
            }
            
            if sqlite3_exec(dataBase, "delete from ClienteProyecto", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error deleting table: \(errmsg)")
            }
            
            if sqlite3_exec(dataBase, "delete from Usuario", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error deleting table: \(errmsg)")
            }
            
            if sqlite3_exec(dataBase, "delete from Horas", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error deleting table: \(errmsg)")
            }
            
            closeDB()
            return true
        }
        catch{
            print("Error \(error)")
        }
        return false
    }
    
    func createTables() throws
    {
        do
        {
            try openDB()
            var statement: OpaquePointer?
            
            if sqlite3_exec(dataBase, "create table if not exists Cliente(cli_cod integer primary key, cli_nom text, pro_id int)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error creating table: \(errmsg)")
            }

            if sqlite3_exec(dataBase, "create table if not exists ClienteProyecto(pro_id integer primary key, cli_nom text, pro_nombre text, pro_idioma text)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error creating table: \(errmsg)")
            }
            
            if sqlite3_exec(dataBase, "create table if not exists Usuario(Id integer primary key, Nombre text, Grupo text, LoginName text, Password text, IMEI text, [Default] integer)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error creating table: \(errmsg)")
            }

            if sqlite3_exec(dataBase, "create table if not exists Horas(tim_correl integer primary key, pro_id integer, tim_asunto text, tim_horas text, tim_minutos text, abo_id integer, Modificable integer, OffLine integer, tim_fecha_ing datetime)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error creating table: \(errmsg)")
            }
            closeDB()
        }
        catch{
            throw Errores.ErrorCreateTables
        }
    }

    
    /*
     public bool SaveProyectos(IEnumerable<ClienteProyecto> clientes)
{
    try
{
    var db = _DBLocal;
    db.InsertAll(clientes);
    return true;
    }
    catch (Exception ex)
    {
    throw ex;
    }
    return false;
    }
    
    public bool SaveHoras(IEnumerable<Horas> horas)
{
    try
{
    var db = _DBLocal;
    foreach (var data in horas)
    {
    int returnValue = db.Insert(data);
    }
    return true;
    }
    catch (Exception ex)
    {
    throw ex;
    }
    return false;
    }
    */
    
    func save(usuario: Usuario) -> Bool
    {
        do {
            try openDB()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(dataBase, """
                insert into Usuario (Nombre, Grupo, Id, IMEI, LoginName, Password)
                values (?, ?, ?, ?, ?, ?)
                """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing insert: \(errmsg)")
            }
            
            let nombre: String? = usuario.Nombre
            if sqlite3_bind_text(statement, 1, nombre, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding nombre: \(errmsg)")
            }
            
            let grupo : String? = usuario.Grupo
            if sqlite3_bind_text(statement, 2, grupo , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding grupo: \(errmsg)")
            }
            
            let id : Int32 = Int32(usuario.Id)
            if sqlite3_bind_int(statement, 3,  id) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding id: \(errmsg)")
            }
            
            let imei : String? = usuario.IMEI
            if sqlite3_bind_text(statement, 4, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding imei: \(errmsg)")
            }
            
            if sqlite3_bind_null(statement, 5) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding username: \(errmsg)")
            }
            
            if sqlite3_bind_null(statement, 6) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding password: \(errmsg)")
            }
            
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo al insertar en la tabla cliente: \(errmsg)")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            closeDB()
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
            try openDB()
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(dataBase,"""
                select Id, Nombre, Grupo, IMEI from Usuario where IMEI=?
                """, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing select: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, imei, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
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
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo al consultar en la tabla usuario: \(errmsg)")
                usuario = nil
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            closeDB()
        }
        catch{
            print("Error: \(error)")
        }
        return usuario
    }
 
    func save(hora: Horas) -> Bool
    {
        do
        {
            try openDB()
            var statement: OpaquePointer?
           
            if sqlite3_prepare_v2(dataBase,
                """
                    insert into Horas(tim_correl, pro_id, tim_asunto, tim_horas, tim_minutos, abo_id, Modificable, OffLine, tim_fecha_ing)
                    values (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing insert: \(errmsg)")
            }
    
            let correlativo: Int32 = hora.tim_correl
            if sqlite3_bind_int(statement, 1, correlativo) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding tim_correl: \(errmsg)")
            }
    
            let prodId : Int32 = Int32(hora.pro_id)
            if sqlite3_bind_int(statement, 2,  prodId) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding pro_id: \(errmsg)")
            }
            
            let horas : Int32 = hora.tim_horas
            if sqlite3_bind_int(statement, 3, horas) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding tim_horas: \(errmsg)")
            }
    
            let minutos : Int32 = hora.tim_minutos
            if sqlite3_bind_int(statement, 4, minutos) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding tim_minutos: \(errmsg)")
            }
            
            let aboId : Int32 = Int32(hora.abo_id)
            if sqlite3_bind_int(statement, 5,  aboId) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            let modificable : Int32 = hora.Modificable ? 1 : 0
            if sqlite3_bind_int(statement, 6, modificable) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding modificable: \(errmsg)")
            }
            
            let offline : Int32 = hora.OffLine ? 1 : 0
            if sqlite3_bind_int(statement, 7, offline) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding offline: \(errmsg)")
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let fechaInsert : String = formatter.string(from:hora.tim_fecha_ing!)
            if sqlite3_bind_text(statement, 8, fechaInsert, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding fecha_insert: \(errmsg)")
            }
    
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo al insertar en la tabla horas: \(errmsg)")
            }
    
            if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
    
            statement = nil
            closeDB()
            return true
        }
        catch { }
        return false;
    }
    
    func save(horas: [Horas]) -> Bool
    {
        do
        {
            try openDB()
            var statement: OpaquePointer?

            
            for hora in horas {
                
                if sqlite3_prepare_v2(dataBase,"""
                    insert into Horas(tim_correl, pro_id, tim_asunto, tim_horas, tim_minutos, abo_id, Modificable, OffLine, tim_fecha_ing)
                    values (?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """
                    , -1, &statement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("error preparing update: \(errmsg)")
                }
                
                let timCorrelativo : Int32 = Int32(hora.tim_correl)
                if sqlite3_bind_int(statement, 1,  timCorrelativo) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.pro_id)
                if sqlite3_bind_int(statement, 2,  prodId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                let asunto : String? = hora.tim_asunto
                if sqlite3_bind_text(statement, 3, asunto , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int32 = hora.tim_horas
                if sqlite3_bind_int(statement, 4, horas) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int32 = hora.tim_minutos
                if sqlite3_bind_int(statement, 5, minutos) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int32 = Int32(hora.abo_id)
                if sqlite3_bind_int(statement, 6,  aboId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.Modificable ? 1 : 0
                if sqlite3_bind_int(statement, 7, modificable) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.OffLine ? 1 : 0
                if sqlite3_bind_int(statement, 8, offline) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let fechaInsert : String = formatter.string(from:hora.tim_fecha_ing!)
                if sqlite3_bind_text(statement, 9, fechaInsert, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
              
                if sqlite3_step(statement) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("fallo al insertar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
            }
            closeDB()
        }
        catch{
            print("Error:\(error)")
        }
        return true
    }
    
    func delete(horas: [Horas]) -> Bool
    {
        return false
    }

    func update(horas: [Horas]) -> Bool
    {
        do
        {
            try openDB()
            var statement: OpaquePointer?
            
            for hora in horas {
                
                if sqlite3_prepare_v2(dataBase, """
                    update Horas set pro_id=?, tim_asunto=?, tim_horas=?, tim_minutos=?, abo_id=?, Modificable=?, OffLine=?, tim_fecha_ing=?
                    where tim_correl=?
                    """
                    , -1, &statement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("error preparing update: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.pro_id)
                if sqlite3_bind_int(statement, 1,  prodId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                let asunto : String? = hora.tim_asunto
                if sqlite3_bind_text(statement, 2, asunto , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int32 = hora.tim_horas
                if sqlite3_bind_int(statement, 3, horas) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int32 = hora.tim_minutos
                if sqlite3_bind_int(statement, 4, minutos) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int32 = Int32(hora.abo_id)
                if sqlite3_bind_int(statement, 5,  aboId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.Modificable ? 1 : 0
                if sqlite3_bind_int(statement, 6, modificable) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.OffLine ? 1 : 0
                if sqlite3_bind_int(statement, 7, offline) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let fechaInsert : String = formatter.string(from:hora.tim_fecha_ing!)
                if sqlite3_bind_text(statement, 8, fechaInsert, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
                
                let correlativo: Int32 = hora.tim_correl
                if sqlite3_bind_int(statement, 9, correlativo) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("fallo al insertar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
            }
            closeDB()
        }
        catch{
            print("Error:\(error)")
        }
        return true
   }
  
    func getListProyectosByCodAbogado(codigo: String) -> [ClienteProyecto]?
    {
        do
        {
            try openDB()
            let query : String = "select p.pro_id, p.pro_nombre, p.cli_nom from ClienteProyecto p where p.abo_id=?"
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(dataBase, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing get list proyectos: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, codigo, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding p.abo_id: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo get list proyectos: \(errmsg)")
            }
            
            var proyectos = [ClienteProyecto]()
            while sqlite3_step(statement) == SQLITE_ROW {
                var proyecto = ClienteProyecto()
                
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
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            closeDB()
            return proyectos
        }
        catch {
            print("Error:\(error)")
        }
        return nil
    }
    
    func getListDetalleHorasByCodAbogado(codigo: Int) -> [Horas]?
    {
       do {
            try openDB()
            let query : String = """
                select tim_correl, pro_id, tim_asunto, tim_horas, tim_minutos, abo_id, Modificable, OffLine,tim_fecha_ing
                from
                    Horas
            """
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(dataBase, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            /*if sqlite3_bind_int(statement, 1, Int32(codigo)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding abo_id: \(errmsg)")
            }*/
            
            /*if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo get list horas: \(errmsg)")
            }*/
            
            var horas = [Horas]()
            while sqlite3_step(statement) == SQLITE_ROW {
                var hora = Horas()
                
                let id : Int32 = sqlite3_column_int(statement, 0)
                hora.tim_correl = id
                
                let prodId : Int32 = sqlite3_column_int(statement, 1)
                hora.pro_id = prodId
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let asunto : String = String(cString: csString)
                    hora.tim_asunto = asunto
                }
                
                let cantHoras : Int32 = sqlite3_column_int(statement,3)
                hora.tim_horas = cantHoras
                
                let minutos : Int32 = sqlite3_column_int(statement,4)
                hora.tim_minutos = minutos
                
                let aboId : Int32 = sqlite3_column_int(statement, 5)
                hora.abo_id = aboId
               
                let modificable : Int32 = sqlite3_column_int(statement, 6)
                hora.Modificable = modificable == 1 ? true: false
                
                let offline : Int32 = sqlite3_column_int(statement, 7)
                hora.OffLine = offline == 1 ? true: false
                
                if let csString = sqlite3_column_text(statement, 8)
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    hora.tim_fecha_ing = formatter.date(from:String(cString: csString))
                }
                horas.append(hora)
                
            }
            closeDB()
            return horas
        
        } catch  {
            
        }
        return nil
    }
    
    public func getListDetalleHorasByCodAbogadoAndFecha(codigo: String, fecha: String) -> [Horas]?
    {
        do {
            try openDB()
            let query : String = """
                select
                    tim_correl, pro_id, tim_asunto, tim_horas, tim_minutos, abo_id, Modificable, OffLine, tim_fecha_ing
                from
                    Horas h
                where
                    abo_id=? AND strftime('%Y-%m-%d',h.tim_fecha_ing)=?
            """
            

            var statement: OpaquePointer?
            if sqlite3_prepare_v2(dataBase, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(codigo)!) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, fecha, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding fecha: \(errmsg)")
            }
            
            /*if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo get list horas: \(errmsg)")
            }*/
            
            var horas = [Horas]()
            while sqlite3_step(statement) == SQLITE_ROW {
                var hora = Horas()
                
                let id : Int32 = sqlite3_column_int(statement, 0)
                hora.tim_correl = id
                
                let prodId : Int32 = sqlite3_column_int(statement, 1)
                hora.pro_id = prodId
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let asunto : String = String(cString: csString)
                    hora.tim_asunto = asunto
                }
                
                let cantHoras : Int32 = sqlite3_column_int(statement,3)
                hora.tim_horas = cantHoras
                
                let minutos : Int32 = sqlite3_column_int(statement,4)
                hora.tim_minutos = minutos
                
                let aboId : Int32 = sqlite3_column_int(statement, 5)
                hora.abo_id = aboId
                
                let modificable : Int32 = sqlite3_column_int(statement, 6)
                hora.Modificable = modificable == 1 ? true: false
                
                let offline : Int32 = sqlite3_column_int(statement, 7)
                hora.OffLine = offline == 1 ? true: false
                
                if let csString = sqlite3_column_text(statement, 8)
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let fechaInsert : Date? = formatter.date(from:String(cString: csString))
                    hora.tim_fecha_ing = fechaInsert
                }
                horas.append(hora)
                
            }
            closeDB()
            return horas
            
        } catch  {
            
        }
        return nil
    }
    
    
    public func getListDetalleHorasByCodAbogadoAndFecha(codigo: String) -> [Horas]?
    {
        do {
            try openDB()
            let query : String = """
                select
                    tim_correl, pro_id, tim_asunto, tim_horas, tim_minutos, abo_id, Modificable, OffLine, tim_fecha_ing
                from
                    Horas h
                where
                    abo_id=?
            """
            
            
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(dataBase, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, codigo, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("failure binding abo_id: \(errmsg)")
            }
          
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
                print("fallo get list horas: \(errmsg)")
            }
            
            var horas = [Horas]()
            while sqlite3_step(statement) == SQLITE_ROW {
                var hora = Horas()
                
                let id : Int32 = sqlite3_column_int(statement, 0)
                hora.tim_correl = id
                
                let prodId : Int32 = sqlite3_column_int(statement, 1)
                hora.pro_id = prodId
                
                if let csString = sqlite3_column_text(statement,2)
                {
                    let asunto : String = String(cString: csString)
                    hora.tim_asunto = asunto
                }
                
                let cantHoras : Int32 = sqlite3_column_int(statement,3)
                hora.tim_horas = cantHoras
                
                let minutos : Int32 = sqlite3_column_int(statement,4)
                hora.tim_minutos = minutos
                
                let aboId : Int32 = sqlite3_column_int(statement, 5)
                hora.abo_id = aboId
                
                let modificable : Int32 = sqlite3_column_int(statement, 6)
                hora.Modificable = modificable == 1 ? true: false
                
                let offline : Int32 = sqlite3_column_int(statement, 7)
                hora.OffLine = offline == 1 ? true: false
                
                if let csString = sqlite3_column_text(statement, 8)
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let fechaInsert : Date? = formatter.date(from:String(cString: csString))
                    hora.tim_fecha_ing = fechaInsert
                }
                horas.append(hora)
                
            }
            closeDB()
            return horas
            
        } catch  {
            
        }
        return nil
    }
    
    
    
    /*
    public bool DeleteHoras(IEnumerable<Horas> horas)
{
    try
{
    var db = _DBLocal;
    foreach (var data in horas)
    {
    int returnValue = db.Delete(data);
    }
    return true;
    }
    catch (Exception ex)
    {
    throw ex;
    }
    }
    

    

    
    public int GetCountHoras(string fecha, string codigo)
{
    var db = _DBLocal;
    var count = db.ExecuteScalar<int>(
    @"select COUNT(*)
    from Horas
    where strftime('%d-%m-%Y',tim_fecha_ing)=? AND abo_id=?", fecha, codigo);
    return count;
    }
    
    public IEnumerable<HorasWithProyecto> GetListDetalleHorasByCodAbogadoAndFecha(string fecha, string codigo)
{
    var db = _DBLocal;
    List<HorasWithProyecto> data = db.Query<HorasWithProyecto>(@"
    select h.tim_correl, h.tim_horas, h.tim_minutos, h.tim_fecha_ing, p.pro_id, p.pro_nombre, p.cli_nom
    from Horas h inner join ClienteProyecto p on h.pro_id=p.pro_id
    where strftime('%d-%m-%Y',h.tim_fecha_ing)=? AND h.abo_id=?", fecha, codigo);
    return data;
    }
    
    public IEnumerable<ClienteProyecto> GetProyectos()
{
    var db = _DBLocal;
    return db.Query<ClienteProyecto>(
    @"select distinct p.pro_id, p.pro_nombre,  p.cli_nom
    from ClienteProyecto p
    where 1=1");
    }
    
    
    public IEnumerable<Usuario> GetUsuarios()
{
    var db = _DBLocal;
    return db.Query<Usuario>("select * from Usuario");
    }
    
    public static int DeletesUsuarios()
{
    var db = _DBLocal;
    return db.DeleteAll<Usuario>();
    }
}
*/
}
 
 
