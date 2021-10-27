//
//  CommentListCell.swift
//  DeclarativeCollectionViewExample
//
//  Created by 酒井文也 on 2021/10/27.
//

import Foundation
import UIKit

final class CommentListCell: UICollectionViewListCell {

    // MARK: - Property

    var author: String?
    var position: String?
    var publishedAt: String?
    var comment: String?

    // MARK: - Override
    
    override func updateConfiguration(using state: UICellConfigurationState) {

        var newConfiguration = CommentListCellConfiguration().updated(for: state)
        newConfiguration.author = author
        newConfiguration.position = position
        newConfiguration.publishedAt = publishedAt
        newConfiguration.comment = comment
        contentConfiguration = newConfiguration
    }
}

