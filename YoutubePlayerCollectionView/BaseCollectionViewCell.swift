//
//  BaseCollectionViewCell.swift
//
//  Created by Aaron Lee on 2022/03/10.
//
import SnapKit
import Then
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  var label = UILabel()
    .then {
      $0.text = "Cell"
      $0.textColor = .white
      $0.textAlignment = .center
      $0.font = .systemFont(ofSize: 18.0)
    }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
    layoutView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
    layoutView()
  }

  func configureView() {
    backgroundColor = .brown
    contentView.addSubview(label)
  }

  func layoutView() {
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
