//
//  HomeViewController.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class HomeViewController: BasicViewController, PaintingViewDelegate {

    let info: PopUpView = PopUpView()
    
    @IBOutlet weak var filterBtn: BottomButton!
    @IBOutlet weak var detectionBtn: BottomButton!
    @IBOutlet weak var eyeBtn: PaintingButtons!
    @IBOutlet weak var heartBtn: PaintingButtons!
    @IBOutlet weak var nextBtn: PaintingButtons!
  
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(info)
        filterBtn.text = "dupsra"
        filterBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        detectionBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        eyeBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        addBurgerButton()

      
        let painting: Painting = Painting(name: "Witkacy", image: #imageLiteral(resourceName: "Bitmap"))
        paintingView?.display(painting: painting)

        
//        paintStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.bringSubview(toFront: paintStack)
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(paintingFullScreen))
//        paintStack.addGestureRecognizer(tap)
        

    }
    
    @objc func dupa() {
        print("dupa")
    }
  
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    private func addBurgerButton() {
        let barButtonView = ProfileButtonView()
        barButtonView.addTarget(self, action: #selector(burgerMenu), for: .touchUpInside)
        let barButton: UIBarButtonItem = UIBarButtonItem(customView: barButtonView)
        self.navigationItem.leftBarButtonItem = barButton
        
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
