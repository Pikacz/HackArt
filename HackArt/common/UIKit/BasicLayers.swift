import UIKit


class BasicLayer: CALayer {
  override init() {
    super.init()
    initialize()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(layer: aDecoder)
    initialize()
  }
  
  func initialize() {}
}
