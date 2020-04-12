//
//  ViewController.swift
//  Color Selector
//
//  Created by Yuriy Balabin on 09.04.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let screen = UIScreen.main.bounds
    var basketForBubbles = [UIView]()
    var colors = [
        UIColor.red,
        UIColor.blue,
        UIColor.purple,
        UIColor.green,
        UIColor.yellow,
        UIColor.orange,
        UIColor.cyan,
        UIColor.magenta,
        UIColor.gray,
        UIColor.brown
    ]
    
    let selectButton: UIButton = {
        let bttn = UIButton()
        
        bttn.layer.cornerRadius = 22
        bttn.setTitle("Select color", for: .normal)
        bttn.titleLabel?.font =
        UIFont.boldSystemFont(ofSize: 18)
        bttn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        bttn.addTarget(self, action: #selector(createBubbleField), for: .touchUpInside)
        bttn.translatesAutoresizingMaskIntoConstraints = false
       return bttn
    }()
    
    var shadowLayer: CALayer = {
        let layer = CALayer()
        let screen = UIScreen.main.bounds
        
        layer.frame = screen
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0
        
        return layer
    }()
    
    
    let bubble: UIView = {
        let bubble = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        let screen = UIScreen.main.bounds
        bubble.center =
            CGPoint(x: screen.size.width / 2, y: screen.size.height + 20)
        bubble.layer.cornerRadius = 10
        return bubble
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
  
        
        
       getStorage()
       setView()
    
    }

    func getStorage() {
       
        basketForBubbles = bubble.clones(colors.count)
        
        for (j,i) in basketForBubbles.enumerated() {
            i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnBubble(sender: ))))
            i.backgroundColor = colors[j]
        }
        
     
    }
    
    
    func setView() {
        
        
        view.layer.addSublayer(shadowLayer)
        
        view.addSubview(selectButton)
        basketForBubbles.forEach {
            view.addSubview($0)
        }
        
        
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    @objc func tapOnBubble(sender: UITapGestureRecognizer) {
        
        guard let bubble = sender.view else { return }
        
        view.backgroundColor = bubble.backgroundColor

        self.basketForBubbles.forEach { $0.transform = .identity }
        self.basketForBubbles.forEach {
            $0.center = self.bubble.center
        }
        self.selectButton.isEnabled = true
        self.selectButton.alpha = 1
        self.shadowLayer.opacity = 0
    }
    
    
    func cent(num: Int) -> CGPoint {
        
        let mainOffset = bubble.frame.size.width * 5
        let count = Int(screen.width / mainOffset)
        var marg = screen.width - mainOffset * CGFloat(count)
        let offSetY = CGFloat.random(in: -15...15)
        let offSetX = CGFloat.random(in: -10...10)
        let numberOfWholeRows = num / (count + 1)
        let r = num - numberOfWholeRows * (count + 1)
        let rest = colors.count % (count + 1)
       
        
        if num > colors.count - rest - 1 {
            marg = screen.width - mainOffset * CGFloat(rest - 1)
        }
        
        let point = CGPoint(x: marg/2 + CGFloat(r) * mainOffset + offSetX, y: screen.height - CGFloat(numberOfWholeRows) * 100 + offSetY - 100)
      
        return point
    }
    
    
    @objc func createBubbleField() {
       
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0
        anim.toValue = 0.8
        anim.duration = 0.8
        shadowLayer.add(anim, forKey: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseIn], animations: {
            
            self.selectButton.alpha = 0.2

            for (i,bb) in self.basketForBubbles.enumerated() {
                bb.center = self.cent(num: i)
            }
            
                }) { tr in
                    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: [], animations: {
                        
                        self.shadowLayer.opacity = 0.8
                        self.basketForBubbles.forEach {
                            $0.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                        }
                    }, completion: nil)
                }
        selectButton.isEnabled = false
    }
    
       
    
    
}

extension UIView {
    
    func clone() -> UIView {
        
        let view = UIView()
        
        view.frame = self.frame
        view.backgroundColor = self.backgroundColor
        view.layer.cornerRadius = self.layer.cornerRadius
        
        return view
    }
    
    func clones(_ count: Int) -> [UIView] {
        
        var arrayClones = [UIView]()
       
        guard count > 0 else { return arrayClones }
        
        arrayClones.append(self.clone())
        
        for i in 1..<count {
        arrayClones.append(arrayClones[i - 1].clone())
        }
        
        return arrayClones
    }
}
