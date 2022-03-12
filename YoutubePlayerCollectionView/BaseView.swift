//
//  BaseView.swift
//
//  Created by Aaron Lee on 2022/03/10.
//
import SnapKit
import Then
import UIKit

class BaseView: UIView {
  // MARK: - Public Properties

  // MARK: - Init

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

  func configureView() {}

  func layoutView() {}
}
