import UIKit
import PocketSVG


class PaintingLayer: BasicLayer {
  private var imageLayer: CALayer = CALayer()
  
  
  private var toMask: [CALayer] = [] {
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
        (_: Int) -> CALayer in return self.createImage()
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
  
  
  private var painting: Painting! {
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
    }
  }
  
  
  
  
  override func initialize() {
    super.initialize()
    addSublayer(imageLayer)
    imageLayer.masksToBounds = true
    imageLayer.contentsScale = UIScreen.main.scale
    
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    guard painting != nil else { return }
    let imgFrame: CGRect = imageFrame()
    for tm in toMask {
      tm.frame = imgFrame
    }
    
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
  }
  
  
  func display(painting: Painting) {
    self.painting = painting
  }
  
  
  func set(alpha: Float, for id: Int) {
    highlightAreas[id]?.opacity = alpha
  }
  
  
  func set(id: Int, hidden: Bool) {
    highlightAreas[id]?.opacity = hidden ? 0.0 : 1.0
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
  
  private func createImage() -> CALayer {
    let result: CALayer = CALayer()
    result.contentsScale = UIScreen.main.scale
    result.contents = painting.background?.cgImage ?? #imageLiteral(resourceName: "god").cgImage
    return result
  }
  
  private func imageFrame() -> CGRect {
    
    return bounds
  }
}


