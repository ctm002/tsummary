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
        if let hora = ControladorProyecto.instance.getById(id)
        {
            ControladorProyecto.instance.delete(hora)
            return true
        }
        return false
    }
    
    func save(_ hora: Horas) -> Bool
    {
        return ControladorProyecto.instance.save(hora)
    }
    
    func syncronizer(_ codigo: String)-> Bool
    {
        sincronizerProyects(codigo)
        sincronizerHours(codigo)
        return true
    }
    
    private func sincronizerHours(_ codigo: String)-> Bool
    {
        WSTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            if let hrsLocales = ControladorProyecto.instance.getListHorasByCodAbogado(codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    ControladorProyecto.instance.save(nuevos)
                }
                
                let eliminados : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: hrsRemotas!)
                if (eliminados.count > 0)
                {
                    ControladorProyecto.instance.delete(eliminados)
                }
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                       ControladorProyecto.instance.save(hrs)
                    }
                }
            }
        })
        return true
    }
    
    private func sincronizerProyects(_ codigo: String)-> Bool
    {
        return true
    }
    
    
}
