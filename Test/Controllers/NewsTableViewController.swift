import Foundation
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources

fileprivate enum Section: Int {
    case top = 0
}

fileprivate var footerHeight: CGFloat = 20
fileprivate var lastSectionFooterHeight: CGFloat = 70

class NewsTableViewController: UITableViewController, IndicatorInfoProvider {

    private var activityView = UIActivityIndicatorView()
    
    private var itemInfo = IndicatorInfo(title: "View")
    private var viewModel: NewsViewModel?
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel()
        tableView.backgroundColor = Constants.tableViewBackgroundColor
        tableView.register(UINib (nibName: "TopNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "TopNews")
        tableView.register(UINib (nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "News")
        setTableViewSettings()
        binds()
    }
    
    private func setTableViewSettings() {
        tableView.dataSource = nil
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    private func binds() {
        let cvReloadDataSource = RxTableViewSectionedReloadDataSource <NewsSectionsModel>(
            configureCell: {
                [weak self] dataSource , tableView, ip, item in
                self?.viewModel?.getNewPageIfNeeded(ip: ip)
                
                switch dataSource[ip] {
                case let .news(item):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: ip) as! NewsTableViewCell
                    cell.configure(item: item)
                    return cell
                case let .topNews(items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TopNews", for: ip) as! TopNewsTableViewCell
                    cell.configure(news: items)
                    return cell
                }
        })
        
        viewModel?.sections
            .bind(to: tableView.rx.items(dataSource: cvReloadDataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel?.isLastSection(section: section) ?? false {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            activityView = UIActivityIndicatorView(style: .gray)
            activityView.center = footerView.center
            footerView.addSubview(activityView)
            activityView.bringSubviewToFront(footerView)
            activityView.startAnimating()
            return footerView
        }
        return UIView()
    }
    

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel?.isLastSection(section: section) ?? false {
            return lastSectionFooterHeight
        }
        return footerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.getCellHeight(ip: indexPath) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.getCellHeight(ip: indexPath) ?? 0
    }

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
