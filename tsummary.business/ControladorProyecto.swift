//
//  ControladorProyecto.swift
//  tsummary
//
//  Created by Soporte on 12-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

public class ControladorProyecto
{
    static let  instance = ControladorProyecto()
    
    init() {}
    
    
    func sincronizar(codigo: String) -> Bool
    {
        //sincronizarProyectos(codigo: codigo)
        //sincronizarHoras(codigo:codigo)
        return true
    }
    
    
    private func sincronizarHoras(codigo: String) -> Bool
    {
        let fechaDesde : String = "2017-12-15 00:00:00"
        let fechaHasta : String = "2015-12-30 23:59:59"
        
        //let hrsLocales = LocalStoreTimeSummary.Instance.getListDetalleHorasByCodAbogadoOffline(codigo: codigo)
        //let resp = WSTimeSummary.Instance.sincronizar(codigo: codigo, horas:"¨[{},{},{}]")
        WSTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo: codigo, callback:{(hrsRemotas)->Void in
            if let hrsLocales = LocalStoreTimeSummary.instance.getListDetalleHorasByCodAbogado(codigo: codigo)
            {
                let nuevos:[Horas] = self.minus(arreglo1: hrsRemotas!, arreglo2: hrsLocales)
                if (nuevos.count > 0)
                {
                    LocalStoreTimeSummary.instance.save(horas: nuevos)
                }
                
                /*
                let eliminadas : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: horasRemotas!)
                if (eliminadas.count > 0)
                {
                    LocalStoreTimeSummary.Instance.delete(horas:eliminadas)
                }
                */
            }
            else
            {
                if let hrs = hrsRemotas
                {
                    if (hrs.count > 0)
                    {
                        LocalStoreTimeSummary.instance.save(horas: hrs)
                    }
                }
            }
         })
        
        return true
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
    
    
    private func sincronizarProyectos(codigo: String) -> Bool
    {
        var resp : Bool = false
        WSTimeSummary.instance.getListProyectosByCodAbogado(codigo: codigo, callback: { (proyectos) -> Void in
            
            let temp = LocalStoreTimeSummary.instance.getListProyectos()
            
            LocalStoreTimeSummary.instance.save(proyectos: proyectos!)
            resp = true
        })
        return resp
    }
    
    public func save(_ hora: Horas)-> Bool
    {
        return LocalStoreTimeSummary.instance.save(hora: hora)
    }
    
    public func getById(_ id: Int32)-> Horas?
    {
        return LocalStoreTimeSummary.instance.getById(id)
    }
}
