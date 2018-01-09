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
}
