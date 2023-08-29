//
//  UIImaveView+Download.swift
//  appSpotify
//
//  Created by user on 24/08/23.
//

import UIKit
extension UIImageView {
    func download(from images: String){
        var url = URL(string: images)!
        
        URLSession.shared.dataTask(with: .init(url: url)){ data, response, error in
            if error != nil { return }
            if let data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                
                
            } else { return }
            
        }.resume()
    }
}
