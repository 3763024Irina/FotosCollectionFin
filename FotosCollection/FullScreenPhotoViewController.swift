import UIKit
import SDWebImage

class FullScreenPhotoViewController: UIViewController {
    private let imageView = UIImageView()
    var photoURL: String? 
    init(photoURL: String) {
        self.photoURL = photoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
     
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
      
        if let urlString = photoURL, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
       
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}
