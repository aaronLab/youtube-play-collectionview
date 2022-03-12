//
//  CollectionViewHeaderView.swift
//  VideoPlayerUI
//
//  Created by Aaron Lee on 2022/03/12.
//

import SnapKit
import Then
import UIKit

class CollectionViewHeaderView: UICollectionReusableView {
  var label = UILabel()
    .then {
      $0.text = "Header"
      $0.textColor = .white
      $0.textAlignment = .center
      $0.font = .systemFont(ofSize: 18.0)
    }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    configureView()
    layoutView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
    layoutView()
  }

  func configureView() {
    backgroundColor = .orange
    addSubview(label)
  }

  func layoutView() {
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - Configure

extension CollectionViewHeaderView {}

// MARK: - Layout

extension CollectionViewHeaderView {}
