//
//  ViewController.swift
//  Poker
//
//  Created by Edward Yun on 11/4/15.
//  Copyright © 2015 Edward Yun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let dealSegueId = "dealSegue"
    
    var numberOfPlayres:Int = 2
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        numberOfPlayres = Int(sender.value)
        playersLabel.text = "\(numberOfPlayres) Players"
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == dealSegueId {
            
            let svc = segue.destinationViewController as! HostHandViewController
            svc.numberOfPlayers = numberOfPlayres
            
        }
    }


}

