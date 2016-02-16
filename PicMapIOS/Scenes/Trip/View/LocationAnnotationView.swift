//
//  LocationAnnotationView.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/15.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import MapKit
import XCGLogger

class LocationAnnotationContent: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
}

/**
 SightAnnotationView
 */
class LocationAnnotationView: MKAnnotationView {
    var contentView: LocationAnnotationContent?;

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        if let wrapperView = UIView.viewFromXib("LocationAnnotationContent") {

            guard let contentView = wrapperView.subviews.first as? LocationAnnotationContent
            else { XCGLogger.error("LocationAnnotationContent.xib does not  contain LocationAnnotationContent")
                return
            }
            self.contentView = contentView
            let fittingSize = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            let frame = self.frame;
            var origin = frame.origin;
            origin.x -= (fittingSize.width - frame.size.width) / 2;
            origin.y -= (fittingSize.height - frame.size.height) / 2;
            self.frame = CGRect(origin: origin, size: fittingSize) ;
            contentView.frame = CGRect(origin: self.bounds.origin, size: fittingSize) ;
            contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            contentView.translatesAutoresizingMaskIntoConstraints = true;
            self.addSubview(contentView)
        }

        self.contentView?.indexLabel.text = "1"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) ;
    }

    override init(frame: CGRect) {
        super.init(frame: frame) ;
    }

    override func prepareForReuse() {
    }

    internal func update() {
        if let annotation = self.annotation as? LocationAnnotation {
            let count = annotation.viewModel.index
            self.contentView?.indexLabel.text = String.init(format: "%d", count)
        }
    }
}