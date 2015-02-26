Pod::Spec.new do |s|
  s.name = "Form"
  s.version = "0.118"
  s.summary = "JSON driven forms"
  s.homepage = "https://github.com/hyperoslo/Form"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper" => "teknologi@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/Form.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/**/*.{h,m}'
  s.frameworks = 'Foundation'
  s.requires_arc = true

  s.dependency 'UIButton-ANDYHighlighted'
  s.dependency 'NSDictionary-ANDYSafeValue'
  s.dependency 'NSJSONSerialization-ANDYJSONFile'
  s.dependency 'NSString-ZENInflections'
  s.dependency 'UIScreen-HYPLiveBounds'
  s.dependency 'HYPImagePicker'
  s.dependency 'HYPNorwegianSSN'
  s.dependency 'HYPNorwegianAccountNumber'
  s.dependency 'NSString-HYPFormula'
  s.dependency 'NSString-HYPWordExtractor'
  s.dependency 'Hex'
  s.dependency 'NSString-HYPContainsString'
  s.dependency 'HYPMathParser'
  s.dependency 'NSObject-HYPTesting'
end
