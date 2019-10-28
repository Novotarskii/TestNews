

import UIKit
import XLPagerTabStrip
import Localize
import RxSwift
import RxCocoa
import RxDataSources
import SideMenu

class NewsToolBarController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var newsToolBarItem: UIBarButtonItem!
    @IBOutlet weak var searchToolBarItem: UIBarButtonItem!
    @IBOutlet weak var menuToolBarItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var viewModel: NewsToolBarViewModel?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        viewModel = NewsToolBarViewModel()
        
        settings.style.buttonBarBackgroundColor = .black
        settings.style.buttonBarItemBackgroundColor = .black
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        view.backgroundColor = .black
        
        setNeedsStatusBarAppearanceUpdate()
        
        bind()
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = NewsTableViewController(itemInfo: IndicatorInfo(title: "stories".localize()))
        let child_2 = VideoViewController(itemInfo: IndicatorInfo(title: "video".localize()))
        let child_3 = VideoViewController(itemInfo: IndicatorInfo(title: "favorites".localize()))
        return [child_1, child_2, child_3]
    }
    
    private func bind() {        
        viewModel?.internetConnection.bind() {
            [weak self] connection in
            self?.internet(connection: connection)
        }.disposed(by: disposeBag)
        
        viewModel?.error.bind() {
            [weak self] error in
            let alert = UIAlertController(title: "error".localize(), message: error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
