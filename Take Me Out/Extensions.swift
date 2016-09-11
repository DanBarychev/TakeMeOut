//
//  Extensions.swift
//  Take Me Out
//
//  Created by Daniel Barychev on 9/10/16.
//
//

import UIKit

let imageCache = NSCache()

extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        //Some whitespace before the image downloads
        self.image = nil
        
        //See if the cache has an image
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //Otherwise
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
                
            //Image download was successful
            else {
                print("Successful Image Download")
                dispatch_async(dispatch_get_main_queue(), {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString)
                        self.image = downloadedImage
                    }
                })
            }
        }).resume()
    }
}

