//
//  ViewController.swift
//  Color Selector
//
//  Created by Yuriy Balabin on 09.04.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    // Variables
    let screen = UIScreen.main.bounds
    var basketOfBubbles = [UIView]()
   
//MARK: UI elements
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
    
    
    let superBubble: UIView = {
        let bubble = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        let screen = UIScreen.main.bounds
        bubble.center =
            CGPoint(x: screen.size.width / 2, y: screen.size.height + 20)
        bubble.layer.cornerRadius = 10
        return bubble
    }()

//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
  
        
       getBubbles()
       setView()
    
    }
 
    //filling of basket
    func getBubbles() {
       
        basketOfBubbles = superBubble.clones(colors.count)
        
        for (index,bubble) in basketOfBubbles.enumerated() {
        bubble.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnBubble(sender: ))))
        bubble.backgroundColor = colors[index]
        }
        
    }
    
//MARK: Setup UI
    func setView() {
        
        
        view.layer.addSublayer(shadowLayer)
        view.addSubview(selectButton)
        
        basketOfBubbles.forEach {
            view.addSubview($0)
        }
        
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
//MARK: Functions
    @objc func tapOnBubble(sender: UITapGestureRecognizer) {
        
        guard let bubble = sender.view else { return }
        
        view.backgroundColor = bubble.backgroundColor

        self.basketOfBubbles.forEach { $0.transform = .identity }
        self.basketOfBubbles.forEach {
            $0.center = self.superBubble.center
        }
        self.selectButton.isEnabled = true
        self.selectButton.alpha = 1
        self.shadowLayer.opacity = 0
    }
    
    
    
    
    @objc func createBubbleField() {
       
        let shadow = CABasicAnimation(keyPath: "opacity")
        shadow.fromValue = 0
        shadow.toValue = 0.8
        shadow.duration = 0.8
        shadowLayer.add(shadow, forKey: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseIn], animations: {
            
            self.selectButton.alpha = 0.2

            for (index,bubble) in self.basketOfBubbles.enumerated() {
                bubble.center = self.newBubbleCenter(tag: index)
            }
            
                }) { tr in
                    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: [], animations: {
                        
                        self.shadowLayer.opacity = 0.8
                        self.basketOfBubbles.forEach {
                            $0.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                        }
                    }, completion: nil)
                }
        selectButton.isEnabled = false
    }
    
    
    func newBubbleCenter(tag: Int) -> CGPoint {
        
        let mainOffset = superBubble.frame.size.width * 5
        let countOfMainoOffsets = Int(screen.width / mainOffset)
        var margin = screen.width - mainOffset * CGFloat(countOfMainoOffsets)
        let littleOffSetY = CGFloat.random(in: -15...15)
        let littleOffSetX = CGFloat.random(in: -10...10)
        let numberOfWholeRows = tag / (countOfMainoOffsets + 1)
        let rowPosition = tag - numberOfWholeRows * (countOfMainoOffsets + 1)
        let restOfBubbles = basketOfBubbles.count % (countOfMainoOffsets + 1)
        
        
        if tag > basketOfBubbles.count - restOfBubbles - 1 {
            margin = screen.width - mainOffset * CGFloat(restOfBubbles - 1)
        }
        
        let newCenter = CGPoint(x: margin/2 + CGFloat(rowPosition) * mainOffset + littleOffSetX, y: screen.height - CGFloat(numberOfWholeRows) * 100 + littleOffSetY - 100)
        
        return newCenter
    }

}


