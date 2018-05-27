import UIKit



class PaintingViewController: BasicViewController, PaintingViewDelegate {
  @IBOutlet private weak var paintingView: PaintingViewScroll! {
    didSet {
      paintingView?.paintingDelegate = self
    }
  }

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let painting: Painting = Painting(name: "Witkacy", image: #imageLiteral(resourceName: "Bitmap"))!
    paintingView?.display(painting: painting)
    
  }
  
  
  
  // MARK: PaintingViewDelegate
  func paintingView(_ view: PaintingView, didSelect index: Int) {
    var msg: String = ""
    switch index {
    case 1: msg = "Ciekawostka 1"
    case 2: msg = "Pedofil!!!"
    case 3: msg = "Zboczeniec!!!"
    default: break
    }
    
    showOkAlert(title: "elo", message: msg) {
      (_: UIAlertAction) in
      self.paintingView?.set(id: index, hidden: true)
    }
  }
}
