//
//  Horas.swift
//  tsummary
//
//  Created by OTRO on 09-01-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation
import SQLite3

class TbHora
{
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var db: OpaquePointer?
    var fileURL: URL
    
    static let instance = TbHora()
    
    init() {
        fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: true).appendingPathComponent("tsummary.db")
        do
        {
            try open()
            createTable()
            close()
        }
        catch
        {
             print("\(error)")
        }
    }
    
    func  createTable()
    {
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
    
    func open() throws
    {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
           throw  Errores.ErrorConexionDataBase
        }
    }
    
    func close()
    {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
    }
    
    func delete(_ horas: [Horas]) -> Bool
    {
        do
        {
            try open()
            for hora in horas {
                
                var statement: OpaquePointer?
                
                if sqlite3_prepare_v2(db,"""
                    update Horas set OffLine=1, estado=? where hora_id=?
                """
                    , -1, &statement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing update: \(errmsg)")
                }
                
                if sqlite3_bind_int(statement, 1, Int32(hora.Estado.rawValue)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding estado: \(errmsg)")
                }
                
                if sqlite3_bind_int(statement, 2, hora.IdHora) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding hora_id: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo preparing update: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK {
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
    
    func save(_ horas:[Horas]) -> Bool
    {
        do
        {
            try open()
            for hora in horas {
                
                var statement: OpaquePointer?
                let sql = """
                insert into Horas(
                        tim_correl,
                        pro_id,
                        tim_asunto,
                        tim_horas,
                        tim_minutos,
                        abo_id,
                        Modificable,
                        OffLine,
                        tim_fecha_ing,
                        estado)
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
                        ?)
                """
                
                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                }
                
                let correlativo: Int32 = hora.tim_correl
                if sqlite3_bind_int(statement, 1, correlativo) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.proyecto.pro_id)
                if sqlite3_bind_int(statement, 2,  prodId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 3, hora.tim_asunto, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int = hora.tim_horas
                if sqlite3_bind_int(statement, 4, Int32(horas)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int = hora.tim_minutos
                if sqlite3_bind_int(statement, 5, Int32(minutos))  != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int = hora.abo_id
                if sqlite3_bind_int(statement, 6,  Int32(aboId)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.Modificable ? 1 : 0
                if sqlite3_bind_int(statement, 7, modificable) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.OffLine ? 1 : 0
                if sqlite3_bind_int(statement, 8, offline) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 9, hora.tim_fecha_ing, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
                
                let estado : Int32 = Int32(hora.Estado.rawValue)
                if sqlite3_bind_int(statement, 10, estado) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
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
    
    public func save(_ hora: Horas)-> Bool
    {
        var resp: Bool = false
        do
        {
            try open()
            if hora.IdHora == 0
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
                        Modificable,
                        OffLine,
                        tim_fecha_ing,
                        estado)
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
                        ?)
                """
                
                if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                }
                
                let correlativo: Int32 = hora.tim_correl
                if sqlite3_bind_int(statement, 1, correlativo) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_correl: \(errmsg)")
                }
                
                let prodId : Int32 = Int32(hora.proyecto.pro_id)
                if sqlite3_bind_int(statement, 2,  prodId) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding pro_id: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 3, hora.tim_asunto, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_asunto: \(errmsg)")
                }
                
                let horas : Int = hora.tim_horas
                if sqlite3_bind_int(statement, 4, Int32(horas)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_horas: \(errmsg)")
                }
                
                let minutos : Int = hora.tim_minutos
                if sqlite3_bind_int(statement, 5, Int32(minutos))  != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding tim_minutos: \(errmsg)")
                }
                
                let aboId : Int = hora.abo_id
                if sqlite3_bind_int(statement, 6,  Int32(aboId)) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding abo_id: \(errmsg)")
                }
                
                let modificable : Int32 = hora.Modificable ? 1 : 0
                if sqlite3_bind_int(statement, 7, modificable) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding modificable: \(errmsg)")
                }
                
                let offline : Int32 = hora.OffLine ? 1 : 0
                if sqlite3_bind_int(statement, 8, offline) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_bind_text(statement, 9, hora.tim_fecha_ing, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding fecha_insert: \(errmsg)")
                }
                
                let estado : Int32 = Int32(hora.Estado.rawValue)
                if sqlite3_bind_int(statement, 10, estado) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding offline: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo al insertar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK {
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
                    Modificable=?,
                    OffLine=?,
                    tim_fecha_ing=?,
                    estado=?
                where
                    hora_id=?
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
                
                let id: Int32 = hora.IdHora
                if sqlite3_bind_int(statement, 10, id) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding hora_id: \(errmsg)")
                }
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("fallo al actualizar en la tabla horas: \(errmsg)")
                }
                
                if sqlite3_finalize(statement) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error finalizing prepared statement: \(errmsg)")
                }
                resp = true
            }
            close()
        }
        catch{
            print("Error: save")
            close()
        }
        return resp
    }
    
    public func getById(_ id: Int32) -> Horas?
    {
        var hora: Horas!
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
                h.Modificable,
                h.OffLine,
                h.tim_fecha_ing,
                p.pro_nombre,
                p.cli_nom,
                h.hora_id
            from
                Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
            where
                 h.hora_id=?
            order by h.tim_fecha_ing asc
            """

            try open()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(id)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            if sqlite3_step(statement) == SQLITE_ROW{
                hora = getHoraFromRecord(&statement)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
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
    
    public func getListHorasByCodAbogado(_ codigo: String) -> [Horas]?
    {
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
                    h.Modificable,
                    h.OffLine,
                    h.tim_fecha_ing,
                    p.pro_nombre,
                    p.cli_nom,
                    h.hora_id
                from
                    Horas h inner join ClienteProyecto p ON h.pro_id = p.pro_id
                where
                    h.abo_id=?
            """
            
            try open()
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
            close()
            return horas
        }
        catch
        {
            print("Error: getListHorasByCodAbogado")
            close()
        }
        return nil
    }
    
    public func delete(_ hora:Horas) -> Bool
    {
        do
        {
            try open()
            
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db,
            """
                update Horas set OffLine=1, estado=? where hora_id=?
            """
                , -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(hora.Estado.rawValue)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding estado: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 2, hora.IdHora) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding hora_id: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("fallo preparing update: \(errmsg)")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            close()
            return true
        }
        catch
        {
            print("Error: delete")
            close()
        }
        return false
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
    
    public func getListDetalleHorasByCodAbogadoAndFecha(codigo: String, fecha: String) -> [Horas]?
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
                h.estado != 2
                AND abo_id=? AND strftime('%Y-%m-%d',h.tim_fecha_ing)=?
            order by h.tim_fecha_ing asc
        """
        do
        {
            try open()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing get list horas: \(errmsg)")
            }
            
            if sqlite3_bind_int(statement, 1, Int32(codigo)!) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding abo_id: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 2, fecha, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding fecha: \(errmsg)")
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
    
    func deleteAll()-> Bool
    {
        do
        {
            try open()
            if sqlite3_exec(db, "delete from Horas", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error deleting table: \(errmsg)")
            }
            close()
            return true
        }
        catch
        {
            print("\(error)")
            return false
        }
    }
}
