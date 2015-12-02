//
//  CardView.swift
//  Poker
//
//  Created by Edward Yun on 12/1/15.
//  Copyright © 2015 Edward Yun. All rights reserved.
//

import UIKit

class OtherCardView: UIView {
    
    var view: UIView!
    
    //MARK: Outlets
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topCornerLabel: UILabel!
    @IBOutlet weak var topCornerImageView: UIImageView!
    
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        
        

        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CardView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
        
    }
    
    
    //MARK: Make Cards
    func loadCard(rank: String, suit: String) {
        
        //        topImageView.image = UIImage(named: "Hearts")
        //        bottomImageView.image = UIImage(named: "Hearts")
        //        topCornerImageView.image = UIImage(named: "Hearts")
        //
        //        centerLabel.text = rank
        //        topCornerLabel.text = rank
        
    }
    
}
