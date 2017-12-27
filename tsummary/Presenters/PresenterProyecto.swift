import UIKit

class PresenterProyecto {
    
    var mView: IListViewProyecto?
    
    init(_ view : IListViewProyecto) {
        self.mView = view
    }
    
    func getListProyectos()
    {
        if let proyectos = LocalStoreTimeSummary.instance.getListProyectos()
        {
            self.mView!.setList(proyectos: proyectos)
        }
    }
}
