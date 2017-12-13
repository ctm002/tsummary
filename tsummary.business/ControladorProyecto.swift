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
    static let  Instance = ControladorProyecto()
    
    init() {}
    
    
    func sincronizar(codigo: String) -> Bool
    {
        //sincronizarProyectos(codigo: codigo)
        //sincronizarHoras(codigo:codigo)
        return true
    }
    
    
    private func sincronizarHoras(codigo: String) -> Bool
    {
        WSTimeSummary.Instance.getListDetalleHorasByCodAbogado(codigo: codigo, callback:{(horasRemotas)->Void in
            if let hrsLocales = LocalStoreTimeSummary.Instance.getListDetalleHorasByCodAbogado(codigo: codigo)
            {
                let nuevos: [Horas] = self.minus(arreglo1: horasRemotas!, arreglo2: hrsLocales)
                let eliminadas : [Horas] = self.minus(arreglo1: hrsLocales, arreglo2: horasRemotas!)
                
                if (nuevos.count > 0)
                {
                    LocalStoreTimeSummary.Instance.save(horas: nuevos)
                }
                
                if (eliminadas.count > 0)
                {
                    LocalStoreTimeSummary.Instance.delete(horas:eliminadas)
                }
            }
            else
            {
                if let hrs = horasRemotas
                {
                    if (hrs.count > 0)
                    {
                        LocalStoreTimeSummary.Instance.save(horas: hrs)
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
        WSTimeSummary.Instance.getListProyectosByCodAbogado(codigo: codigo, callback: { (proyectos) -> Void in
            LocalStoreTimeSummary.Instance.save(proyectos: proyectos!)
            resp = true
        })
        return resp
    }
}
