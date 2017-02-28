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
    
    fileprivate func scrollToCenter(_ indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath)!
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if flowLayout.scrollDirection == .vertical {
                let offsetX = self.collectionView.contentOffset.x
                let offsetY = cell.center.y - (CELL_SIZE / 2.0) - self.collectionView.contentInset.top
                self.collectionView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: true)
            } else {
                let offsetX = cell.center.x - (CELL_SIZE / 2.0) - self.collectionView.contentInset.left
                let offsetY = self.collectionView.contentOffset.y
                self.collectionView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: true)
            }
        }
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 2.0
        
        let label = cell.viewWithTag(ViewTag.Label) as! UILabel
        label.text = "#\(indexPath.item + 1)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scrollToCenter(indexPath)
    }
}

