/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

//
// Util delay function
//
func delay(#seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK: view controller methods
  
    enum AnimationDirection: Int {
        case Positive = 1
        case Negative = -1
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: CGRectOffset(view.frame, 0, 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    //start rotating the flights
    changeFlightDataTo(londonToParis)
  }
  
  //MARK: custom methods
  
    func cubeTransition(#label: UILabel, text: String, direction: AnimationDirection) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = UIColor.clearColor()
        
        let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
        auxLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0.0, auxLabelOffset))
        
        label.superview!.addSubview(auxLabel)
    
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            auxLabel.transform = CGAffineTransformIdentity
            label.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0.0, -auxLabelOffset))
        }) { _ in
            label.text = auxLabel.text
            label.transform = CGAffineTransformIdentity
            
            auxLabel.removeFromSuperview()
        }
    
    
    }
    
    func changeFlightDataTo(data: FlightData, animated: Bool = false) {
    
    // populate the UI with the next flight's data
   
        if animated {
            planeDepart()
            summarySwitchTo(data.summary as String);
            fadeImageView(bgImageView, toImage: UIImage(named: data.weatherImageName as String)!, showEffects: data.showWeatherEffects)
            let direction: AnimationDirection = data.isTakingOff ? .Positive : .Negative
            
            cubeTransition(label: flightNr, text: data.flightNr as String, direction: direction)
            cubeTransition(label: gateNr, text: data.gateNr as String, direction: direction)
            
            let offsetDeparting = CGPoint(
                x: CGFloat(direction.rawValue * 80),
                    y:0.0)
            moveLabel(departingFrom, text: data.departingFrom as String, offset: offsetDeparting)
            let offsetArriving = CGPoint(x: 0.0, y: CGFloat(direction.rawValue * 50))
            moveLabel(arrivingTo, text: data.arrivingTo as String, offset: offsetArriving)
        } else {
            summary.text = data.summary as String
            flightNr.text = data.flightNr as String
            gateNr.text = data.gateNr as String
            departingFrom.text = data.departingFrom as String
            arrivingTo.text = data.arrivingTo as String
            flightStatus.text = data.flightStatus as String
            bgImageView.image = UIImage(named: data.weatherImageName as String)
            snowView.hidden = !data.showWeatherEffects
            let direction: AnimationDirection = data.isTakingOff ? .Positive : .Negative
            cubeTransition(label: flightNr, text: data.flightNr as String, direction: direction)
            cubeTransition(label: gateNr, text: data.gateNr as String, direction: direction)
        }
        
        
        
    // schedule next flight
    delay(seconds: 3.0) {
        self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis, animated: true)
    }
  }
  
    /**
    
    :param: imageView   going to fade out
    :param: toImage     the new image you want visible at the end of the animation
    :param: showEffects indicating whether the scene should show or hide the snowfall effect.
    */
    func fadeImageView(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        UIView.transitionWithView(imageView, duration: 1.0, options: .TransitionCrossDissolve, animations: { () -> Void in
            imageView.image = toImage
        }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.snowView.alpha = showEffects ? 1.0 : 0.0
        }, completion: nil)
    }
    
    func planeDepart() {
        let originalCenter = planeImage.center
        
        UIView.animateKeyframesWithDuration(1.5, delay: 0.0, options: nil, animations: { () -> Void in
            // add key frames
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: { () -> Void in
                self.planeImage.center.x += 80.0
                self.planeImage.center.y -= 10.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.4, animations: { () -> Void in
                self.planeImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2))
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.25, animations: { () -> Void in
                self.planeImage.center.x += 100.0
                self.planeImage.center.y -= 50.0
                self.planeImage.alpha = 0.0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.51, relativeDuration: 0.01, animations: { () -> Void in
                self.planeImage.transform = CGAffineTransformIdentity
                self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.45, animations: { () -> Void in
                self.planeImage.alpha = 1.0
                self.planeImage.center = originalCenter
            })
        }, completion: nil)
    }
    
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = UIColor.clearColor()
        
        auxLabel.transform = CGAffineTransformMakeTranslation(offset.x, offset.y)
        auxLabel.alpha = 0
        view.addSubview(auxLabel)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            label.transform = CGAffineTransformMakeTranslation(offset.x, offset.y)
            label.alpha = 0.0
        }, completion: nil)
        
        UIView.animateWithDuration(0.25, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
            auxLabel.transform = CGAffineTransformIdentity
            auxLabel.alpha = 1.0
        }) { _ in
            // clean up
            auxLabel.removeFromSuperview()
            
            label.text = text
            label.alpha = 1.0
            label.transform = CGAffineTransformIdentity
        }
    }
  
    func summarySwitchTo(summaryText: String) {
        let originSummaryPosition = summary.center
        UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.45, animations: { () -> Void in
                self.summary.center.y -= 100.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.45, animations: { () -> Void in
                self.summary.center.y += 100.0
            })
        }) { _ in
            
        }
        
        delay(seconds: 0.5) { () -> () in
            self.summary.text = summaryText
        }
        
    }
    
}