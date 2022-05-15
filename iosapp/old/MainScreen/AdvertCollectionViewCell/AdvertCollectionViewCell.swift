import UIKit
import Kingfisher

class AdvertCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: AdvertCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: AdvertCollectionViewCell.self), bundle: nil)
    
   
   
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerDescription: UIView!
    @IBOutlet weak var advertImageView: UIImageView!
    @IBOutlet weak var advertLabel: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelPublishDate: UILabel!
   
    private var respectButtonListener:((String, Bool) -> Void)?
    private var idAdvert:String = ""
    
    private var isFavorite: Bool = false {
        didSet {
            buttonFavorite.setBackgroundImage(buttonFavoriteImage, for: .normal)
        }
    }
    
    @IBAction func clickToRespect(_ sender: Any) {
        isFavorite = !isFavorite
        respectButtonListener?(idAdvert, isFavorite)
    }
    
    @IBOutlet weak var viewMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 20
        isFavorite = false
    }
    
    @IBOutlet var imageProportionHorizontal: NSLayoutConstraint!
    
    @IBOutlet var imageProportionVertical: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentStyle()
    }
    
    // Когда меняется экран, тема
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
       // self.traitCollection.userInterfaceStyle
    }
    
    func update(){
        
        
    }
    
    private func updateContentStyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        guard oldAxis != newAxis else { return }

        stackView.axis = newAxis
        stackView.spacing = isHorizontalStyle ? 16 : 4

        if isHorizontalStyle {
            
            
            
            
            layer.cornerRadius = 20
            NSLayoutConstraint.deactivate([imageProportionVertical])
            NSLayoutConstraint.activate([imageProportionHorizontal])
        } else {
        
            layer.cornerRadius = 30
            NSLayoutConstraint.activate([imageProportionVertical])
            NSLayoutConstraint.deactivate([imageProportionHorizontal])
        }
        
        
        
        let fontTransform: CGAffineTransform = isHorizontalStyle ? .identity : .init(scaleX: 0.8, y: 0.8)
        
        
        UIView.animate(withDuration: 0.0) {
            self.advertLabel.transform = fontTransform
            self.buttonFavorite.transform = fontTransform
            self.labelPrice.transform = fontTransform
            self.labelPublishDate.transform = fontTransform
            self.layoutIfNeeded()
        }
    }
}

extension AdvertCollectionViewCell {
        var buttonFavoriteImage: UIImage {
            switch self.isFavorite {
            case false: return  #imageLiteral(resourceName: "unfavorite").withTintColor(.black)
            case true: return #imageLiteral(resourceName: "favorite").withTintColor(.black)
        }
    }
}
