//
//  ExtensionUIImageView.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 9/29/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    /*
     * Created by: hoangnn
     * Description: Set image from url (AlamofireImage)
     */
    func setImageForm(urlString: String?, placeHolderImage: UIImage?, completion: (() -> Void)? = nil) {
        if urlString != nil {
            if let urlImage: URL = URL(string: urlString!) {
                self.af_setImage(withURL: urlImage, placeholderImage: placeHolderImage, completion: { (response: DataResponse<UIImage>) in
                    if response.result.value != nil {
                        self.image = response.result.value
                    }
                    else {
                        self.image = placeHolderImage
                    }

                    // Check cancel error
                    if let errorImage: AlamofireImage.AFIError = response.result.error as? AlamofireImage.AFIError {
                        if errorImage.isRequestCancelledError == false {
                            completion?()
                        }
                    }
                    else {
                        completion?()
                    }
                })
            }
            else {
                self.image = placeHolderImage
                completion?()
            }
        }
        else {
            self.image = placeHolderImage
            completion?()
        }
    }
}
