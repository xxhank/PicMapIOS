//
//  MKAnnotationView+SightAnnotationView.swift
//  Memo
//
//  Created by wangchaojs02 on 15/10/27.
//  Copyright © 2015年 wangchaojs02. All rights reserved.
//

import MapKit
import Haneke
import FBAnnotationClustering
import XCGLogger

class SightAnnotationContent: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var badgeLabel: MPLabel!
}

/**
 SightAnnotationView
 */
class SightAnnotationView: MKAnnotationView {
    var contentView: SightAnnotationContent?;

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        if let wrapperView = UIView.viewFromXib("SightAnnotationContent") {
            if let contentView = wrapperView.subviews.first as? SightAnnotationContent {
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
        }
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
        if let annotation = self.annotation as? SightAnnotation {
            let count = annotation.viewModel.imageCount
            self.contentView?.badgeLabel.text = String.init(format: "%d", count)
            guard let urlString = annotation.viewModel.thumbnail else { return }
            if let url = NSURL(string: urlString) {
                self.contentView?.imageView.hnk_setImageFromURL(url)
            }
        } else if let clusterAnnotation = self.annotation as? FBAnnotationCluster {
            var count: UInt = 0;
            clusterAnnotation.annotations.forEach({ (annotation) -> () in
                if let annotation = annotation as? SightAnnotation {
                    count += annotation.viewModel.imageCount
                }
            })

            let annotation = clusterAnnotation.annotations.first as! SightAnnotation

            self.contentView?.badgeLabel.text = String.init(format: "%d", count)
            guard let urlString = annotation.viewModel.thumbnail else { return }
            if let url = NSURL(string: urlString) {
                self.contentView?.imageView.hnk_setImageFromURL(url)
            }
        } else {
        }
    }
}