//
//  HomeViewController.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit
import CoreML
import Vision

class HomeViewController: BasicViewController, PaintingViewDelegate {

    private weak var tagFinder: UIViewController?
    let info: PopUpView = {
        let pop = PopUpView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        pop.alpha = 0.0
        return pop
    }()
    
    @IBOutlet weak var filterBtn: UIButton! {
        didSet {
            filterBtn.backgroundColor = UIColor.white
            filterBtn.layer.cornerRadius = 5
            filterBtn.layer.borderColor = #colorLiteral(red: 0.09411764706, green: 0.5019607843, blue: 0.4196078431, alpha: 1)
            filterBtn.layer.borderWidth = 2
            filterBtn.tintColor = #colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1)
            filterBtn.imageView?.contentMode = .scaleAspectFit
            filterBtn.setTitle("TAGI", for: .normal)
            filterBtn.setTitleColor(#colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1), for: .normal)
            filterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
           //
        }
    }
    @IBOutlet weak var detectionBtn: UIButton! {
        didSet {
            detectionBtn.backgroundColor = UIColor.white
            detectionBtn.layer.cornerRadius = 5
            detectionBtn.layer.borderColor = #colorLiteral(red: 0.09411764706, green: 0.5019607843, blue: 0.4196078431, alpha: 1)
            detectionBtn.layer.borderWidth = 2
            detectionBtn.tintColor = #colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1)
            detectionBtn.imageView?.contentMode = .scaleAspectFit
            detectionBtn.setTitle("DETEKCJA", for: .normal)
            detectionBtn.setTitleColor(#colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1), for: .normal)
            detectionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
           //
        }
    }
    
    @IBOutlet weak var eyeBtn: PaintingButtons! {
        didSet {
            eyeBtn.tintColor = #colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1)
        }
    }
    @IBOutlet weak var heartBtn: PaintingButtons! {
        didSet {
            heartBtn.tintColor = #colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1)
        }
    }
    @IBOutlet weak var nextBtn: PaintingButtons! {
        didSet {
            nextBtn.tintColor = #colorLiteral(red: 0.3137254902, green: 0.3725490196, blue: 0.6588235294, alpha: 1)
        }
    }
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.backgroundColor = UIColor.clear
            titleLbl.textColor = UIColor.black
            titleLbl.textAlignment = .left
            titleLbl.font = UIFont.italicSystemFont(ofSize: 12)
            titleLbl.text = nil
        }
    }
    @IBOutlet weak var authorLbl: UILabel!  {
        didSet {
            authorLbl.backgroundColor = UIColor.clear
            authorLbl.textColor = UIColor.black
            authorLbl.textAlignment = .left
            authorLbl.font = UIFont.italicSystemFont(ofSize: 12)
        }
    }
    @IBOutlet weak var paintingView: PaintingViewScroll! {
        didSet {
            paintingView.layer.cornerRadius = 10
            paintingView?.paintingDelegate = self
        }
    }
    
    @IBOutlet weak var paintToBtnsCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintLeadCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintTopCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var paintStack: UIStackView!
    
    // MARK: - Paintings
    
