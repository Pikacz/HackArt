//
//  HomeViewController.swift
//  HackArt
//
//  Created by Tomasz Lizer on 26/05/2018.
//  Copyright © 2018 BoroCode. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let info: PopUpView = PopUpView()
    
    @IBOutlet weak var filterBtn: BottomButton!
    @IBOutlet weak var detectionBtn: BottomButton!
    @IBOutlet weak var eyeBtn: PaintingButtons!
    @IBOutlet weak var heartBtn: PaintingButtons!
    @IBOutlet weak var nextBtn: PaintingButtons!
    
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
    }
    
    @objc func dupa() {
        print("dupa")
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
    
}
