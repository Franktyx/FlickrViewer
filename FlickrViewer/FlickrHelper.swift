//
//  FlickrHelper.swift
//  FlickrViewer
//
//  Created by Yuxiang Tang on 10/20/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit
import Foundation

class FlickrHelper: NSObject {
    
    class func URLForSearchString (searchString: String) -> String {
        let apiKey: String = "408a91aa92d7b3bc8bc16d45879bccf3"
        let search: String = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=100&format=json&nojsoncallback=1"
        
    }
    
    class func URLForFlickrPhoto(photo: FlickrPhoto, size: String) -> String {
        var _size: String = size
        
        if _size.isEmpty {
            _size = "b"
        }
        //require farm, server, photoID, secret to retrieve a photo
        return "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.photoID)_\(photo.secret)_\(_size).jpg"
        
    }
    
    
    func searchFlickrForString(searchStr: String, completion:(searchString: String!, flickrPhotos: NSMutableArray!, error: NSError!)->()){
        
        let searchURL: String = FlickrHelper.URLForSearchString(searchStr)
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, {
            var error: NSError?
            
            let searchResultString: String! = String(contentsOfURL: NSURL(string: searchURL)!, encoding: NSUTF8StringEncoding, error: &error)
            
        
            
            if error != nil {
                completion(searchString: searchStr, flickrPhotos: nil, error: error)
            } else {
                //Parse JSON Response
                let jsonData: NSData! = searchResultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                let resultDict: NSDictionary! = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as! NSDictionary
                println(resultDict)
                
                if error != nil {
                    completion(searchString: searchStr, flickrPhotos: nil, error: error)
                } else {
                    let status: String = resultDict.objectForKey("stat") as! String
                    
                    if status == "fail" {
                    
                        let error: NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultDict.objectForKey("message")!])
                        completion(searchString: searchStr, flickrPhotos: nil, error: error)
                    }else {
                        let resultArrary: NSArray = resultDict.objectForKey("photos")!.objectForKey("photo") as! NSArray
                        
                        let flickrPhotos:NSMutableArray = NSMutableArray()
                        
                        for photoObject in resultArrary {
                            let photoDict:NSDictionary = photoObject as! NSDictionary
                            println(photoDict)
                            var flickrPhoto:FlickrPhoto = FlickrPhoto()
                            flickrPhoto.farm = photoDict.objectForKey("farm") as! Int
                            flickrPhoto.server = photoDict.objectForKey("server") as! String
                            flickrPhoto.secret = photoDict.objectForKey("secret") as! String
                            flickrPhoto.photoID = photoDict.objectForKey("id") as! String
                            
                            let searchURL: String = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "b")
                            //download picture
//                            let imageData:NSData = NSData(contentsOfURL: NSURL(string: searchURL)!, options: nil, error: &error)!
//                            
//                            var image: UIImage? = UIImage(data: imageData)
//                            if image != nil {
//                                flickrPhoto.thumbnail = image
//                            }
                            flickrPhotos.addObject(searchURL)
                            
                         }
                        completion(searchString: searchStr, flickrPhotos: flickrPhotos, error: nil)
                        
                    }
                }
                
            }
         
        })
        
        
    }
    
    
}
