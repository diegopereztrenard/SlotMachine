//
//  ViewController.swift
//  SlotMachine
//
//  Created by Diego Perez on 2/8/15.
//  Copyright (c) 2015 Diego Perez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Containers
    
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    //Information Labels
    
    var creditLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    
    var creditsTitleLable: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    // Buttons in fourth container
    
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    //Top Container
    
    var titleLabel: UILabel!
    
    //Slots Array
    
    var slots:[[Slot]] = []
    
    //Stats
    
    var credits:Int = 0
    var currentbet:Int = 0
    var winning:Int = 0
    
    
    //Constants
    
    let kMarginForView:CGFloat = 10.0
    let kSixth:CGFloat = 1.0/6.0
    let kThird:CGFloat = 1.0/3.0
    let kMarginForSlot:CGFloat = 2.0
    let kHalf:CGFloat = 1.0/2.0
    let kEighth:CGFloat = 1.0/8.0
    
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupContainerViews()
        
        setupFirstContainer(self.firstContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        
        hardReset()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBActions
    
    func resetButtonPressed(button: UIButton){
    
        hardReset()
    
    }
    
    func betOneButtonPressed(button: UIButton){
    
        if credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        }
        else{
            if currentbet < 5 {
                currentbet += 1
                credits -= 1
                updateMainView()
            }
            else{
                showAlertWithText(message: "You can only bet 5 credits at the time")
            }
        }
    }
    
    func betMaxButtonPressed(button: UIButton){
        
        if credits < 5 {
            showAlertWithText(header: "Not enough credits", message: "Bet less")
        }
        else{
            if currentbet < 5{
                credits -= 5 - currentbet
                currentbet = 5
                updateMainView()
            }
            else{
                showAlertWithText(message: "You can only bet 5 credits at the time")
            }
        }
        
    }
    
    func spinButtonPressed(button: UIButton){
        
        removeSlotsImageViews()
        slots = Factory.createSlots()
        setupSecondContainer(self.secondContainer)
        
        var winningMultiplier = SlotBrain.computeWinnings(slots)
        winning = winningMultiplier * currentbet
        credits += winning
        currentbet = 0
        
        updateMainView()
        
    }
    

    func setupContainerViews(){
        
        self.firstContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
        
        self.secondContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.firstContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)
        
        self.thirdContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, firstContainer.frame.height + secondContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, self.view.bounds.width - (kMarginForView * 2), self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.fourthContainer)
    
    }
    
    func setupFirstContainer(containerView: UIView){
    
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        
        containerView.addSubview(self.titleLabel)
        
    }
    
    func setupSecondContainer(containerView: UIView){
        
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber{
            for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber{
                
                var slot:Slot
                var slotImageView = UIImageView()
                
                if slots.count != 0 {
                    let slotcontainer = slots[containerNumber]
                    slot = slotcontainer[slotNumber]
                    slotImageView.image = slot.image
                
                }
                
                else{
                    slotImageView.image = UIImage(named: "Ace")
                    
                
                }
                    slotImageView.frame = CGRectMake(containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * kThird), containerView.bounds.width * kThird - kMarginForSlot, containerView.bounds.height * kThird - kMarginForSlot)
                    containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setupThirdContainer(containerView: UIView){
    
        self.creditLabel = UILabel()
        self.creditLabel.text = "000000"
        self.creditLabel.textColor = UIColor.redColor()
        self.creditLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditLabel.sizeToFit()
        self.creditLabel.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird)
        self.creditLabel.textAlignment = NSTextAlignment.Center
        self.creditLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.creditLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPointMake(containerView.frame.width * kSixth * 5, containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.winnerPaidLabel)
        
        self.creditsTitleLable = UILabel()
        self.creditsTitleLable.text = "Credits"
        self.creditsTitleLable.textColor = UIColor.blackColor()
        self.creditsTitleLable.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.creditsTitleLable.sizeToFit()
        self.creditsTitleLable.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird * 2)
        containerView.addSubview(creditsTitleLable)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird * 2)
        containerView.addSubview(betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPointMake(containerView.frame.width * kSixth * 5, containerView.frame.height * kThird * 2)
        containerView.addSubview(winnerPaidTitleLabel)
        
    
    }
    
    func setupFourthContainer(containerView: UIView){
    
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPointMake(containerView.frame.width * kEighth, containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPointMake(containerView.frame.width * 3 * kEighth, containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.greenColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPointMake(containerView.frame.width * 5 * kEighth, containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPointMake(containerView.frame.width * 7 * kEighth, containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(spinButton)
    
    }
   
    //Helpers
    
    func removeSlotsImageViews() {
    
        if self.secondContainer != nil {
            let container: UIView? = self.secondContainer!
            let subViews:Array? = container!.subviews
            
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeSlotsImageViews()
        slots.removeAll(keepCapacity: true)
        self.setupSecondContainer(self.secondContainer)
        credits = 50
        winning = 0
        currentbet = 0
        
        updateMainView()
        
    }
    
    func updateMainView() {
        self.creditLabel.text = "\(credits)"
        self.betLabel.text = "\(currentbet)"
        self.winnerPaidLabel.text = "\(winning)"
    
    }
    
    func showAlertWithText (header: String = "Warning", message: String){
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

