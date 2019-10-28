
import Foundation
import UIKit

enum ConnectionViewType: Int {
    case disconnected = 100
    case connected = 101
}

extension UIViewController {
    func internet(connection: Bool) {
        if connection {
            if let _ = self.view.viewWithTag(ConnectionViewType.disconnected.rawValue) {
                addSubview()
            }
        } else {
            guard let _ = self.view.viewWithTag(ConnectionViewType.disconnected.rawValue) else {
                addSubview(color: .black, text: "no_connection".localize(), connection: ConnectionViewType.disconnected)
                return
            }
        }
    }
    
    func addSubview(color: UIColor = .green,
                    text: String = "connect_restored".localize(),
                    connection: ConnectionViewType = ConnectionViewType.connected) {
        
        if let viewWithTag = self.view.viewWithTag(ConnectionViewType.disconnected.rawValue) {
            viewWithTag.removeFromSuperview()
        }
        
        let screenSize = self.view.frame.size
        let connectionView: UIView = UIView(frame: CGRect(x: 0, y: screenSize.height - 30, width: screenSize.width, height: 30))
        connectionView.backgroundColor = color
        connectionView.tag = connection.rawValue
        connectionView.layer.zPosition = 9999
        
        let connectionLbl = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30))
        connectionLbl.text = text
        connectionLbl.textAlignment = .center
        connectionLbl.textColor = .white
        
        connectionView.addSubview(connectionLbl)
        
        switch connection {
        case ConnectionViewType.connected:
            Timer.scheduledTimer(timeInterval: 3.0,
            target: self,
            selector: #selector(removeSubviews),
            userInfo: nil,
            repeats: true)
        default:
            break
        }
            
            
        self.view.addSubview(connectionView)
    }
    
    @objc func removeSubviews() {
        if let viewWithTag = self.view.viewWithTag(ConnectionViewType.connected.rawValue) {
        viewWithTag.removeFromSuperview()
        }
    }
}
