//
//  VideoPlayerView.swift
//  VideoPlayerUI
//
//  Created by Aaron Lee on 2022/03/12.
//

import SnapKit
import Then
import UIKit

class VideoPlayerView: BaseView {
  var label = UILabel()
    .then {
      $0.text = "Video"
      $0.textAlignment = .center
      $0.font = .boldSystemFont(ofSize: 28.0)
      $0.textColor = .black
    }

  override func configureView() {
    super.configureView()
    backgroundColor = .lightGray
    addSubview(label)
  }

  override func layoutView() {
    super.layoutView()
    label.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
