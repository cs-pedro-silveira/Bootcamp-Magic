//
//  CardDetailCollectionViewDelegate.swift
//  Bootcamp-Magic
//
//  Created by pedro.silveira on 18/02/21.
//

import Foundation
import UIKit

final class CardDetailCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    private let detailCollectionView: UICollectionView
    private let superView: UIView

    init(detailCollectionView: UICollectionView, superView: UIView) {
        self.detailCollectionView = detailCollectionView
        self.superView = superView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 40, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = self.detailCollectionView.center.x

        for cell in self.detailCollectionView.visibleCells {

            let basePosition = cell.convert(CGPoint.zero, to: self.superView)
            let cellCenterX = basePosition.x + self.detailCollectionView.frame.size.height / 2.0

            let distance = abs(cellCenterX - centerX)

            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerX ) * 0.105)
            if(scale > 1.0) {
                scale = 1.0
            }

            if(scale < 0.94) {
                scale = 0.94
            }

            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        var indexOfCellWithLargestWidth = 0
        var largestWidth : CGFloat = 1

        for cell in self.detailCollectionView.visibleCells where cell.frame.size.width > largestWidth {
            largestWidth = cell.frame.size.width
            if let indexPath = self.detailCollectionView.indexPath(for: cell) {
                indexOfCellWithLargestWidth = indexPath.item
            }
        }

        detailCollectionView.scrollToItem(at: IndexPath(item: indexOfCellWithLargestWidth, section: 0), at: .centeredHorizontally, animated: true)
    }
}