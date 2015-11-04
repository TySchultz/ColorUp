//
//  ViewController.swift
//  ColorUp
//
//  Created by Ty Schultz on 10/18/14.
//  Copyright (c) 2014 Ty Schultz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameBrainProtocol{
    
    let left  = 0
    let right = 1
    
    var taps = 0
    var timer = NSTimer()
    var timeLeft = 30.0

    var model: GameBrain?
    let startButton =  UIButton()
    let gameOverButton =  UIButton()
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight  = UIScreen.mainScreen().bounds.height
    let screenRatio: CGFloat = 10
    let menuSize: CGFloat = 8
    let menuHeight: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = GameBrain(correctSide: left, delegate: self)
        
        rightButton.enabled = false
        leftButton.enabled = false
        
        
        rightButton.backgroundColor = UIColor.blueColor()
        leftButton.backgroundColor  = UIColor.redColor()
        
        
        
//        startButton.frame = CGRectMake(0, 0, 320, 40)
//        startButton.backgroundColor = UIColor.whiteColor()
//        startButton.setTitle("Start", forState: UIControlState.Normal)
//        startButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        startButton.addTarget(self, action: "startGame", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(startButton)
        
        gameOverButton.frame = CGRectMake(0, 200, screenWidth, 80)
        gameOverButton.backgroundColor = UIColor.whiteColor()
        gameOverButton.setTitle("Start", forState: UIControlState.Normal)
        gameOverButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        gameOverButton.addTarget(self, action: "startGame", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(gameOverButton)
        
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimer (){
        timeLeft -= 0.1
        
        tapsLabel.text = NSString(format: "%.1f", timeLeft) as String

        if timeLeft <= 0 {
            gameOver()
        }
    }
    
    func startGame () {

        rightButton.enabled = true
        leftButton.enabled  = true
        
        taps = 0
        timeLeft = 15.0
        model?.increaseScore(correctSide: 0)
        
        createColors()
        

        
        let basicAnimation = POPSpringAnimation()
        basicAnimation.property            = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as! POPAnimatableProperty//[POPAnimatableProperty propertyWithName:kPOPViewFrame];
        basicAnimation.toValue             = NSValue(CGRect:CGRectMake(screenWidth/screenRatio, screenHeight+100, menuSize*(screenWidth/screenRatio), 4*(screenHeight/8)))
        basicAnimation.springBounciness    = 12.0;
        basicAnimation.delegate            = self;
        gameOverButton.pop_addAnimation(basicAnimation, forKey: "basic")

  
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)

        
    }
    
    func gameOver () {
        self.view.addSubview(gameOverButton)
        
        tapsLabel.text = ""
        
        gameOverButton.frame = CGRectMake(screenWidth/screenRatio, -4*(screenHeight/8), menuSize*(screenWidth/screenRatio), 300)
        
        let basicAnimation = POPSpringAnimation()
        basicAnimation.property            = POPAnimatableProperty.propertyWithName(kPOPViewFrame) as! POPAnimatableProperty//[POPAnimatableProperty propertyWithName:kPOPViewFrame];
        basicAnimation.toValue             = NSValue(CGRect:CGRectMake(screenWidth/screenRatio, 2*(screenHeight/8), menuSize*(screenWidth/screenRatio), 4*(screenHeight/8)))
        basicAnimation.springBounciness    = 12.0;
        basicAnimation.delegate            = self;
        gameOverButton.pop_addAnimation(basicAnimation, forKey: "basic")
        
        rightButton.enabled = false
        leftButton.enabled = false
        timer.invalidate()
    
    }
    
    @IBOutlet weak var tapsLabel: UILabel!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!

    
    @IBAction func buttonReleased(sender: UIButton) {
        taps += 1
//        tapsLabel.text = String(taps)
        if sender.tag == model?.correctSide{
            createColors()
        }else{
            gameOver()
        }
    }
    
    func createColors() {
        let startSide = arc4random() % 2
        
        let hue =  CGFloat(arc4random() % 256) / 256
        let saturation = CGFloat((arc4random() % 128) / 256) + 0.5
        var brightness = CGFloat(arc4random() % 128 / 256 ) + 0.7
        let color1 = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        
        brightness += 0.2
        
        let color2 = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)

        if startSide == 0 {
            changeColors(colorRight: color1, colorLeft: color2)
            model?.increaseScore(correctSide: 0)
        }else{
            changeColors(colorRight: color2, colorLeft: color1)
            model?.increaseScore(correctSide: 1)
        }
    }
    
    func changeColors(colorRight color1 : UIColor, colorLeft color2 : UIColor)  {
        rightButton.backgroundColor = color1
        leftButton.backgroundColor = color2
    }
}

