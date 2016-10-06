//
//  ZoomingLayout.swift
//  ZoomingLayout
//
//  Created by Joshua Park on 6/1/16.
//  Copyright © 2016 Knowre. All rights reserved.
//

import UIKit

private var Screen: UIScreen {
    return UIScreen.main
}

@IBDesignable
open class ZoomingLayout: UICollectionViewFlowLayout {
    
    @IBInspectable open var zoomScale: CGFloat = 1.0
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrAttribs = [UICollectionViewLayoutAttributes]()
        let itemMeasure = scrollDirection == .vertical ? itemSize.height : itemSize.width
        let contentOffset = scrollDirection == .vertical ? collectionView!.contentOffset.y + collectionView!.contentInset.top : collectionView!.contentOffset.x + collectionView!.contentInset.left
        let screenCenter = contentOffset + itemMeasure / 2.0
        let maxScale = zoomScale > 1.0 ? zoomScale : 1.0
        let minScale = zoomScale > 1.0 ? 1.0 : zoomScale
        
        for attribs in super.layoutAttributesForElements(in: rect)! {
            let cellCenter = scrollDirection == .vertical ? attribs.center.y : attribs.center.x
            
            if contentOffset < cellCenter && cellCenter < contentOffset + itemMeasure {
                let offsetScale = abs(screenCenter - cellCenter) / (itemMeasure / 2.0)
                let scale = minScale + (maxScale - minScale) * (1 - offsetScale)
                attribs.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                attribs.transform = CGAffineTransform(scaleX: minScale, y: minScale)
            }
            arrAttribs.append(attribs)
        }
        
        return arrAttribs
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var contentOffset = proposedContentOffset
        let inset = scrollDirection == .vertical ? collectionView!.contentInset.top : collectionView!.contentInset.left
        let absVelocity = scrollDirection == .vertical ? abs(velocity.y) : abs(velocity.x)
        let fullItemMeasure = scrollDirection == .vertical ? itemSize.height + minimumInteritemSpacing : itemSize.width + minimumLineSpacing 
        
        switch absVelocity {
        case 0.0 ..< 0.2:
            let current = scrollDirection == .vertical ? collectionView!.contentOffset.y : collectionView!.contentOffset.x
            let remainder = (current + inset).truncatingRemainder(dividingBy: fullItemMeasure)
            if scrollDirection == .vertical {
                contentOffset.y = remainder < fullItemMeasure / 2.0 ? current - remainder : current + (fullItemMeasure - remainder)
            } else {
                contentOffset.x = remainder < fullItemMeasure / 2.0 ? current - remainder : current + (fullItemMeasure - remainder)
            }
        case 0.2 ..< 2.0:
            let current = scrollDirection == .vertical ? collectionView!.contentOffset.y : collectionView!.contentOffset.x
            let remainder = (current + inset).truncatingRemainder(dividingBy: fullItemMeasure)
            if scrollDirection == .vertical {
                contentOffset.y = velocity.y < 0.0 ? current - remainder : current + (fullItemMeasure - remainder)
            } else {
                contentOffset.x = velocity.x < 0.0 ? current - remainder : current + (fullItemMeasure - remainder)
            }
        default:
            if scrollDirection == .vertical {
                contentOffset.y = velocity.y > 0.0 ? collectionView!.contentOffset.y + fullItemMeasure * 2.0 : collectionView!.contentOffset.y - fullItemMeasure * 2.0
                let remainder = (contentOffset.y + inset).truncatingRemainder(dividingBy: fullItemMeasure)
                if remainder < fullItemMeasure / 2.0 {
                    contentOffset.y -= remainder
                } else {
                    contentOffset.y += fullItemMeasure - remainder
                }
            } else {
                contentOffset.x = velocity.x > 0.0 ? collectionView!.contentOffset.x + fullItemMeasure * 2.0 : collectionView!.contentOffset.x - fullItemMeasure * 2.0
                let remainder = (contentOffset.x + inset).truncatingRemainder(dividingBy: fullItemMeasure)
                if remainder < fullItemMeasure / 2.0 {
                    contentOffset.x -= remainder
                } else {
                    contentOffset.x += fullItemMeasure - remainder
                }
            }
        }
        
        return contentOffset
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
