import Foundation

public class PresenterSemana
{
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
    
    public init()
    {
        self.mView = nil
        self.mCantidadDias = 14
        self.mFecha = Date()
    }
    
    init(view: IListViewSemana, rangoDeDias cantidad: Int)
    {
        self.mView = view
        self.mCantidadDias = cantidad
        self.mFecha = Date()
    }
    
    func firstDateOfWeek(_ mFecha: Date!) -> Date?
    {
        let year = self.calendar.component(Calendar.Component.year, from:  mFecha)
        let weekOfYear = self.calendar.component(Calendar.Component.weekOfYear, from: mFecha)
        
        var dtComponents = DateComponents()
        dtComponents.day = 1
        dtComponents.month = 1
        dtComponents.year = year
        
        let newDate = self.calendar.date(from:dtComponents)
        let offset =  self.calendar.firstWeekday - self.calendar.component(Calendar.Component.weekday, from: newDate!)
        
        let firstWeekDay  = self.calendar.date(byAdding: Calendar.Component.day, value: offset, to: newDate!)
       
        let firstWeek = self.calendar.component(Calendar.Component.weekOfYear, from: firstWeekDay!)
        var weekOfYearTemp = ((firstWeek <= 1 || firstWeek >= 52) && offset >= -3) ? weekOfYear - 1 : weekOfYear
        if (weekOfYearTemp <= 0)
        {
            weekOfYearTemp = 1
        }
        return self.calendar.date(byAdding: Calendar.Component.day, value: ((weekOfYearTemp*7)+7), to: firstWeekDay!)
    }
    
    public func calcularSemana()
    {
        var semana:[Dia] = [Dia]()
        
        let formatter = DateFormatter()
        formatter.locale = calendar.locale
        formatter.timeZone = calendar.timeZone
        
        let diaTermino = firstDateOfWeek(self.mFecha)
        if let fechaDeTermino = diaTermino
        {
            var fechaDeInicio: Date? = calendar.date(byAdding: Calendar.Component.day, value: -self.mCantidadDias, to: fechaDeTermino)
            for i in 0..<self.mCantidadDias {
                let dia = Dia()
                formatter.dateFormat = "EE"
                dia.nombre = formatter.string(from: fechaDeInicio!)
                dia.nro = calendar.component(Calendar.Component.day, from: fechaDeInicio!)
                formatter.dateFormat = "yyyy-MM-dd"
                dia.Fecha = formatter.string(from: fechaDeInicio!)
                semana.append(dia)
                fechaDeInicio = calendar.date(byAdding: Calendar.Component.day, value: 1, to: fechaDeInicio!)
            }
            self.mView.setList(semana: semana)
        }
    }
}
