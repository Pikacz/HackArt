//
//  HomeViewController.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class HomeViewController: BasicViewController, PaintingViewDelegate {

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
  
    @IBOutlet weak var paintingView: PaintingViewScroll! {
        didSet {
          paintingView?.paintingDelegate = self
        }
    }
    
    @IBOutlet var paintToBtnsCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintLeadCnstr: NSLayoutConstraint!
    @IBOutlet weak var paintTopCnstr: NSLayoutConstraint!
    private lazy var paintBottomCnstr: NSLayoutConstraint = paintStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    
    @IBOutlet weak var paintStack: UIStackView!
    @IBOutlet weak var paintView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(info)
        filterBtn.text = "dupsra"
        filterBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        detectionBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        eyeBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        heartBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(dupa), for: .touchUpInside)
        
        addBurgerButton()
        setPaintingButtons()
      
        let painting: Painting = Painting(name: "Witkacy", image: #imageLiteral(resourceName: "Bitmap"))!
        paintingView?.display(painting: painting)

        
        self.view.bringSubview(toFront: paintStack)
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(animate))
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

    @objc private func animate() {
        if paintToBtnsCnstr.isActive == true {
            paintingFullScreen()
        } else {
            paintingNormalScreen()
        }
    }
    @objc private func paintingFullScreen() {
        self.paintToBtnsCnstr.isActive = false
        UIView.animate(withDuration: 0.5, animations: {
            self.paintStack.arrangedSubviews.last?.isHidden = true
            self.paintTopCnstr.constant = 0
            self.paintLeadCnstr.constant = 0
            self.paintBottomCnstr.isActive = true
            })
    }
    @objc private func paintingNormalScreen() {
        self.paintBottomCnstr.isActive = false
        self.paintStack.arrangedSubviews.last?.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.paintTopCnstr.constant = 24
            self.paintLeadCnstr.constant = 24
            self.paintToBtnsCnstr.isActive = true
        })
    }
    
    private func setPaintingButtons () {
        eyeBtn.image = UIImage(named: "eyeIcon")
        heartBtn.image = UIImage(named: "heartIcon")
        nextBtn.image = UIImage(named: "rightArrowIcon")
    }
    

}
