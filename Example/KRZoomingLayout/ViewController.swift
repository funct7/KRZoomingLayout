//
//  ViewController.swift
//  KRZoomingLayout
//
//  Created by Joshua Park on 06/07/2016.
//  Copyright (c) 2016 Joshua Park. All rights reserved.
//

import UIKit

private let CELL_SIZE: CGFloat = 200.0

private struct ViewTag {
    static let Label = 1
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hInset = (self.view.bounds.width - CELL_SIZE) / 2.0
        let vInset = (self.view.bounds.height - CELL_SIZE) / 2.0
        self.collectionView.contentInset = UIEdgeInsetsMake(vInset, hInset, vInset, hInset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    private func scrollToCenter(indexPath: NSIndexPath) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)!
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if flowLayout.scrollDirection == .Vertical {
                let offsetX = self.collectionView.contentOffset.x
                let offsetY = cell.center.y - (CELL_SIZE / 2.0) - self.collectionView.contentInset.top
                self.collectionView.setContentOffset(CGPointMake(offsetX, offsetY), animated: true)
            } else {
                let offsetX = cell.center.x - (CELL_SIZE / 2.0) - self.collectionView.contentInset.left
                let offsetY = self.collectionView.contentOffset.y
                self.collectionView.setContentOffset(CGPointMake(offsetX, offsetY), animated: true)
            }
        }
    }
    
    // MARK: - Collection view
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.layer.borderColor = UIColor.redColor().CGColor
        cell.layer.borderWidth = 2.0
        
        let label = cell.viewWithTag(ViewTag.Label) as! UILabel
        label.text = "#\(indexPath.item + 1)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.scrollToCenter(indexPath)
    }
}

