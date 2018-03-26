import Foundation
public class Utils
{
    static func toDateFromString(_ string: String,_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date?
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        //formatter.timeZone = TimeZone(identifier: "America/Santiago")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        let date = formatter.date(from: string)
        return date
    }
    
    static func toStringFromDate(_ date: Date,_ format: String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        //formatter.timeZone = TimeZone(identifier: "America/Santiago")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        let strDate = formatter.string(from: date)
        return strDate
    }
}
