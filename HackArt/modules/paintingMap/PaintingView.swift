import UIKit
import PocketSVG


class PaintingView: BasicView {
  
  private let paintingLayer: PaintingLayer = PaintingLayer()
  
  
  
  
  override func initialize() {
    super.initialize()
    
    backgroundColor = UIColor.black

    layer.addSublayer(paintingLayer)
    paintingLayer.frame = layer.bounds

    let painting: Painting = Painting(name: "asd", image: #imageLiteral(resourceName: "mob2264"))!
    paintingLayer.display(painting: painting)
    
    
  }
  
  
  

  
  
  override func layoutSubviews() {
    super.layoutSubviews()

    paintingLayer.frame = layer.bounds
  }
  
  func setup() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hmm(tap:)))
    addGestureRecognizer(tap)
  }
  
  @objc private func hmm(tap: UITapGestureRecognizer) {
    let point: CGPoint = tap.location(in: self)
    
    if paintingLayer.didHit(id: 1, point: point) {
      print("klikłem sierp bro")
    }
    
  }
}


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
      toMask = (0..<highlightAreas.count).map { (_: Int) -> CALayer in return self.createImage() }
      var i = 0
      for (_, layer) in highlightAreas {
//        addSublayer(layer)
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
  
  private let cokolwiek: CALayer = CALayer()
  
  
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
  
  
  func didHit(id: Int, point: CGPoint) -> Bool {
    if let layer: CALayer = hitAreas[id] {
      let affineTransform: CGAffineTransform = CATransform3DGetAffineTransform(layer.transform)
      let point = point.applying(affineTransform.inverted())
      
            return hitAreas[id]?.path?.contains(point) == true
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
    result.contents = #imageLiteral(resourceName: "god").cgImage
    return result
  }
  
  private func imageFrame() -> CGRect {
    return bounds
  }
}






class Painting {
  let hitPaths: [Int: SVGBezierPath]
  let highlightPaths: [Int: SVGBezierPath]
  let framePath: SVGBezierPath
  
  let image: UIImage
  
  
  init?(name: String, image: UIImage) {
    guard let url: URL = Bundle.main.url(forResource: name, withExtension: "svg") else { return nil }
    var hit: [Int: SVGBezierPath] = [:]
    var highlight: [Int: SVGBezierPath] = [:]
    var frame: SVGBezierPath!
    
    for path: SVGBezierPath in SVGBezierPath.pathsFromSVG(at: url) {
      if Painting.isFrame(path: path) {
        frame = path
      } else if let hitId: Int = Painting.hitId(path: path) {
        hit[hitId] = path
      } else if let highlightId: Int = Painting.highlightId(path: path) {
        highlight[highlightId] = path
      }
    }
    self.hitPaths = hit
    self.highlightPaths = highlight
    self.framePath = frame
    self.image = image
  }
  
  
  private static func isFrame(path: SVGBezierPath) -> Bool {
    return path.id == "frame"
  }
  
  
  private static func hitId(path: SVGBezierPath) -> Int? {
    guard let pathId: String = path.id else { return nil }
    guard pathId.hasPrefix("hit_") else { return nil }
    return Int(pathId[pathId.index(pathId.startIndex, offsetBy: 4)...])
  }
  
  private static func highlightId(path: SVGBezierPath) -> Int? {
    guard let pathId: String = path.id else { return nil }
    guard pathId.hasPrefix("highlight_") else { return nil }
    return Int(pathId[pathId.index(pathId.startIndex, offsetBy: 10)...])
  }
}



extension SVGBezierPath {
  
  var transform: CATransform3D {
    if let transform = svgAttributes["transform"] as? CGAffineTransform {
      return  CATransform3DMakeAffineTransform(transform)
    }
    
    return CATransform3DIdentity
  }
  
  
  var id: String? {
    return svgAttributes["id"] as? String
  }
  
  
}
