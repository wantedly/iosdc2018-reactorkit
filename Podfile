platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

# ASCII Order
target 'iosdc2018-livecoding' do
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Then'
  pod 'UITextView+Placeholder'
  pod 'ReactorKit'
  pod 'Reveal-SDK', :configurations => ['Debug']
  pod 'SnapKit'
end

post_install do |installer| # Fix for: https://github.com/wantedly/visit-ios/issues/14
    podsTargets = installer.pods_project.targets.find_all { |target| target.name.start_with?('Pods') }
    podsTargets.each do |target|
        target.frameworks_build_phase.clear
    end
end
