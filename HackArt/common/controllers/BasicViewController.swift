import UIKit


class BasicViewController: UIViewController {
  func showOkAlert(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: handler))
    present(alert, animated: true)
  }  
}
