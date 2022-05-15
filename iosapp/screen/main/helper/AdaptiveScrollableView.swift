//
//  AdaptiveScrollableView.swift
//  iosapp
//
//  Created by alexander on 04.05.2022.
//

import Foundation
import UIKit

class AdaptiveScrollableView: UIView {
    private weak var topAnchorView: UIView?
    private var previousOffset = 0.0
    var safeArea: CGFloat = 50.0

    var currentOffset: CGFloat = 0.0 {
        didSet {
            guard topAnchorView != nil else { return }
            updatePosition()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupAnchorView(_ topView: UIView?) {
        self.topAnchorView  = topView
    }

    private func updatePosition() {
        let anchorFrame = topAnchorView!.frame
        let visibleHeight = frame.origin.y + frame.height - anchorFrame.origin.y - anchorFrame.height
        let unvisibleHeight = frame.height - visibleHeight
        let deltaOffset = abs(currentOffset - previousOffset)
        let direction: Direction = currentOffset > previousOffset ? .bottom : .top
        previousOffset = currentOffset
        // offset in diapazon (0...)
        let formattedOffset = currentOffset //+ anchorFrame.height


        subviews.forEach { sub in
            let alpha = (visibleHeight / safeArea)
            sub.alpha = pow(alpha, 5)
        }

        if formattedOffset <= unvisibleHeight {
            switch direction {
            case .top:
                transform = .init(translationX: 0, y:  -formattedOffset)
            case .bottom:
                transform = .init(translationX: 0, y: max(-frame.height, -formattedOffset))
            }
        } else {
            switch direction {
            case .top:
                let newOffset = frame.height - visibleHeight - deltaOffset
                transform = .init(translationX: 0, y: min( -(frame.height - safeArea), -newOffset))
            case .bottom:
                let newOffset = frame.height - visibleHeight + deltaOffset
                transform = .init(translationX: 0, y: max(-frame.height, -newOffset))
            }
        }
    }
}

enum Direction: String {
    case top
    case bottom
}
