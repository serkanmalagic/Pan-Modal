//
//  ViewController.swift
//  PansModal
//
//  Created by Serkan Mehmet Malagiç on 26.01.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var btn : UIButton = {
        let button = UIButton()
        button.setTitle("trigger modal", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    func setUI() {
        view.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let slideVC = TodoViewController()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.view.backgroundColor = .white
        self.present(slideVC, animated: true, completion: nil)
    }

}


extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PanViewController(presentedViewController: presented, presenting: presenting)
    }
}
