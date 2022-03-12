//
//  CategoryView.swift
//  VideoPlayerUI
//
//  Created by Aaron Lee on 2022/03/12.
//

import SnapKit
import Then
import UIKit

class CategoryView: BaseView {
  var label = UILabel()
    .then {
      $0.textColor = .white
      $0.textAlignment = .center
      $0.text = "Catecory View"
      $0.font = .systemFont(ofSize: 18.0)
    }

  override func configureView() {
    super.configureView()
    backgroundColor = .darkGray
    addSubview(label)
  }

  override func layoutView() {
    super.layoutView()
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
