import Foundation
class Calendario
{
    private var mFechaInicio : Date!
    private var mFechaTermino: Date!
    private var mFechaActual: Date!
    private var mCantidadDias: Int = 14
    public static let instance = Calendario()
    
    private let calendar : Calendar =
    {
        let locale = Locale(identifier: "es_CL")
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        return calendar
    }()
    
    
    init()
    {
        self.mFechaActual = Date()
        self.calcFechas()
    }
    
    public var fechaInicio : Date
    {
        return self.mFechaInicio
    }
    
    public var fechaTermino : Date
    {
        return self.mFechaTermino
    }
    
    private func calcFechas()
    {
        let year = calendar.component(Calendar.Component.year, from:  self.mFechaActual)
        var weekOfYear = calendar.component(Calendar.Component.weekOfYear, from: self.mFechaActual)
        var dtComponents = DateComponents()
        dtComponents.day = 1
        dtComponents.month = 1
        dtComponents.year = year
        let newDate = calendar.date(from:dtComponents)
        
        let offset = calendar.firstWeekday - calendar.component(Calendar.Component.weekday, from: newDate!)
        let firstWeekDay = calendar.date(byAdding: Calendar.Component.day, value: offset, to: newDate!)
        let firstWeek = calendar.component(Calendar.Component.weekOfYear, from: firstWeekDay!)
        weekOfYear = ((firstWeek <= 1 || firstWeek >= 52) && offset >= -3) ? weekOfYear - 1: weekOfYear
        
        self.mFechaTermino = self.calendar.date(byAdding: Calendar.Component.day, value: ((weekOfYear*7)+7), to: firstWeekDay!)!
        
        self.mFechaInicio = calendar.date(byAdding: Calendar.Component.day, value:-self.mCantidadDias, to: self.mFechaTermino)
    }
    
    func obtDias() -> [Dia]
    {
        let formatter = DateFormatter()
        formatter.locale = calendar.locale

        var semana:[Dia] = [Dia]()
        var fecha: Date? = self.mFechaInicio
        for _ in 0..<self.mCantidadDias {
            let dia = Dia()
            formatter.dateFormat = "EE"
            dia.nombre = formatter.string(from: fecha!)
            dia.nro = calendar.component(Calendar.Component.day, from: fecha!)
            formatter.dateFormat = "yyyy-MM-dd"
            dia.fecha = formatter.string(from: fecha!)
            semana.append(dia)
            fecha = calendar.date(byAdding: Calendar.Component.day, value: 1, to: fecha!)
        }
        return semana
    }
    
}
