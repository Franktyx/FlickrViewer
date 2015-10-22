//
//  MyNavController.swift
//  FlickrViewer
//
//  Created by Yuxiang Tang on 10/21/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit

class MyNavController: UINavigationController {
    
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController){
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nil, bundle: nil)
    }

}
