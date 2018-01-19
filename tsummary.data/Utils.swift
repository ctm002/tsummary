import Foundation

public class Utils
{
    static func toDateFromString(_ string: String, _ format: String = "yyyy-MM-dd HH:mm:ss") -> Date?
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func toStringFromDate(_ date: Date,  _ format: String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
