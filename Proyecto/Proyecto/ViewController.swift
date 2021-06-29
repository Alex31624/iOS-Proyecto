import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var userTexfField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var cnsVerticalContent: NSLayoutConstraint!
    
    @IBOutlet weak var viewContent: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickBtnLogin(_ sender: Any) {
        if let correo = userTexfField.text, let pass = passTextField.text {
            
            Auth.auth().signIn(withEmail: correo, password: pass){
                (result, error) in
                if let result = result, error == nil {
                    
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email ?? correo, provider: .basic), animated: true)
                    
                    self.userTexfField.text = ""
                    self.passTextField.text = ""
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Error", message: "El usuario o la contraseña son erroneos, o el usuario no esta registrado.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    @IBAction func clickBtnPass(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: self.userTexfField.text!){ error in
            if error == nil {
                print("Enviado")
            }else{
                let alertController = UIAlertController(title: "Error", message: "Ingrese su correo para poder recuperar su contraseña.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alertController, animated: true, completion: nil)
                print("Error -  \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.registerKeyboardNotification()
        }
        
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.unregisterKeyboardNotification()
        }
    
    


}

extension ViewController {
 
    func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        let finalPosYViewContent = self.viewContent.frame.origin.y + self.viewContent.frame.height
        
        if finalPosYViewContent > keyboardFrame.origin.y {
        
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.cnsVerticalContent.constant = keyboardFrame.origin.y - finalPosYViewContent
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.cnsVerticalContent.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
