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
        pop.isHidden = true
        return pop
    }()

    @IBOutlet weak var filterBtn: BottomButton!
    @IBOutlet weak var detectionBtn: BottomButton!
    @IBOutlet weak var eyeBtn: PaintingButtons!
    @IBOutlet weak var heartBtn: PaintingButtons!
    @IBOutlet weak var nextBtn: PaintingButtons!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    
    @IBOutlet weak var paintingView: PaintingViewScroll! {
        didSet {
          paintingView?.paintingDelegate = self
        }
    }
    
    @IBOutlet weak var paintToBtnsCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintLeadCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintTopCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var paintStack: UIStackView!
    @IBOutlet weak var paintView: UIView!
    
    // MARK: - Paintings
    
    private let paintings: [OriginPainting] = OriginPainting.create()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(info)
        filterBtn.text = "dupsra"
        filterBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        detectionBtn.addTarget(self, action: #selector(showDetectionVC), for: .touchUpInside)
        eyeBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        addBurgerButton()
        setLbls()
        setIcons()


      
        

        
//        paintStack.translatesAutoresizingMaskIntoConstraints = false

        if let painting = paintings.first {
            set(painting: painting)
        }

        self.view.bringSubview(toFront: paintStack)
    }
    
    private func set(painting: OriginPainting) {
        paintingView.display(painting: painting.painting)
        authorLbl.text = painting.author
        titleLbl.text = painting.title
    }
    private func setLbls() {
        authorLbl.adjustsFontSizeToFitWidth = true
        authorLbl.font = authorLbl.font.withSize(14)
        titleLbl.adjustsFontSizeToFitWidth = true
    }
    
    @objc func dupa() {
        print("dupa")
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
    private func setIcons() {
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.image = UIImage(named: "heartIcon")
        nextBtn.image = UIImage(named: "rightArrowIcon")
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
        barButtonView.addTarget(self, action: #selector(burgerMenu), for: .touchUpInside)
        let barButton: UIBarButtonItem = UIBarButtonItem(customView: barButtonView)
        self.navigationItem.leftBarButtonItem = barButton
        
        let rightbarButtonView = ProfileButtonView()
        rightbarButtonView.addTarget(self, action: #selector(showPaintingFinder), for: .touchUpInside)
        let rightbarButton: UIBarButtonItem = UIBarButtonItem(customView: rightbarButtonView)
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

    
    @objc private func paintingFullScreen() {
        UIView.animate(withDuration: 2, animations: {
            self.paintStack.arrangedSubviews.last?.isHidden = true
            self.fullScrnConstraints(view: self.paintStack)
            })
//        paintStack.arrangedSubviews.last?.isHidden = true
//        paintStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//        paintStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        paintStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
    }
    
    private func fullScrnConstraints(view: UIView) {
        
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}

extension HomeViewController: CameraViewControllerFlow {
    
    func didFound(tag: Tag) {
        self.navigationController?.popViewController(animated: true)
        guard let painting = paintings.first(where: { $0.tags.contains(tag) }) else { return }
        paintingView.display(painting: painting.painting)
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
