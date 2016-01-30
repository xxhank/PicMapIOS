//
//  PMIViewControllerLink.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/1/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SwiftTryCatch

let PMIViewControllerLinkErrorDomain = "PMIViewControllerLink";

enum PMIViewControllerLinkError : Int {
    case CannotLoadStoryboard = 1
    case CannotInstantiateViewController
    case CannotCreateClass
    case NotSupportSyntax
}


extension String{
    func pmi_emptyAsNil()->String?{
        if self.isEmpty{
            return nil;
        }
        return self;
    }
    func pmi_storyboard()->(storyboardName:String?, controllerName:String?){
        if self.hasPrefix("sb://"){
            let trimedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let components = trimedString.componentsSeparatedByString("/");
            switch components.count{
            case 4: return (components[2].pmi_emptyAsNil(), components[3].pmi_emptyAsNil());
            case 3: return (components[2].pmi_emptyAsNil(), nil);
            default: return (nil,nil);
            }
        }
        return (nil,nil);
    }
    
    func pmi_nibName()->(nibName:String?, controllerName:String?){
        if self.hasPrefix("xib://"){
            let trimedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let components = trimedString.componentsSeparatedByString("/");
            switch components.count{
            case 4: return (components[2].pmi_emptyAsNil(), components[3].pmi_emptyAsNil());
            case 3: return (components[2].pmi_emptyAsNil(), components[2].pmi_emptyAsNil());
            default: return (nil,nil);
            }
        }
        return (nil,nil);
    }
    
    func pmi_className()->String?{
        if self.hasPrefix("code://"){
            let trimedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let components = trimedString.componentsSeparatedByString("/");
            switch components.count{
            case 3: return components[2].pmi_emptyAsNil();
            default: return nil;
            }
        }
        return nil;
    }
    
    func pmi_controllerFromExternalStoryboard(bundle:NSBundle)->(controller:UIViewController?, error:NSError?,storyboard: UIStoryboard?){
        let (storyboardName, controllerName) = self.pmi_storyboard();
        if storyboardName != nil {
            var storyboard:UIStoryboard? = nil
            SwiftTryCatch.tryBlock({
                    storyboard = UIStoryboard(name:storyboardName!, bundle:bundle);
                }, catchBlock: { (error) in
                    // println("\(error.description)")
                }, finallyBlock: {
             })
            
            if storyboard == nil {
                let error = NSError(domain: PMIViewControllerLinkErrorDomain
                    , code: PMIViewControllerLinkError.CannotLoadStoryboard.rawValue
                    , userInfo: nil)
                return(nil, error, nil)
            }
            
            var controller:UIViewController?;
            if controllerName == nil{
                controller = storyboard!.instantiateInitialViewController();
            } else {
                SwiftTryCatch.tryBlock({ () -> Void in
                     controller = storyboard!.instantiateViewControllerWithIdentifier(controllerName!);
                    }, catchBlock: { (exception) -> Void in
                    }, finallyBlock: { () -> Void in
                })
               
            }
            
            if controller == nil {
                let error = NSError(domain: PMIViewControllerLinkErrorDomain
                    , code: PMIViewControllerLinkError.CannotInstantiateViewController.rawValue
                    , userInfo: nil)
                return(nil, error, storyboard)
            }
            return (controller!, nil, storyboard);
        }
        
        return (nil,nil,nil)
    }
    
    func pmi_controllerFromExternalNib(bundle:NSBundle, var module:String? = nil)->(controller:UIViewController?, error:NSError?,storyboard: UIStoryboard?){
        
        
        let (nibName, controllerName) = self.pmi_nibName();
        if nibName != nil {
            if module == nil{
                module = NSStringFromClass(AppDelegate).componentsSeparatedByString(".").first;
            }
            let controllerClassName = "\(module!).\(controllerName!)"
            if let exceptClass = NSClassFromString(controllerClassName) as? UIViewController.Type{
                let controller = exceptClass.init(nibName: nibName, bundle: bundle)
                return (controller, nil, nil)
            } else {
                let error = NSError(domain: PMIViewControllerLinkErrorDomain
                    , code: PMIViewControllerLinkError.CannotInstantiateViewController.rawValue
                    , userInfo: nil)
                return(nil, error, nil)
            }
        }
        
        return (nil,nil,nil)
    }
    
    func pmi_controllerFromCode(bundle:NSBundle, var module:String? = nil)->(controller:UIViewController?, error:NSError?,storyboard: UIStoryboard?){
        let className = self.pmi_className()
        if className != nil {
            if module == nil{
                module = NSStringFromClass(AppDelegate).componentsSeparatedByString(".").first;
            }
            let fullClassName = "\(module!).\(className!)"
            if let exceptClass = NSClassFromString(fullClassName) as? UIViewController.Type{
                let controller = exceptClass.init()
                return (controller, nil, nil)
            }else {
                let error = NSError(domain: PMIViewControllerLinkErrorDomain
                    , code: PMIViewControllerLinkError.CannotCreateClass.rawValue
                    , userInfo: nil)
                return(nil, error, nil)
            }
        }
        
        return (nil,nil,nil)
    }
    
    func pmi_controller(bundle:NSBundle? = nil, module:String? = nil)->(controller:UIViewController?, error:NSError?,storyboard: UIStoryboard?){
        var existBundle = bundle;
        if bundle == nil {
            existBundle = NSBundle.mainBundle();
        }
        
        var (controller, error, storyboard) = pmi_controllerFromExternalStoryboard(existBundle!);
        if controller != nil || error != nil{
            return (controller, error, storyboard);
        }
        
        
        (controller, error, storyboard) = pmi_controllerFromExternalNib(existBundle!, module: module);
        if controller != nil || error != nil{
            return (controller, error, storyboard);
        }
        
        (controller, error, storyboard) = pmi_controllerFromCode(existBundle!, module: module);
        if controller != nil || error != nil{
            return (controller, error, storyboard);
        }
        
        let notSupportError = NSError(domain: PMIViewControllerLinkErrorDomain
            , code: PMIViewControllerLinkError.NotSupportSyntax.rawValue
            , userInfo: nil)
        return( nil, notSupportError, nil)
    }
}

class PMIViewControllerLink: UIViewController {
    
    /// 连接的外部资源, 支持的语法格式:
    /// - sb://storyboardName/controllerID
    /// - xib://NibName/ControllerClass
    /// - code://ClassName
    @IBInspectable var externalResource : String = "";
}
