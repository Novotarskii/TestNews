import UIKit

class TopNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var topNewsImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    private var viewModel: TopNewsTableVIewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "TopNewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopNews")
        
        viewModel = TopNewsTableVIewCellViewModel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(news: [PageItemObjectModel]) {
        self.viewModel?.setTopNews(news: news)
        pageController.numberOfPages = news.count
        
        collectionView.reloadData()
    }
}

extension TopNewsTableViewCell : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageController.currentPage = Int(pageNumber)
    }
}

extension TopNewsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getTopNews().count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let news = viewModel?.getTopNews()
        guard let item = news?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNews", for: indexPath) as! TopNewsCollectionViewCell
        cell.configure(item: item)
        return cell
    }
}
