import Foundation

public class DataBase
{
    static let instance = DataBase()
    
    init() {}
    
    static var horas : TbHora
    {
        get
        {
            return TbHora.instance
        }
    }
    
    static var proyectos : TbProyecto
    {
        get
        {
            return TbProyecto.instance
        }
    }
}
