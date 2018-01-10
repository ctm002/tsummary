import UIKit

class PresenterProyecto {
    
    var mView: IListViewProyecto?
    
    init(_ view : IListViewProyecto) {
        self.mView = view
    }
    
    func getListProyectos()
    {
        if let proyectos = DataBase.proyectos.getListProyectos()
        {
            self.mView!.setList(proyectos: proyectos)
        }
    }
}
