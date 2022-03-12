//
//  ViewController.swift
//  VideoPlayerUI
//
//  Created by Aaron Lee on 2022/03/12.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

private let videoRatio: CGFloat = 9.0 / 16.0
private let collectionViewCellIdentifier = "cell"
private let collectionViewHeaderViewIdentifier = "header"
private let headerViewHeight: CGFloat = 250.0

class ViewController: BaseViewController {
  var videoPlayerView = VideoPlayerView()

  var collectionViewLayout = UICollectionViewFlowLayout()
    .then {
      $0.headerReferenceSize = UICollectionViewFlowLayout.automaticSize
    }

  var collectionView: UICollectionView!

  var categoryView = CategoryView()
    .then {
      $0.alpha = .zero
    }

  var categoryToHeader: Constraint?
  var categoryToVideo: Constraint?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func configureView() {
    super.configureView()
    configureAll()
  }

  override func layoutView() {
    super.layoutView()
    layoutAll()
  }

  override func bindInput() {
    super.bindInput()
    bindCollectionView()
    bindCollectionViewDidScroll()
  }

  override func bindOutput() {
    super.bindOutput()
  }
}

// MARK: - Helpers

extension ViewController {
  private func headerView() -> CollectionViewHeaderView? {
    guard let headerView = collectionView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: .zero, section: .zero)
    ) as? CollectionViewHeaderView else {
      return nil
    }

    return headerView
  }
}

// MARK: - Configure

extension ViewController {
  private func configureAll() {
    addSubViews()
  }

  private func addSubViews() {
    view.addSubview(videoPlayerView)
    configureCollectionView()
    view.addSubview(categoryView)
  }

  private func configureCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = .clear

    collectionView.register(
      BaseCollectionViewCell.self,
      forCellWithReuseIdentifier: collectionViewCellIdentifier
    )
    collectionView.register(
      CollectionViewHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: collectionViewHeaderViewIdentifier
    )

    collectionView.dataSource = self
    collectionView.delegate = self

    view.addSubview(collectionView)
  }
}

// MARK: - Layout

extension ViewController {
  private func layoutAll() {
    layoutVideoPlayerView()
    layoutCollectionView()
    layoutCategoryView()
  }

  private func layoutVideoPlayerView() {
    videoPlayerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(videoRatio)
    }
  }

  private func layoutCollectionView() {
    collectionView.snp.makeConstraints {
      $0.top.equalTo(videoPlayerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func layoutCategoryView() {
    categoryView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48.0)
    }
  }
}

// MARK: - Input

extension ViewController {
  private func bindCollectionView() {
    collectionView.touchesShouldCancel(in: view)
    Observable
      .of(
        collectionView.rx.didEndDecelerating.asVoid(),
        collectionView.rx.didEndDragging.asVoid(),
        collectionView.rx.didEndScrollingAnimation.asVoid()
      )
      .merge()
      .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.focusCategoryView()
      })
      .disposed(by: bag)
  }

  private func focusCategoryView() {
    let y = collectionView.contentOffset.y

    guard y < headerViewHeight else { return }

    let categoryHeight = categoryView.frame.height

    let threshold = headerViewHeight - categoryHeight

    if y < threshold + (categoryHeight / 2), y > threshold {
      let newPoint = CGPoint(x: collectionView.contentOffset.x,
                             y: headerViewHeight - categoryHeight)

      collectionView.setContentOffset(newPoint, animated: true)
      return
    }

    if y >= threshold + (categoryHeight / 2), y > threshold {
      let newPoint = CGPoint(x: collectionView.contentOffset.x,
                             y: headerViewHeight)

      collectionView.setContentOffset(newPoint, animated: true)
    }
  }

  private func bindCollectionViewDidScroll() {
    collectionView
      .rx
      .didScroll
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.collectionViewDidScroll()
      })
      .disposed(by: bag)
  }

  private func collectionViewDidScroll() {
    if headerView() != nil {
      stickCategoryViewToHeaderView()
    } else {
      stickCategoryViewToVideoView()
    }

    updateCategoryViewAlphaWithSectionInset()
  }

  private func stickCategoryViewToHeaderView() {
    guard let headerView = headerView() else { return }

    categoryToVideo?.deactivate()

    if categoryToHeader == nil {
      categoryView.snp.makeConstraints {
        categoryToHeader = $0.top.equalTo(headerView.snp.bottom).constraint
      }

      return
    }

    categoryToHeader?.activate()
  }

  private func stickCategoryViewToVideoView() {
    categoryToHeader?.deactivate()
    categoryToHeader = nil // reusable header view might not be able to be released

    if categoryToVideo == nil {
      categoryView.snp.makeConstraints {
        categoryToVideo = $0.top.equalTo(videoPlayerView.snp.bottom).constraint
      }

      return
    }

    categoryToVideo?.activate()
  }

  private func updateCategoryViewAlphaWithSectionInset() {
    let categoryHeight = categoryView.frame.height
    let y = collectionView.contentOffset.y

    if y > headerViewHeight - categoryHeight {
      let ratio = 1.0 + (y - headerViewHeight) / categoryHeight

      let minRatio = min(1.0, ratio)
      categoryView.alpha = minRatio
      collectionViewLayout.sectionInset.top = categoryHeight * minRatio
      return
    }

    categoryView.alpha = .zero
    collectionViewLayout.sectionInset.top = .zero
  }
}

// MARK: - Output

extension ViewController {}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    10
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: collectionViewCellIdentifier,
      for: indexPath
    ) as? BaseCollectionViewCell else {
      return UICollectionViewCell()
    }

    cell.backgroundColor = .brown

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerVieww = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: collectionViewHeaderViewIdentifier,
        for: indexPath
      ) as? CollectionViewHeaderView else {
        return UICollectionReusableView()
      }

      return headerVieww
    default:
      assertionFailure("Not supported kind")
      return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    CGSize(width: collectionView.frame.width, height: headerViewHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    CGSize(
      width: collectionView.frame.width,
      height: (collectionView.frame.width * videoRatio) + 48
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    8.0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    .zero
  }
}

public extension ObservableType {
  func asVoid() -> Observable<Void> {
    map { _ in }
  }
}
