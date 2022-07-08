Pod::Spec.new do |s|
  s.name             = "Highway"
  s.version          = "0.13.0"
  s.summary          = "Unidirectional Data Flow in Swift"
  s.description      = <<-DESC
                        Highway is a mix of Redux-like and The Elm Architecture implementation of the unidirectional data flow architecture in Swift.
                        It brings best of them to iOS Development.
                        DESC
  s.homepage         = "https://github.com/cooler333/Highway"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = {
    "Dmitrii Cooler" => "collerov333@gmail.com"
  }
  # s.documentation_url = "https://highway.github.io/Highway/"
  # s.social_media_url  = "https://twitter.com/cooler333"
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
  s.swift_versions   = ["5.6", "5.5", "5.4"]
end