    private let paintings: [OriginPainting] = OriginPainting.create()
    private var currentPainting: OriginPainting? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(info)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.862745098, blue: 0.8392156863, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.09411764706, green: 0.5019607843, blue: 0.4196078431, alpha: 1)
        let logo = #imageLiteral(resourceName: "title")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        

        filterBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        detectionBtn.addTarget(self, action: #selector(showDetectionVC), for: .touchUpInside)
        eyeBtn.addTarget(self, action: #selector(updateBackgroundvisibility), for: .touchUpInside)
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)

        addBurgerButton()
        setLbls()
        setBottomBtns()
        setPaintingBtns()
        setPaintingView()


      
        addInfoConstraints()

        self.view.bringSubview(toFront: paintStack)
        self.view.backgroundColor = UIColor.white
        showInfo()

        if let painting = paintings.first {
            set(painting: painting)
        }

    }
    
    private func set(painting: OriginPainting) {
        currentPainting = painting
        paintingView.display(painting: painting.painting)
        authorLbl.text = painting.author + ", " + painting.title
//        authorLbl.text = painting.author
//        titleLbl.text = painting.title
    }
    
    private func setLbls() {
        authorLbl.adjustsFontSizeToFitWidth = true
//        authorLbl.font = authorLbl.font.withSize(14)
        titleLbl.adjustsFontSizeToFitWidth = true
//        titleLbl.numberOfLines = 2
    }
    
    private func setPaintingBtns() {
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.image = UIImage(named: "heartIcon")
        nextBtn.image = UIImage(named: "rightArrowIcon")
        eyeBtn.addTarget(self, action: #selector(showBottomPainting), for: .touchUpInside)
        heartBtn.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(showNextPicture), for: .touchUpInside)
    }
    
    private func setBottomBtns() {
//        filterBtn.text = "FILTR"
//        detectionBtn.text = "DETEKCJA"
        filterBtn.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        detectionBtn.addTarget(self, action: #selector(showDetectionVC), for: .touchUpInside)
    }
    
    private func setPaintingView() {
        paintingView.layer.cornerRadius = CGFloat(10)
    }
    
    @objc func dupa() {
        print("dupa")
    }
    
    @objc private func showFilter() {
        print("FILTER")
    }
    
    @objc private func showBottomPainting() {
        print("showBottomPainting")
    }
    
    @objc private func addToFavourites() {
        print("addToFavourites")
    }
    
    @objc private func showNextPicture() {
        guard paintings.count > 1 else { return }
        guard let index = paintings.index(where: { $0.identifier == currentPainting?.identifier }) else { return }
        guard index < paintings.count - 1 else {
            let painting  = paintings[0]
            set(painting: painting)
            return }
        let paintig = paintings[index + 1]
        set(painting: paintig)
        print("showNextPicture")
    }
    
    @objc func showDetectionVC() {
        guard let vc = tagFinder else {
            let vc = CameraViewController(nibName: nil, bundle: nil)
            self.tagFinder = vc
            vc.flow = self
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    @objc private func showPaintingFinder() {
        showPicker()
    }
  
    private func showPicker() {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    private func detect(image: UIImage) throws {
      //  loadingIndicator.startAnimating()
        
        let model = try VNCoreMLModel(for: TuriCreate().model)
        
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    print(error as Any)
                    return
            }
            
            DispatchQueue.main.async {
                if let painting = self?.paintings.first(where: { $0.identifier == topResult.identifier }) {
                    self?.set(painting: painting)
                }
                //self?.resultLabel.text = topResult.identifier + " (confidence \(topResult.confidence * 100)%)"
        //        self?.loadingIndicator.stopAnimating()
            }
        })
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    private func addBurgerButton() {
        let barButtonView = ProfileButtonView()
        barButtonView.set(image: #imageLiteral(resourceName: "BurgerMenu"))
        barButtonView.addTarget(self, action: #selector(burgerMenu), for: .touchUpInside)
        let barButton: UIBarButtonItem = UIBarButtonItem(customView: barButtonView)
        barButton.tintColor = #colorLiteral(red: 0.09411764706, green: 0.5019607843, blue: 0.4196078431, alpha: 1)
        self.navigationItem.leftBarButtonItem = barButton
        
        let rightbarButtonView = ProfileButtonView()
        rightbarButtonView.set(image: #imageLiteral(resourceName: "camera"))
        rightbarButtonView.addTarget(self, action: #selector(showPaintingFinder), for: .touchUpInside)
        let rightbarButton: UIBarButtonItem = UIBarButtonItem(customView: rightbarButtonView)
        rightbarButton.tintColor = #colorLiteral(red: 0.09411764706, green: 0.5019607843, blue: 0.4196078431, alpha: 1)
        self.navigationItem.rightBarButtonItem = rightbarButton
    }
    
    @objc private func burgerMenu() {
        print("burger")
    }
    
    private func addInfoConstraints() {
        info.translatesAutoresizingMaskIntoConstraints = false
        info.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        info.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        info.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.5).isActive = true
        info.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.8).isActive = true
    }
    private func showInfo() {
        print("showinfo")
        self.view.bringSubview(toFront: info)
        self.info.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
                self.info.alpha = 1.0
                self.info.isUserInteractionEnabled = true
        })
        
    }
    
    
    @objc func updateBackgroundvisibility() {
        paintingView.isBackgroundHidden = !paintingView.isBackgroundHidden
    }
    // MARK: PaintingViewDelegate
    func paintingView(_ view: PaintingView, didSelect index: Int) {
      var msg: String = ""
      switch index {
      case 1: msg = """
        Kuropatwę myjemy, osuszamy, całą dokładnie nacieramy solą, pieprzem, jałowcem i czosnkiem,
        tak natartą wkładamy do lodówki na 12 godzin. Następnie cienkimi plasterkami słoniny i boczku
        obkładamy całego ptaka, zapewni to jędrność mięsa. Przygotowaną kuropatwę wkładamy do naczynia
        żaroodpornego i wkładamy do piekarnika na 280 stopni na 30-40 minut, podczas pieczenia polewać
        czerwonym wytrawnym winem. Gotową odstawić w ciepłe miejsce na około 15 minut, w tym czasie na
        płynie z pieczenia przygotowujemy sos, dodajemy grzyby, śliwki wędzone, przyprawy i gotujemy aż
        płyn się zredukuje, gotowym polewamy ptaki, układamy na talerzu z buraczkami i zieleniną.
        """
      case 2: msg = "Pedofil!!!"
      case 3: msg = "Zboczeniec!!!"
      default: break
      }
      
      showOkAlert(message: msg) {
        (_: UIAlertAction) in
        self.paintingView?.set(id: index, hidden: true)
      }
    }
    
}

extension HomeViewController: CameraViewControllerFlow {
    
    func didFound(tag: Tag) {
        self.navigationController?.popViewController(animated: true)
        guard let painting = paintings.first(where: { $0.tags.contains(tag) }) else { return }
        set(painting: painting)
    }
    
}

extension HomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        try? detect(image: image)
    }
}
