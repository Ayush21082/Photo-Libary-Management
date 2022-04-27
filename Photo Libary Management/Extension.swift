//
//  Extension.swift
//  Photo Libary Management
//
//  Created by Ayush Singh on 27/04/22.
//

import Foundation
import UIKit
import Photos

var myAlbum = [Int]()
var timeData = [String]()
var images = [UIImage]()
var albumImages = [UIImage]()

extension UIImageView{
 func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.version = .original
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
        guard let image = image else { return }
        switch contentMode {
        case .aspectFill:
            self.contentMode = .scaleAspectFill
        case .aspectFit:
            self.contentMode = .scaleAspectFit
        @unknown default:
            self.contentMode = .scaleAspectFit
        }
        self.image = image
    }
   }
}

