import UIKit
import Firebase

enum ProviderTypeEdit: String{
    case basic
}

class EditViewController: UIViewController {
    
    private let email: String
    //private var pass: String
    private let provider: ProviderType
    private let db = Firestore.firestore()
    
    @IBOutlet weak var lblNombre: UITextField!
    @IBOutlet weak var lblTelefono: UITextField!
    @IBOutlet weak var lblContra: UITextField!
    @IBOutlet weak var lblNuevaContra: UITextField!
    @IBOutlet weak var lblPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("users").document(email).getDocument{
            (DocumentSnapshot, Error) in
            
            if let document = DocumentSnapshot, Error == nil{
                if let nombre = document.get("nombre") as? String {
                    self.lblNombre.text = nombre
                }
                if let telefono = document.get("telefono") as? String {
                    self.lblTelefono.text = telefono
                }
                if let cont = document.get("uid") as? String {
                    self.lblPass.text = cont
                }
            }
        }
        
    }
    
    
    init(email: String, provider: ProviderType) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @IBAction func clickBtnEditar(_ sender: Any) {
        
        let contra = lblContra.text
        let contraConfi = lblNuevaContra.text
        
        if contraConfi != ""{
            if contra == contraConfi{
                Auth.auth().currentUser?.updatePassword(to: contra ?? "") { (error) in
                }
                
                self.db.collection("users").document(email).setData(["nombre" : self.lblNombre.text ?? "", "telefono" : self.lblTelefono.text ?? "", "correo": self.email, "uid": Auth.auth().currentUser?.uid ?? ""])
            }else{
                let alertController = UIAlertController(title: "Error", message: "Las contraseñas no coinciden.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }else{
            self.db.collection("users").document(email).setData(["nombre" : self.lblNombre.text ?? "", "telefono" : self.lblTelefono.text ?? "", "correo": self.email, "uid": Auth.auth().currentUser?.uid ?? ""])
        }
        //Auth.auth().currentUser?.updatePassword(to: ((contra ?? "") ?? ""),
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickBtnCancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickBtnBorrar(_ sender: Any) {
        
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            
            let alertController = UIAlertController(title: "Error", message: "No se pudo eliminar el usuario.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
          } else {
            self.db.collection("users").document(self.email).delete()
            
            self.navigationController?.popToRootViewController(animated: true)
          }
        }
        
    }
    
    
}
