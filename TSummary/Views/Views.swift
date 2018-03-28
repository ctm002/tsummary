import Foundation

protocol IListViewSemana {
    func setList(semana: [Dia])
}

protocol IViewHora {
    var idAbogado : Int32 { get set }
    var fechaHoraIngreso : String { get set }
    func setList(horas: [RegistroHora])
}


protocol IListViewProyecto {
    var idAbogado : Int32 { get set }
    func setList(proyectos: [ClienteProyecto])
}

protocol IEditViewHora {
    var model : ModelController { get set }
    
    var idHora : Int32 { get set }
    var proyectoId : Int32 { get set }
    var fechaHoraIngreso : Date { get set }
    var idAbogado : Int32 { get set }
    var horaInicio : String { get set }
    var horaFin : String { get set }
    var horaTotal : String { get set }
    var asunto : String { get set }
    var timCorrelativo : Int32 { get set }
    var response : Response { get set}
    func setNombreProyecto(_ model : ModelController)
}
