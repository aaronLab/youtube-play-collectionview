//
//  BasePortraitViewController.swift
//
//  Created by Aaron Lee on 2022/03/10.
//
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BaseViewController: UIViewController {
  var bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    layoutView()
    bindRx()
  }

  func configureView() {}

  func layoutView() {}

  func bindRx() {
    bindDependency()
    bindInput()
    bindOutput()
  }

  func bindDependency() {}

  func bindInput() {}

  func bindOutput() {}
}
