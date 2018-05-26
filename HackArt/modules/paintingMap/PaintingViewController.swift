import UIKit


class PaintingViewController: BasicViewController {
  @IBOutlet private weak var paintingView: PaintingView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    paintingView?.setup()
  }
  
  
  
}
