//
//  ResultCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Yuxiang Tang on 10/21/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height

    
    var imageView: UIImageView!
    var imageOffset: CGPoint!
    var image: UIImage! {
        get{
            return self.image
        }
        
        set {
            self.imageView.image = newValue
            
            if self.imageOffset != nil {
                setupImageOffset(imageOffset)
            }else {
                setupImageOffset(CGPointMake(0, 0))
            }
        }
    }

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupImageView()
    }
    
    override init(frame: CGRect){
        super.init(frame:frame)
        self.backgroundColor = UIColor.lightGrayColor()
        setupImageView()
    }
    
    func setupImageView(){
        self.clipsToBounds = true
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.screenWidth, 200))
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.clipsToBounds = false
        self.addSubview(self.imageView)
        
    }
    
    func setupImageOffset(imageOffset: CGPoint){
        self.imageOffset = imageOffset
        let frame = imageView.bounds
        let offsetFrame = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        self.imageView.frame = offsetFrame
    }
}
