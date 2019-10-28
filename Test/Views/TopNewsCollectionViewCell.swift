import UIKit

fileprivate let sourceBackgroundViewCornerRadius: CGFloat = 10

class TopNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sourceBackgroundView: UIView!
    @IBOutlet weak var newsImgMissingLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTimeLbl: UILabel!
    @IBOutlet weak var newsSourceLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsSourceLbl.textColor = Constants.newsSourceColor
        sourceBackgroundView.layer.cornerRadius = sourceBackgroundViewCornerRadius
        sourceBackgroundView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        newsTimeLbl.text = ""
        newsSourceLbl.text = ""
        newsTitleLbl.text = ""
        newsImg.image = UIImage() // Бажано встановлювати картинку за замовчуванням
    }
    
    func configure(item: PageItemObjectModel) {
        newsTimeLbl.text = " - " + String(item.price ?? 0) + "hours_ago".localize()
        newsSourceLbl.text = String(item.id ?? 0)
        newsTitleLbl.text = item.name ?? ""
        
        setImage(url: item.image?.url)
    }
    
    private func setImage(url: String?) {
        if let url = url {
            newsImgMissingLbl.isHidden = true
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            newsImg?.sd_setImage(with: URL(string: url), completed: {
                [weak self] _, _, _, _ in
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            })
            newsImg.isHidden = false
            newsImg.contentMode = .scaleAspectFill
            newsImg.clipsToBounds = true
        } else {
            newsImg.isHidden = true
            newsImgMissingLbl.isHidden = false
        }
    }
}
