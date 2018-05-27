import UIKit
import PocketSVG



protocol PaintingViewDelegate: class {
  func paintingView(_ view: PaintingView, didSelect id: Int)
}


class PaintingView: BasicView {
  
  private let paintingLayer: PaintingLayer = PaintingLayer()
  
  weak var delegate: PaintingViewDelegate?
  
  var isBackgroundHidden: Bool {
    get { return paintingLayer.isBackgroundHidden }
    set { paintingLayer.isBackgroundHidden = newValue }
  }
  
  private var buttons: [AreaButton] = [] {
    willSet {
      for b: AreaButton in buttons {
        b.removeFromSuperview()
      }
    }
    didSet {
      for b: AreaButton in buttons {
        addSubview(b)
      }
    }
  }
  
  override func initialize() {
    super.initialize()
    
    backgroundColor = UIColor.black

    layer.addSublayer(paintingLayer)
    paintingLayer.frame = layer.bounds

    
  }
  
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    paintingLayer.frame = layer.bounds
    for b: AreaButton in buttons {
      b.frame = CGRect.zero
    }
  }
  
  
  
  func display(painting: Painting) {
    var newButtons: [AreaButton] = []
    for (id, _) in painting.highlightPaths {
      let btn: AreaButton = AreaButton()
      btn.id = id
      btn.paintingLayer = paintingLayer
      btn.addTarget(self, action: #selector(btnHit(_:)), for: UIControlEvents.touchUpInside)
      newButtons.append(btn)
    }
    buttons = newButtons
    
    paintingLayer.display(painting: painting)
  }
  
  func set(id: Int, hidden: Bool) {
    paintingLayer.set(id: id, hidden: hidden)
  }
  
  
  @objc private func btnHit(_ btn: AreaButton) {
    guard let id: Int = btn.id else { return }
    delegate?.paintingView(self, didSelect: id)
  }
  
  
}



fileprivate class AreaButton: BasicControl {
  var id: Int?
  weak var paintingLayer: PaintingLayer?
  
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let id: Int = id else { return false }
    return paintingLayer?.didHit(id: id, point: point) ?? false
  }
  
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let id: Int = id else { return nil }
    if paintingLayer?.didHit(id: id, point: point) != false {
      return super.hitTest(point, with: event)
    }
    return nil
  }
  
  
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let result = super.beginTracking(touch, with: event)
    if result {
      if let id: Int = id {
        self.paintingLayer?.set(alpha: Float(0.4), for: id)
      }
    }
    return result
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    if let id: Int = id {
      self.paintingLayer?.set(alpha: Float(1.0), for: id)
    }
  }
  
  override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    if let id: Int = id {
      self.paintingLayer?.set(alpha: Float(1.0), for: id)
    }
  }

}







