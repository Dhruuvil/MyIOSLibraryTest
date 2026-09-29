Pod::Spec.new do |s|
  s.name             = 'MobyRewards'
  s.version          = '1.0.0'
  s.summary          = 'Moby Rewards SDK for iOS'
  s.description      = 'Scratch, reveal and enjoy cashback & rewards in iOS apps.'
  s.homepage         = 'https://mobyads.in'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Moby' => 'support@mobyads.in' }
  s.source           = { :git => 'https://github.com/moby-cashback/moby-rewards-lib.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'

  s.source_files = 'Sources/MobyRewards/**/*'
  s.frameworks   = 'UIKit', 'SwiftUI'
end
