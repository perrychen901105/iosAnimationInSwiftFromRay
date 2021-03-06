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

// A delay function
func delay(#seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

func tintBackgroundColor(#layer: CALayer, toColor: UIColor) {
    let colorAni = CABasicAnimation(keyPath: "backgroundColor")
    colorAni.fromValue = layer.backgroundColor
    colorAni.toValue = toColor.CGColor
    colorAni.duration = 1.0
    layer.addAnimation(colorAni, forKey: nil)
    layer.backgroundColor = toColor.CGColor
}

func roundCorners(#layer: CALayer, #toRadius: CGFloat)
{
    let CornerAni = CABasicAnimation(keyPath: "cornerRadius")
    CornerAni.toValue = toRadius
    CornerAni.duration = 0.33
    layer.addAnimation(CornerAni, forKey: nil)
    layer.cornerRadius = toRadius
}

class ViewController: UIViewController {
  
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
    let info = UILabel()
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zeroPoint
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.hidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .Center
    status.addSubview(label)
    
    statusPosition = status.center
    
    info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.size.width, height: 30)
    info.backgroundColor = UIColor.clearColor()
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .Center
    info.textColor = UIColor.whiteColor()
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
//    heading.center.x  -= view.bounds.width
//    username.center.x -= view.bounds.width
//    password.center.x -= view.bounds.width

    username.layer.position.x -= view.bounds.width
    password.layer.position.x -= view.bounds.width
    
//    cloud1.alpha = 0.0
//    cloud2.alpha = 0.0
//    cloud3.alpha = 0.0
//    cloud4.alpha = 0.0

    let fadeCloud = CABasicAnimation(keyPath: "opacity")
    fadeCloud.fromValue = 0.0
    fadeCloud.toValue = 1.0
    fadeCloud.duration = 0.5

    fadeCloud.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.addAnimation(fadeCloud, forKey: nil)
    
    fadeCloud.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.addAnimation(fadeCloud, forKey: nil)
    
    fadeCloud.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.addAnimation(fadeCloud, forKey: nil)
    
    fadeCloud.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.addAnimation(fadeCloud, forKey: nil)
    
    loginButton.center.y += 30.0
    loginButton.alpha = 0.0
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2
    flyRight.duration = 0.5
    flyRight.fillMode = kCAFillModeBoth
//    flyRight.removedOnCompletion = false
    flyRight.delegate = self
    flyRight.setValue("form", forKey: "name")
    flyRight.setValue(heading.layer, forKey: "layer")
    
    heading.layer.addAnimation(flyRight, forKey: nil)
//    UIView.animateWithDuration(0.5, animations: {
//      self.heading.center.x += self.view.bounds.width
//    })
    

    flyRight.beginTime = CACurrentMediaTime() + 0.3
    flyRight.setValue(username.layer, forKey: "layer")
    username.layer.addAnimation(flyRight, forKey: nil)
    username.layer.position.x = view.bounds.size.width / 2
//    UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: nil, animations: {
//      self.username.center.x += self.view.bounds.width
//    }, completion: nil)

    flyRight.beginTime = CACurrentMediaTime() + 0.4
    flyRight.setValue(password.layer, forKey: "layer")
    password.layer.addAnimation(flyRight, forKey: nil)
    password.layer.position.x = view.bounds.size.width / 2
//    UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: nil, animations: {
//      self.password.center.x += self.view.bounds.width
//    }, completion: nil)

//    UIView.animateWithDuration(0.5, delay: 0.5, options: nil, animations: {
//      self.cloud1.alpha = 1.0
//    }, completion: nil)
    
//    UIView.animateWithDuration(0.5, delay: 0.5, options: nil, animations: {
//      self.cloud1.alpha = 1.0
//    }, completion: nil)
    
//    UIView.animateWithDuration(0.5, delay: 0.7, options: nil, animations: {
//      self.cloud2.alpha = 1.0
//    }, completion: nil)
//    
//    UIView.animateWithDuration(0.5, delay: 0.9, options: nil, animations: {
//      self.cloud3.alpha = 1.0
//    }, completion: nil)
//    
//    UIView.animateWithDuration(0.5, delay: 1.1, options: nil, animations: {
//      self.cloud4.alpha = 1.0
//    }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: nil, animations: {
        self.loginButton.center.y -= 30.0
        self.loginButton.alpha = 1.0
    }, completion: nil)

    animateCloud(cloud1.layer)
    animateCloud(cloud2.layer)
    animateCloud(cloud3.layer)
    animateCloud(cloud4.layer)
    
    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x + view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    info.layer.addAnimation(flyLeft, forKey: "infoappear")
    
    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.addAnimation(fadeLabelIn, forKey: "fadein")
    
    username.delegate = self
    password.delegate = self
    
  }
  
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        println("animation did finish")
        if let name = anim.valueForKey("name") as? String {
            if name == "form" {
                let layer = anim.valueForKey("layer") as? CALayer
                anim.setValue(nil, forKey: "layer")
                
                let pulse = CABasicAnimation(keyPath: "transform.scale")
                pulse.fromValue = 1.25
                pulse.toValue = 1.0
                pulse.duration = 0.25
                layer?.addAnimation(pulse, forKey: nil)
            }
            if name == "cloud" {
                if let layer = anim.valueForKey("layer") as? CALayer {
                    anim.setValue(nil, forKey: "layer")
                    
                    layer.position.x = -layer.bounds.width/2
                    delay(seconds: 0.5, {
                        self.animateCloud(layer)
                    })
                    
                }
               

            }
        }
    }
    
  // MARK: further methods
  
  @IBAction func login() {

    UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.bounds.size.width += 80.0
    }, completion: nil)

    UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.center.y += 60.0
//      self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
      
      self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1.0

    }, completion: {_ in
      self.showMessage(index: 0)
    })
    
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, tintColor)
    
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
  }

  func showMessage(#index: Int) {
    label.text = messages[index]
    
    UIView.transitionWithView(status, duration: 0.33, options:
      .CurveEaseOut | .TransitionFlipFromBottom, animations: {
        self.status.hidden = false
      }, completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
    })
  }

  func removeMessage(#index: Int) {
    UIView.animateWithDuration(0.33, delay: 0.0, options: nil, animations: {
      self.status.center.x += self.view.frame.size.width
    }, completion: {_ in
      self.status.hidden = true
      self.status.center = self.statusPosition
      
      self.showMessage(index: index+1)
    })
  }

  func resetForm() {
    UIView.transitionWithView(status, duration: 0.2, options: .TransitionFlipFromTop, animations: {
      self.status.hidden = true
      self.status.center = self.statusPosition
    }, completion: nil)
    
    UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
//      self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
        }, completion: { _ in
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            tintBackgroundColor(layer: self.loginButton.layer, tintColor);
            roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    })
  }
  
    func animateCloud(layer: CALayer) {

    // 1
    let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: NSTimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        
        // 2
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width/2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        
        layer.addAnimation(cloudMove, forKey: nil)
    
//    let cloudSpeed = 60.0 / view.frame.size.width
//    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
//    UIView.animateWithDuration(NSTimeInterval(duration), delay: 0.0, options: .CurveLinear, animations: {
//      cloud.frame.origin.x = self.view.frame.size.width
//    }, completion: {_ in
//      cloud.frame.origin.x = -cloud.frame.size.width
//      self.animateCloud(cloud)
//    })
  }
  
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        println(info.layer.animationKeys())
        info.layer.removeAnimationForKey("infoappear")
    }
}

