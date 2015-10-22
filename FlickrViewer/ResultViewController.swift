//
//  ResultViewController.swift
//  FlickrViewer
//
//  Created by Yuxiang Tang on 10/21/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var mainCollectionView: UICollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var identifier = "cell"
    
    var searchTerm: String!
    var flickrResults: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewFlowLayout.minimumInteritemSpacing = 10
        
        
        
        self.mainCollectionView = UICollectionView(frame: CGRectMake(0, 0, self.screenWidth, self.screenHeight), collectionViewLayout: collectionViewFlowLayout)
        self.mainCollectionView.backgroundColor = UIColor.whiteColor()
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
        self.mainCollectionView.registerClass(ResultCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.identifier)
        self.view.addSubview(self.mainCollectionView)
        
        loadPhotos()
    }
    
    func loadPhotos(){
        let flickrHelper = FlickrHelper()
        
        flickrHelper.searchFlickrForString(searchTerm, completion: { (searchString, flickrPhotos, error) -> () in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {()-> Void in
                    
                    self.flickrResults = flickrPhotos
                    self.mainCollectionView.reloadData()
                
                })
            }
        })
    
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identifier, forIndexPath: indexPath) as! ResultCollectionViewCell
        cell.image = nil
        
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, { ()-> Void in
            
            var error: NSError?
            
            let searchURL: String = self.flickrResults.objectAtIndex(indexPath.item) as! String
            
            let imageData: NSData = NSData(contentsOfURL: NSURL(string: searchURL)!, options: nil, error: &error)!
            
            if error == nil {
                let image = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.image = image
                    
                    let yOffset = ((self.mainCollectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
                    cell.imageOffset = CGPointMake(0, yOffset)
                
                })
            }
            
        })
        
        return cell
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flickrResults.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let myLayout = collectionViewLayout as! UICollectionViewFlowLayout
        return CGSizeMake(self.screenWidth, 200)
    
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for cell in self.mainCollectionView.visibleCells() {
            var cell = cell as! ResultCollectionViewCell
            let yOffset = ((self.mainCollectionView.contentOffset.y - cell.frame.origin.y)  / 200 ) * 25
            
            cell.setupImageOffset(CGPointMake(0, yOffset))
        }
    }
    
}
