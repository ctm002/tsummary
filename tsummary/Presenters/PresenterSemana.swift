//
//  PresenterSemana.swift
//  tsummary
//
//  Created by Soporte on 11-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import Foundation

class PresenterSemana{
    
    
    private var mView : IListViewSemana
    private var mFecha: Date
    
    init(view: IListViewSemana) {
        self.mView = view
        self.mFecha = Date()
    }
    
    
    func setDate(fecha: Date)
    {
        self.mFecha = fecha
    }
    
    private func firstDateOfWeek(year: Int, weekOfYear: Int, calendar: Calendar) -> Date?
    {
        var dtComponents = DateComponents()
        dtComponents.day = 1
        dtComponents.month = 1
        dtComponents.year = year
        
        var newDate = calendar.date(from:dtComponents)
        
        let offset =  calendar.firstWeekday - calendar.component(Calendar.Component.weekday, from: newDate!)
        
        let firstWeekDay  = calendar.date(byAdding: Calendar.Component.day, value: offset, to: newDate!)
       
        let firstWeek = calendar.component(Calendar.Component.weekOfYear, from: newDate!)
        var weekOfYearTemp = ((firstWeek <= 1 || firstWeek >= 52) && offset >= -3) ?  weekOfYear - 2 : weekOfYear
        return calendar.date(byAdding: Calendar.Component.day, value: weekOfYearTemp*7, to: firstWeekDay!)
    }
    
    public func mostrarSemana()
    {
        let locale = Locale(identifier: "es_CL")
        let tz = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        calendar.timeZone = tz
        var nroSemana = calendar.component(Calendar.Component.weekOfYear, from:  self.mFecha)
        let año = calendar.component(Calendar.Component.year, from:  self.mFecha)
        var semana:[Dia] = [Dia]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = tz
        var fechaInicial = firstDateOfWeek(year: año, weekOfYear: nroSemana, calendar: calendar)
        
        if let f = fechaInicial
        {
            for i in 0..<7 {
                var dia = Dia()
                dateFormatter.dateFormat = "EEEE"
                dia.nombre = dateFormatter.string(from: fechaInicial!)
                dia.nro = calendar.component(Calendar.Component.day, from: fechaInicial!)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dia.Fecha = dateFormatter.string(from: fechaInicial!)
                semana.append(dia)
                fechaInicial = calendar.date(byAdding: Calendar.Component.day, value: 1, to: fechaInicial!, wrappingComponents: true)
            }
            self.mView.setList(semana: semana)
        }
        
    }
    
}
