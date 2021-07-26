import UIKit
import Firebase

class PassViewController: UIViewController {
    
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBAction func clickCancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickBtnPass(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: self.correoTextField.text!){ error in
            if error == nil {
                print("Enviado")
            }else{
                print("Error -  \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
}
