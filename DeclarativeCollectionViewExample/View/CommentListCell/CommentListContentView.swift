//
//  CommentListContentView.swift
//  DeclarativeCollectionViewExample
//
//  Created by 酒井文也 on 2021/10/27.
//

import UIKit

// MEMO: View要素に高さ制約を付与しているがこちらのPriorityを999にしています。

final class CommentListContentView: UIView, UIContentView {

    // MARK: Property

    private var currentConfiguration: CommentListCellConfiguration!

    // MARK: Computed Property

    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? CommentListCellConfiguration else {
                return
            }
            applyConfiguration(configuration: newConfiguration)
        }
    }

    // MARK: - @IBOutlet

//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var positionLabel: UILabel!
//    @IBOutlet weak var publishedAtLabel: UILabel!
//    @IBOutlet weak var commentLabel: UILabel!

    // MARK: - Initializer

    init(configuration: CommentListCellConfiguration) {
        super.init(frame: .zero)

        initializeContentView()
        applyConfiguration(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension QuestionListContentView

private extension CommentListContentView {

    // MARK: - Private Function

    private func initializeContentView() {

        Bundle.main.loadNibNamed("\(CommentListContentView.self)", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
//                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
//                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
//                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
//            ]
//        )
    }

    private func applyConfiguration(configuration: CommentListCellConfiguration) {

        // 現在設定されているConfigurationと異なる場合に更新を実施する
        if currentConfiguration != configuration {
            currentConfiguration = configuration

            // Configurationを経由して表示したい値を表示させる
//            authorLabel.text = configuration.author
//            positionLabel.text = configuration.position
//            publishedAtLabel.text = configuration.publishedAt
//            commentLabel.text = configuration.comment

        } else {
            return
        }
    }
}
