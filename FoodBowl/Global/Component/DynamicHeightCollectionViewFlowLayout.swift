//
//  DynamicHeightCollectionViewFlowLayout.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/10.
//

import UIKit

final class DynamicHeightCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributeObjects = super.layoutAttributesForElements(in: rect)
        layoutAttributeObjects?.forEach { layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        }

        return layoutAttributeObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let layoutAttirbutes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        layoutAttirbutes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width

        return layoutAttirbutes
    }
}
