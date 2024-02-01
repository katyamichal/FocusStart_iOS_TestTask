//
//  FileNSTextAttachment + size.swift
//  FocusStart_iOS_TestTask
//
//  Created by Catarina Polakowsky on 01.02.2024.
//

import UIKit

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
