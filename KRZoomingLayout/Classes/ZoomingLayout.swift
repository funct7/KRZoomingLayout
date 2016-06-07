//
//  ZoomingLayout.swift
//  ZoomingLayout
//
//  Created by Joshua Park on 6/1/16.
//  Copyright © 2016 Knowre. All rights reserved.
//

import UIKit

private var Screen: UIScreen {
    return UIScreen.mainScreen()
}

class ZoomingLayout: UICollectionViewFlowLayout {
    
    var zoomScale: CGFloat = 1.25
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        assert(zoomScale > 1.0, "Zoom scale for layout must be greater than 1.0.")
        
        var arrAttribs = [UICollectionViewLayoutAttributes]()
        let itemMeasure = scrollDirection == .Vertical ? itemSize.height : itemSize.width
        let contentOffset = scrollDirection == .Vertical ? collectionView!.contentOffset.y + collectionView!.contentInset.top : collectionView!.contentOffset.x + collectionView!.contentInset.left
        let screenCenter = contentOffset + itemMeasure / 2.0
        
        for attribs in super.layoutAttributesForElementsInRect(rect)! {
            let cellCenter = scrollDirection == .Vertical ? attribs.center.y : attribs.center.x
            
            if contentOffset < cellCenter && cellCenter < contentOffset + itemMeasure {
                let scale = 1.0 + (zoomScale - 1.0) * (1 - abs(screenCenter - cellCenter) / (itemMeasure / 2.0))
                attribs.transform = CGAffineTransformMakeScale(scale, scale)
            } else {
                attribs.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            arrAttribs.append(attribs)
        }
        
        return arrAttribs
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var contentOffset = proposedContentOffset
        let inset = scrollDirection == .Vertical ? collectionView!.contentInset.top : collectionView!.contentInset.left
        let absVelocity = scrollDirection == .Vertical ? abs(velocity.y) : abs(velocity.x)
        let fullItemMeasure = scrollDirection == .Vertical ? itemSize.height + minimumLineSpacing : itemSize.width + minimumInteritemSpacing
        
        switch absVelocity {
        case 0.0 ..< 0.2:
            let current = scrollDirection == .Vertical ? collectionView!.contentOffset.y : collectionView!.contentOffset.x
            let remainder = (current + inset) % fullItemMeasure
            if scrollDirection == .Vertical {
                contentOffset.y = remainder < fullItemMeasure / 2.0 ? current - remainder : current + (fullItemMeasure - remainder)
            } else {
                contentOffset.x = remainder < fullItemMeasure / 2.0 ? current - remainder : current + (fullItemMeasure - remainder)
            }
        case 0.2 ..< 2.0:
            let current = scrollDirection == .Vertical ? collectionView!.contentOffset.y : collectionView!.contentOffset.x
            let remainder = (current + inset) % fullItemMeasure
            if scrollDirection == .Vertical {
                contentOffset.y = velocity.y < 0.0 ? current - remainder : current + (fullItemMeasure - remainder)
            } else {
                contentOffset.x = velocity.x < 0.0 ? current - remainder : current + (fullItemMeasure - remainder)
            }
        default:
            if scrollDirection == .Vertical {
                contentOffset.y = velocity.y > 0.0 ? collectionView!.contentOffset.y + fullItemMeasure * 2.0 : collectionView!.contentOffset.y - fullItemMeasure * 2.0
                let remainder = (contentOffset.y + inset) % fullItemMeasure
                if remainder < fullItemMeasure / 2.0 {
                    contentOffset.y -= remainder
                } else {
                    contentOffset.y += fullItemMeasure - remainder
                }
            } else {
                contentOffset.x = velocity.x > 0.0 ? collectionView!.contentOffset.x + fullItemMeasure * 2.0 : collectionView!.contentOffset.x - fullItemMeasure * 2.0
                let remainder = (contentOffset.x + inset) % fullItemMeasure
                if remainder < fullItemMeasure / 2.0 {
                    contentOffset.x -= remainder
                } else {
                    contentOffset.x += fullItemMeasure - remainder
                }
            }
        }
        
        return contentOffset
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
