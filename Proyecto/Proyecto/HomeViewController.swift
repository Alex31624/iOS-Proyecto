import UIKit
import Firebase

enum ProviderType: String{
    case basic
}

class HomeViewController: UIViewController{
    
    private let email: String
    private let provider: ProviderType
    private let db = Firestore.firestore()
    
    @IBOutlet weak var lblUser: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("users").document(email).getDocument{
            (DocumentSnapshot, Error) in
            
            if let document = DocumentSnapshot, Error == nil{
                if let nombre = document.get("nombre") as? String {
                    self.lblUser.text = nombre
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
    
    @IBAction func clickBtnCerrar(_ sender: Any) {
        switch provider{
        case .basic:
            do{
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            }catch{
                
            }
        }
    }
    
    
    @IBAction func clickBtnEditar(_ sender: Any) {
        
        self.navigationController?.pushViewController(EditViewController(email: self.email, provider: .basic), animated: true)
    }
    
}
