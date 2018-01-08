//
//  PresenterSemana.swift
//  tsummary
//
//  Created by Soporte on 11-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

class PresenterSemana{
    
    
    private var mView : IListViewSemana!
    private var mFecha: Date!
    private var mCantidadDias: Int = 0
    
    private let calendar : Calendar = {
        let locale = Locale(identifier: "es_CL")
        let tz = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        calendar.timeZone = tz
        return calendar
    }()
    

    init(view: IListViewSemana, rangoDeDias cantidad: Int) {
        self.mView = view
        self.mCantidadDias = cantidad
        self.mFecha = Date()
    }
    
    /*
    func setDate(fecha: Date)
    {
        self.mFecha = fecha
    }
    */
    
    private func firstDateOfWeek(year: Int, weekOfYear: Int) -> Date?
    {
        var dtComponents = DateComponents()
        dtComponents.day = 1
        dtComponents.month = 1
        dtComponents.year = year
        
        let newDate = self.calendar.date(from:dtComponents)
        let offset =  self.calendar.firstWeekday - self.calendar.component(Calendar.Component.weekday, from: newDate!)
        
        let firstWeekDay  = self.calendar.date(byAdding: Calendar.Component.day, value: offset, to: newDate!)
       
        let firstWeek = self.calendar.component(Calendar.Component.weekOfYear, from: newDate!)
        var weekOfYearTemp = ((firstWeek <= 1 || firstWeek >= 52) && offset >= -3) ?  weekOfYear - 2 : weekOfYear
        if (weekOfYearTemp == 0)
        {
            weekOfYearTemp = 1
        }
        
        return self.calendar.date(byAdding: Calendar.Component.day, value: ((weekOfYearTemp*7)+7), to: firstWeekDay!)
    }
    
    public func calcularSemana()
    {
        let año = self.calendar.component(Calendar.Component.year, from:  self.mFecha)
        let nroSemana = self.calendar.component(Calendar.Component.weekOfYear, from:  self.mFecha)
        var semana:[Dia] = [Dia]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = calendar.locale
        dateFormatter.timeZone = calendar.timeZone
        
        let diaTermino = firstDateOfWeek(year: año, weekOfYear: nroSemana)
        if let fechaDeTermino = diaTermino
        {
            var fechaDeInicio: Date? = calendar.date(byAdding: Calendar.Component.day, value: -self.mCantidadDias, to: fechaDeTermino)
            for i in 0..<self.mCantidadDias {
                let dia = Dia()
                dateFormatter.dateFormat = "EE"
                dia.nombre = dateFormatter.string(from: fechaDeInicio!)
                dia.nro = calendar.component(Calendar.Component.day, from: fechaDeInicio!)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                //dateFormatter.dateFormat = "dd-MM-yyyy"
                dia.Fecha = dateFormatter.string(from: fechaDeInicio!)
                semana.append(dia)
                fechaDeInicio = calendar.date(byAdding: Calendar.Component.day, value: 1, to: fechaDeInicio!)
            }
            
            self.mView.setList(semana: semana)
        }
        
    }
    
}
