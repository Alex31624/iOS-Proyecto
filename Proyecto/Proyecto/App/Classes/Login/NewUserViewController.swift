import UIKit
import Firebase

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var telefonoTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var passConfirmTextField: UITextField!
    
    @IBOutlet weak var btnRegistrar: UIButton!
    
    @IBOutlet weak var btnCancelar: UIButton!
    
    private let db = Firestore.firestore()
    
    
    
    @IBAction func clickRegistrar(_ sender: Any) {
        
        let contra = passTextField.text
        let contraConfi = passConfirmTextField.text
        
        
        if contra == contraConfi{
            
            if let correo = correoTextField.text, let pass = passTextField.text {
                
                Auth.auth().createUser(withEmail: correo, password: pass){
                    (result, error) in
                    if let result = result, error == nil {
                        
                        self.db.collection("users").document(correo).setData(["nombre" : self.nombreTextField.text ?? "", "correo" : self.correoTextField.text ?? "", "telefono" : self.telefonoTextField.text ?? "", "uid" : result.user.uid])
                        
                        self.navigationController?.pushViewController(HomeViewController(email: result.user.email ?? correo, provider: .basic), animated: true)
                        
                    }else{
                        
                        let alertController = UIAlertController(title: "Error", message: "Se ha producido un error al registrar el usuario.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }else{
            let alertController = UIAlertController(title: "Error", message: "Las contraseñas no coinciden.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func clickCancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
