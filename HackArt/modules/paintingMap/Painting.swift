import UIKit
import PocketSVG


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
