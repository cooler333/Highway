Pod::Spec.new do |s|
  s.name             = "Highway"
  s.version          = "1.1.0"
  s.summary          = "Fast Multi-store Redux-like architecture framework for iOS/OSX applications"
  s.description      = <<-DESC
                        Fast Multi-store Redux-like architecture framework for iOS/OSX applications.
                        You can easily maintain your app/screen/view state. Forgot about multithread state mutation problem or complex state changes.
                        Make more product value in less time.
                        DESC
  s.homepage         = "https://github.com/cooler333/Highway"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = {
    "Dmitrii Cooler" => "collerov333@gmail.com"
  }
  s.documentation_url = "https://github.com/cooler333/Highway"

  s.source            = {
    :git => "https://github.com/cooler333/Highway.git",
    :tag => s.version.to_s
  }

  s.ios.deployment_target     = '13.0'
  s.osx.deployment_target     = '10.15'
  s.tvos.deployment_target    = '13.0'
  s.watchos.deployment_target = '2.0'

  s.test_spec "HighwayTests" do |ts|
    ts.ios.deployment_target = "13.0"
    ts.osx.deployment_target = "10.15"
    ts.tvos.deployment_target = "13.0"
    ts.pod_target_xcconfig = { "ENABLE_BITCODE" => "NO" }
    ts.framework    = "XCTest"
    ts.source_files = "Tests/HighwayTests/*.swift"
  end

  s.source_files     = 'Sources/Highway/**/*.swift'
  s.swift_versions   = ["5.7", "5.6", "5.5", "5.4"]
end
