import UIKit
import PocketSVG


class PaintingLayer: BasicLayer {
  private var imageLayer: CALayer = CALayer()
  private var backgroundLayer: CALayer = CALayer()
  
  var isBackgroundHidden: Bool = false {
    didSet {
      set(backgroundHidden: isBackgroundHidden)
    }
  }
  
  private var toMask: [SpecyficLayer] = [] {
    willSet {
      for tm in toMask {
        tm.removeFromSuperlayer()
      }
    }
    didSet {
      for tm in toMask {
        addSublayer(tm)
      }
    }
  }
  private var highlightAreas: [Int: CAShapeLayer] = [:] {
    willSet {
      for (_, layer) in highlightAreas {
        layer.removeFromSuperlayer()
      }
    }
    didSet {
      toMask = (0..<highlightAreas.count).map {
        (_: Int) -> SpecyficLayer in return self.createImage()
      }
      var i = 0
      for (_, layer) in highlightAreas {
        toMask[i].mask = layer
        i += 1
      }
      setNeedsLayout()
    }
  }
  
  private var hitAreas: [Int: CAShapeLayer] = [:] {
    willSet {
      for (_, layer) in hitAreas {
        layer.removeFromSuperlayer()
      }
    }
    didSet {
      for (_, layer) in hitAreas {
        addSublayer(layer)
      }
      setNeedsLayout()
    }
  }
  
  
  private(set) var painting: Painting! {
    didSet {
      var highlight: [Int: CAShapeLayer] = [:]
      for (id, path) in painting.highlightPaths {
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.red.cgColor
        
        highlight[id] = layer
      }
      self.highlightAreas = highlight
      
      var hit: [Int: CAShapeLayer] = [:]
      for (id, path) in painting.hitPaths {
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        
        hit[id] = layer
      }
      self.hitAreas = hit
      
      imageLayer.contents = painting.image.cgImage
      backgroundLayer.contents = painting.background?.cgImage
      backgroundLayer.opacity = 1.0
    }
  }
  
  
  
  
  override func initialize() {
    super.initialize()
    addSublayer(imageLayer)
    imageLayer.masksToBounds = true
    imageLayer.contentsScale = UIScreen.main.scale
    
    addSublayer(backgroundLayer)
    backgroundLayer.isHidden = true
    imageLayer.masksToBounds = true
    imageLayer.contentsScale = UIScreen.main.scale
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    guard painting != nil else { return }
    
    
    let scaleTransform: CATransform3D = getScaleTransform(frame: painting.framePath)
    for (id, path) in painting.highlightPaths {
      highlightAreas[id]?.transform = CATransform3DConcat(scaleTransform, path.transform)
    }
    
    for (id, path) in painting.hitPaths {
      hitAreas[id]?.transform = CATransform3DConcat(scaleTransform, path.transform)
    }
    
    let xScale: CGFloat = bounds.width / painting.image.size.width
    let yScale: CGFloat = bounds.height / painting.image.size.height
    
    var imgH: CGFloat
    var imgW: CGFloat
    
    if xScale > yScale {
      imgH = bounds.height
      imgW = imgH * painting.image.size.width / painting.image.size.height
    } else {
      imgW = bounds.width
      imgH = imgW * painting.image.size.height / painting.image.size.width
    }
    imageLayer.bounds.size = CGSize(width: imgW, height: imgH)
    imageLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    let imgFrame: CGRect = imageFrame()
    for tm in toMask {
      tm.frame = bounds
      tm.myFrame = imgFrame
    }
    
    backgroundLayer.frame = imgFrame
  }
  
  
  func display(painting: Painting) {
    self.painting = painting
    set(backgroundHidden: true)
  }
  
  
  func set(alpha: Float, for id: Int) {
    highlightAreas[id]?.opacity = alpha
  }
  
  
  func set(id: Int, hidden: Bool) {
    highlightAreas[id]?.opacity = hidden ? 0.0 : 1.0
  }
  
  func set(backgroundHidden hidden: Bool) {
    backgroundLayer.isHidden = hidden
    imageLayer.isHidden = !hidden
    for tm in toMask {
      tm.isHidden = !hidden
    }
  }
  
  
  func didHit(id: Int, point: CGPoint) -> Bool {
    if let layer: CALayer = hitAreas[id] {
      let affineTransform: CGAffineTransform = CATransform3DGetAffineTransform(layer.transform)
      let point = point.applying(affineTransform.inverted())
      
      if highlightAreas[id]?.opacity != 0.0 {
        return hitAreas[id]?.path?.contains(point) == true
      } else {
        return false
      }
      
    }
    return false
  }
  
  
  private func getScaleTransform(frame: SVGBezierPath) -> CATransform3D {
    let xScale: CGFloat = bounds.width / frame.bounds.width
    let yScale: CGFloat = bounds.height / frame.bounds.height
    var scale: CGFloat
    if xScale < CGFloat(1.0) || yScale < CGFloat(1.0) {
      scale = fmin(xScale, yScale)
    } else {
      scale = fmax(xScale, yScale)
    }
    
    
    let scalledH: CGFloat = frame.bounds.height * scale
    let scalledW: CGFloat = frame.bounds.width * scale
    
    let moveDown: CGFloat = (bounds.height - scalledH) / CGFloat(2.0)
    let moveRight: CGFloat = (bounds.width - scalledW) / CGFloat(2.0)
    
    
    let translate: CATransform3D = CATransform3DTranslate(
      CATransform3DIdentity,
      -frame.bounds.minX + moveRight,
      -frame.bounds.minY + moveDown,
      CGFloat(0.0)
    )
    
    
    return CATransform3DScale(translate, scale, scale, CGFloat(0.0))
  }
  
  private func createImage() -> SpecyficLayer {
    let result: SpecyficLayer = SpecyficLayer()
    result.myContents = painting.background?.cgImage ?? #imageLiteral(resourceName: "god").cgImage
    return result
  }
  
  private func imageFrame() -> CGRect {
    guard let bgSize: CGSize = painting.background?.size else {
      return bounds
    }
    let imgSize: CGSize = imageLayer.frame.size
//    let imgOrigin: CGPoint = imageLayer.frame.origin
    
    let scaleX: CGFloat = imgSize.width / bgSize.width
    let scaleY: CGFloat = imgSize.height / bgSize.height
    
    var size: CGSize
    if scaleX < scaleY {
      size = CGSize(
        width: imgSize.height * bgSize.width / bgSize.height,
        height: imgSize.height
      )
    } else {
      size = CGSize(
        width: imgSize.width,
        height: imgSize.width * bgSize.height / bgSize.width
      )
    }
    let origin: CGPoint = CGPoint(
      x: ((bounds.width - size.width) / CGFloat(2.0)),
      y: ((bounds.height - size.height) / CGFloat(2.0))
    )
    
    
    
    return CGRect(origin: origin, size: size)
  }
}




fileprivate class SpecyficLayer: BasicLayer {
  let bg: CALayer = CALayer()
  
  override func initialize() {
    super.initialize()
    
    addSublayer(bg)
    bg.masksToBounds = true
    bg.contentsScale = UIScreen.main.scale
  }
  
  var myContents: Any? {
    get { return bg.contents }
    set { bg.contents = newValue }
  }
  
  var myFrame: CGRect {
    get { return bg.frame }
    set { bg.frame = newValue }
  }
}
