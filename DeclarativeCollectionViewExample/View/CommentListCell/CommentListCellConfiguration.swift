//
//  CommentListCellConfiguration.swift
//  DeclarativeCollectionViewExample
//
//  Created by 酒井文也 on 2021/10/27.
//

import Foundation
import UIKit

struct CommentListCellConfiguration: UIContentConfiguration, Hashable {

    // MARK: - Property

    var author: String?
    var position: String?
    var publishedAt: String?
    var comment: String?

    // MARK: - Functions

    func makeContentView() -> UIView & UIContentView {
        return CommentListContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
