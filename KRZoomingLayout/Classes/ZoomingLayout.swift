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

@IBDesignable
public class ZoomingLayout: UICollectionViewFlowLayout {
    
    @IBInspectable public var zoomScale: CGFloat = 1.0
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrAttribs = [UICollectionViewLayoutAttributes]()
        let itemMeasure = scrollDirection == .Vertical ? itemSize.height : itemSize.width
        let contentOffset = scrollDirection == .Vertical ? collectionView!.contentOffset.y + collectionView!.contentInset.top : collectionView!.contentOffset.x + collectionView!.contentInset.left
        let screenCenter = contentOffset + itemMeasure / 2.0
        let maxScale = zoomScale > 1.0 ? zoomScale : 1.0
        let minScale = zoomScale > 1.0 ? 1.0 : zoomScale
        
        for attribs in super.layoutAttributesForElementsInRect(rect)! {
            let cellCenter = scrollDirection == .Vertical ? attribs.center.y : attribs.center.x
            
            if contentOffset < cellCenter && cellCenter < contentOffset + itemMeasure {
                let scale = minScale + (maxScale - minScale) * (1 - abs(screenCenter - cellCenter) / (itemMeasure / 2.0))
                attribs.transform = CGAffineTransformMakeScale(scale, scale)
            } else {
                attribs.transform = CGAffineTransformMakeScale(minScale, minScale)
            }
            arrAttribs.append(attribs)
        }
        
        return arrAttribs
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var contentOffset = proposedContentOffset
        let inset = scrollDirection == .Vertical ? collectionView!.contentInset.top : collectionView!.contentInset.left
        let absVelocity = scrollDirection == .Vertical ? abs(velocity.y) : abs(velocity.x)
        let fullItemMeasure = scrollDirection == .Vertical ? itemSize.height + minimumInteritemSpacing : itemSize.width + minimumLineSpacing 
        
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
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
