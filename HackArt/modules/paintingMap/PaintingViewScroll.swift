import UIKit

class PaintingViewScroll: BasicScrollView, UIScrollViewDelegate {
  
  private let paintingView: PaintingView = PaintingView()
  
  var paintingDelegate: PaintingViewDelegate? {
    get { return paintingView.delegate }
    set { paintingView.delegate = newValue }
  }
  
  var isBackgroundHidden: Bool {
    get { return paintingView.isBackgroundHidden }
    set { paintingView.isBackgroundHidden = newValue }
  }
  
  override func initialize() {
    super.initialize()
    
    addSubview(paintingView)
    maximumZoomScale = 4
    delegate = self
    clipsToBounds = true
    backgroundColor = UIColor.black
  }
  
  
  private var layoutedFor: CGSize?
  override func layoutSubviews() {
    super.layoutSubviews()
    guard layoutedFor != bounds.size else { return }
    
    layoutedFor = bounds.size
    contentSize = bounds.size
    paintingView.frame = bounds
  }
  
  
  func display(painting: Painting) {
    paintingView.display(painting: painting)
  }
  
  
  func set(id: Int, hidden: Bool) {
    paintingView.set(id: id, hidden: hidden)
  }
  
  
  // MARK: UIScrollView
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return paintingView
  }
}

