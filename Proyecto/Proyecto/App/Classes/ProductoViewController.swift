 import UIKit
 import Firebase
 import Photos
 
 enum ProviderPrTypeEdit: String{
     case basic
 }
 
 class ProductoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let email: String
    private let provider: ProviderType
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
            return
        }
        
        self.lblImagen.text = urlString
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        })
        
        task.resume()
        
    }
    
    init(email: String, provider: ProviderType) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var lblProducto: UITextField!
    
    @IBOutlet weak var lblPrecio: UITextField!
    
    @IBOutlet weak var lblDescri: UITextField!
    
    @IBOutlet weak var lblLugar: UITextField!
    
    @IBOutlet weak var lblTelefono: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var lblImagen: UILabel!
    
    @IBAction func didTapButton(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private let storage = Storage.storage().reference()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        storage.child("images/file.png").putData(imageData, metadata: nil, completion:{ _, error in guard error == nil else {
            print("Error")
            return
        }
        
        self.storage.child("images/file.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlString = url.absoluteString;
            print("URL: \(urlString)")
            UserDefaults.standard.set(urlString, forKey: "url")
            
        })
        
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickBtnEnviar(_ sender: Any) {
        self.db.collection("productos").document(email).setData(["nombre" : self.lblProducto.text ?? "", "telefono" : self.lblTelefono.text ?? "", "precio": self.lblPrecio.text ?? "", "descri": self.lblDescri.text ?? "", "imagen": self.lblImagen.text ?? "", "lugar": self.lblLugar.text ?? ""])
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickBtnCancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
 }
 
