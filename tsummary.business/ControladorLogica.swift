//
//  ControladorLogica.swift
//  tsummary
//
//  Created by OTRO on 09-01-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import Foundation
public class ControladorLogica
{
    static let instance = ControladorLogica()
    
    init() {}
    
    func deleteById(_ id:Int32)-> Bool{
        if let hora = DataBase.horas.getById(id)
        {
            hora.Estado = .eliminado
            hora.OffLine = true
            DataBase.horas.delete(hora)
            return true
        }
        return false
    }
    
    func save(_ hora: Horas) -> Bool
    {
        return DataBase.horas.save(hora)
    }
    
    func syncronizer(_ codigo: String)-> Bool
    {
        sincronizerProyects(codigo)
        return true
    }
    
    private func sincronizerHours(_ codigo: String)-> Bool
    {
        WSTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            
            if let hrsLocales = DataBase.horas.getListHorasByCodAbogado(codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    DataBase.horas.save(nuevos)
                }
                
                let eliminados : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: hrsRemotas!)
                if (eliminados.count > 0)
                {
                    DataBase.horas.delete(eliminados)
                }
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                       DataBase.horas.save(hrs)
                    }
                }
            }
        })
        return true
    }
    
    private func sincronizerProyects(_ codigo: String)-> Bool
    {
        var resp : Bool = false
        WSTimeSummary.instance.getListProyectosByCodAbogado(codigo: codigo, callback: { (proyectos) -> Void in
            for p in proyectos!
            {
                let exists = DataBase.proyectos.getById(p.pro_id)
                if (exists == nil)
                {
                   DataBase.proyectos.save(p)
                }
            }
            self.sincronizerHours(codigo)
        })
        return resp
    }
    
    func minus(arreglo1:[Horas], arreglo2:[Horas]) -> [Horas]
    {
        var resultado = [Horas]()
        
        var exists : Bool = false
        for i in arreglo1
        {
            for j in arreglo2 {
                if i.tim_correl == j.tim_correl
                {
                    exists = true
                }
            }
            if (exists == false)
            {
                resultado.append(i)
            }
            exists = false
        }
        return resultado
    }
    
    func deleteAll()
    {
        DataBase.horas.deleteAll()
    }
}
