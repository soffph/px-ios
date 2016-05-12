//
//  LoadingOverlay.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 29/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class LoadingOverlay {
    
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    init(){
        
    }
    
    public func getLoadingOverlay(view : UIView) -> UIView {
        self.activityIndicator.frame = CGRectMake(0, 0, 20, 20)
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.activityIndicator.color = UIColor().blueMercadoPago()
        
        
        self.container.frame = view.frame
        self.container.backgroundColor = UIColor().backgroundColor()
        self.container.center = view.center
        self.activityIndicator.center = view.center
        self.container.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        return container
    }
    
    public func showOverlay(view: UIView) {
        
        view.addSubview(self.getLoadingOverlay(view))
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}