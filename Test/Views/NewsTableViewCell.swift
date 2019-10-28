import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsTimeLbl: UILabel!
    @IBOutlet weak var newsSourceLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var textBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTitleLbl.textColor = .black
        textBackgroundView.backgroundColor = .white
        newsSourceLbl.textColor = Constants.newsSourceColor
        newsImg.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        newsTimeLbl.text = ""
        newsSourceLbl.text = ""
        newsTitleLbl.text = ""
        newsImg.image = UIImage()// Бажано встановлювати картинку за замовчуванням
    }
    
    func configure(item: PageItemObjectModel) {
        newsTimeLbl.text = " - " + String(item.price ?? 0) + "hours_ago".localize()
        newsSourceLbl.text = String(item.id ?? 0)
        newsTitleLbl.text = item.name ?? ""
        
        setImage(url: item.image?.url)
    }
    
    
    private func setImage(url: String?) {
        if let url = url {
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
        }
    }
}
