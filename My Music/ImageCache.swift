//
//  ImageCache.swift
//  My Music
//
//  Created by Sinisa Vukovic on 07/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ImageCache {
    
    //Make it singleton
    static let shared = ImageCache()
    private init() {}

    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    //Image Downloading
     func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> Request {
        return Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            completion(image)
            self.cache(image, for: url)
        }
    }
    
    //Image Caching
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    //Return cashed image
    func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
}

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}
