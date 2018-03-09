import Foundation

public class PresenterSemana
{
    private var mView : IListViewSemana!
    
    
    public init()
    {
        self.mView = nil
    }
    
    
    init(view: IListViewSemana)
    {
        self.mView = view
    }
    
    public func mostrar()
    {
        let semana: [Dia] = DateCalculator.instance.obtDias()
        self.mView.setList(semana: semana)
    }
}
	
