platform :ios, '12.0'
inhibit_all_warnings!

target 'YoutubePlayerCollectionView' do
  use_frameworks!

  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  pod 'RxDataSources'
  pod 'Then'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end