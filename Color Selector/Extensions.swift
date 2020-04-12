//
//  Extensions.swift
//  Color Selector
//
//  Created by Yuriy Balabin on 12.04.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

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
