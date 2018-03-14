import Foundation
public class FileConfig
{
    static let instance = FileConfig()
    
    init()
    {
        SwiftyPlistManager.shared.start(plistNames: ["Data"], logging: true)
    }
    
    func saveWith(key: String, value: String, result :(Bool) -> Void )
    {
        SwiftyPlistManager.shared.save(value, forKey: key, toPlistWithName: "Data")
        { (err) in
            if err == nil
            {
                result(true)
            }
            else
            {
                result(false)
            }
        }
    }

    func fetch(key: String) -> String
    {
        guard let fetchedValue: String = SwiftyPlistManager.shared.fetchValue(for: key, fromPlistWithName: "Data") as! String else { return ""}
        return fetchedValue
    }

}
