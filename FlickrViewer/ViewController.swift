//
//  ViewController.swift
//  FlickrViewer
//
//  Created by Yuxiang Tang on 10/20/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UISearchBarDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height


    var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0, blue: 113 / 255, alpha: 0.3)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "searchImages:")
        self.navigationController?.navigationBar.topItem?.title = "Flickr Search"
        
        
        
        self.searchBar = UISearchBar(frame: CGRectMake(0, 64, self.screenWidth, 40))
        self.searchBar.placeholder = "Search pictures from Flickr!"
        self.searchBar.delegate = self
        
//        self.searchController = UISearchController(searchResultsController: nil)
//        self.searchController.searchBar.frame = CGRectMake(0, 64, self.screenWidth, 40)
//        self.searchController.searchBar.placeholder = "Search pictures from Flickr!"
//        self.searchController.delegate = self
//        self.searchController.searchBar.delegate = self
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = false
        
//        self.navigationItem.titleView = self.searchController.searchBar
        
        self.view.addSubview(self.searchBar)
        
    
    }
    
    func searchImages(sender: UIButton){
        
        if !self.searchBar.text.isEmpty {
            var searchResultController = ResultViewController()
            searchResultController.searchTerm = self.searchBar.text
            self.searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(searchResultController, animated: true)
        }
    }
    
    func beginSearch(sender: UIButton){
        
        
        
        let flickr: FlickrHelper = FlickrHelper()
        
        if self.searchBar.text != "" {
        
        flickr.searchFlickrForString(self.searchBar.text, completion: { (searchString: String!, flickrPhotos: NSMutableArray!, error:NSError!) -> () in
            
            
            let flickrPhoto:FlickrPhoto = flickrPhotos.objectAtIndex(0) as! FlickrPhoto
            
            let image: UIImage = flickrPhoto.thumbnail
            
            dispatch_async(dispatch_get_main_queue(), {
                
            })
            
        })
        }
        
    
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("begin")
    }
    
//    func willPresentSearchController(searchController: UISearchController) {
//        self.view.addSubview(self.searchController.searchBar)
//    }



}

