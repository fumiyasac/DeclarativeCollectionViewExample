//
//  CommentViewController.swift
//  DeclarativeCollectionViewExample
//
//  Created by 酒井文也 on 2021/10/27.
//

import UIKit

final class CommentViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// 以前に実装した際の全体コード例
/*
import UIKit

enum SettingsSection: Int, CaseIterable {
    case movieSettings
    case questions
}

final class SettingsViewController: UIViewController {

    // MARK: - Propety

    private let presenter: SettingsPresenter

    private var snapshot: NSDiffableDataSourceSnapshot<SettingsSection, AnyHashable>!

    private var dataSource: UICollectionViewDiffableDataSource<SettingsSection, AnyHashable>! = nil

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            // MEMO: UICollectionViewのレイアウトを適用する
            guard let weakSelf = self else {
                assertionFailure()
                return nil
            }
            return weakSelf.createCollectionViewLayout(layoutEnvironment: layoutEnvironment)
        }
        return layout
    }()
    
    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Initializer

    init?(coder: NSCoder, presenter: SettingsPresenter) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle(GlobalTabBarItems.settings.title)
        setupCollectionView()
        applyEmptySnapshot()

        presenter.setup(
            view: self,
            coodinator: self
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidAppearTrigger()
    }

    // MARK: - Private Function
    
    private func setupCollectionView() {

        // MEMO: UICollectionViewDelegateの適用
        collectionView.delegate = self
        
        // MEMO: UICollectionViewCompositionalLayoutを利用してレイアウトを組み立てる
        collectionView.collectionViewLayout = compositionalLayout

        // MEMO: このレイアウトで利用するセル要素・Headerの登録
        // SettingsSection: 0
        collectionView.registerCustomReusableHeaderView(MovieSettingsHeaderView.self)
        // SettingsSection: 1
        collectionView.registerCustomReusableHeaderView(QuestionListHeaderView.self)

        // MEMO: このレイアウトで利用するセル要素のCellRegistration値
        let movieQualityCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MovieQualityViewObject> { [weak self] (cell, _, viewObject) in
            guard let weakSelf = self else {
                assertionFailure()
                return
            }
            var contentConfiguration = weakSelf.createMovieSettingsConfiguration()
            contentConfiguration.text = viewObject.title
            contentConfiguration.secondaryText = viewObject.movieQuality.text
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        }
        let movieSpeedCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MovieSpeedViewObject> { [weak self] (cell, _, viewObject) in
            guard let weakSelf = self else {
                assertionFailure()
                return
            }
            var contentConfiguration = weakSelf.createMovieSettingsConfiguration()
            contentConfiguration.text = viewObject.title
            contentConfiguration.secondaryText = "x\(viewObject.movieSpeed.rawValue)"
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        }
        let questionCellRegistration = UICollectionView.CellRegistration<QuestionListCell, QuestionViewObject> { (cell, _, viewObject) in
            cell.question = viewObject.question
            cell.answer = viewObject.answer
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        }

        // MEMO: DataSourceはUICollectionViewDiffableDataSourceを利用してUICollectionViewCellを継承したクラスを組み立てる
        dataSource = UICollectionViewDiffableDataSource<SettingsSection, AnyHashable>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, viewObject: AnyHashable) -> UICollectionViewCell? in

            // MEMO: UICollectionViewListCellを適用する
            switch viewObject {

            // SettingsSection: 0 (MovieQualityViewObject)
            case let viewObject as MovieQualityViewObject:
                return collectionView.dequeueConfiguredReusableCell(using: movieQualityCellRegistration, for: indexPath, item: viewObject)

            // SettingsSection: 0 (MovieSpeedViewObject)
            case let viewObject as MovieSpeedViewObject:
                return collectionView.dequeueConfiguredReusableCell(using: movieSpeedCellRegistration, for: indexPath, item: viewObject)

            // SettingsSection: 1 (QuestionViewObject)
            case let viewObject as QuestionViewObject:
                return collectionView.dequeueConfiguredReusableCell(using: questionCellRegistration, for: indexPath, item: viewObject)

            default:
                return nil
            }
        }

        // MEMO: Headerの表記についてもUICollectionViewDiffableDataSourceを利用して組み立てる
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            switch indexPath.section {

            // SettingsSection: 0
            case SettingsSection.movieSettings.rawValue:
                if kind == UICollectionView.elementKindSectionHeader {
                    return collectionView.dequeueReusableCustomHeaderView(with: MovieSettingsHeaderView.self, indexPath: indexPath)
                }

            // SettingsSection: 1
            case SettingsSection.questions.rawValue:
                if kind == UICollectionView.elementKindSectionHeader {
                    return collectionView.dequeueReusableCustomHeaderView(with: QuestionListHeaderView.self, indexPath: indexPath)
                }

            default:
                break
            }
            return nil
        }
    }

    private func createCollectionViewLayout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.headerMode = .supplementary
        return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    }

    // デフォルトのUICollectionViewListCellの設定をそのまま利用する場合のデザインを適用する
    private func createMovieSettingsConfiguration() -> UIListContentConfiguration {
        var content: UIListContentConfiguration = .valueCell()
        content.textProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
        content.textProperties.color = .black
        content.secondaryTextProperties.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
        content.secondaryTextProperties.color = .gray
        return content
    }

    // 初期化時のSnapshotを適用する
    private func applyEmptySnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<SettingsSection, AnyHashable>()
        snapshot.appendSections(SettingsSection.allCases)
        for section in SettingsSection.allCases {
            snapshot.appendItems([], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - SettingsView

extension SettingsViewController: SettingsView {
    func applyDataSource(
        movieSettingsDto: MovieSettingsDto,
        questionDto: QuestionDto
    ) {
        // MEMO: 既存のセクションデータをSnapshotから削除する
        let beforeMovieSettingsViewObjects = snapshot.itemIdentifiers(inSection: .movieSettings)
        snapshot.deleteItems(beforeMovieSettingsViewObjects)
        let beforeQuestionsViewObjects = snapshot.itemIdentifiers(inSection: .questions)
        snapshot.deleteItems(beforeQuestionsViewObjects)

        // MEMO: セクションの並び順番をこの中で決定する
        let movieSettingsViewObjects: [AnyHashable] = [
            MovieQualityViewObject(movieQuality: movieSettingsDto.movieQuality),
            MovieSpeedViewObject(movieSpeed: movieSettingsDto.movieSpeed)
        ]
        snapshot.appendItems(movieSettingsViewObjects, toSection: .movieSettings)
        let questionsViewObjects = questionDto.questions.map { question in
            QuestionViewObject(questionEntity: question)
        }
        snapshot.appendItems(questionsViewObjects, toSection: .questions)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - SettingsCoodinator

extension SettingsViewController: SettingsCoodinator {}

// MARK: - UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // MEMO: 該当のセクションとIndexPathからNSDiffableDataSourceSnapshot内の該当する値を取得する
        if let targetSection = SettingsSection(rawValue: indexPath.section) {
            let targetSnapshot = snapshot.itemIdentifiers(inSection: targetSection)
            print("Section: ", targetSection)
            print("IndexPath.row: ", indexPath.row)
            print("Model: ", targetSnapshot[indexPath.row])
        }
    }
}

// MARK: - UIScrollViewDelegate

extension SettingsViewController: UIScrollViewDelegate {

    // MEMO: UICollectionViewDelegateを適用すれば従来通りUIScorllViewDelegateは利用可能
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}
*/
