import Foundation
import UIKit

public class AjustesViewController: UIViewController
{
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "TimeSummary"
    }
    
    @IBAction func btnCancelar_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
