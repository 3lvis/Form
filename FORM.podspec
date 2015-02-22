Pod::Spec.new do |s|
  s.name = "HYPForms"
  s.version = "0.113"
  s.summary = "JSON driven forms"
  s.description = <<-DESC
                   * JSON driven forms
                   DESC
  s.homepage = "https://github.com/hyperoslo/HYPForms"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper" => "teknologi@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/HYPForms.git',
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
  s.dependency 'NSString-HYPFormula'
  s.dependency 'NSString-HYPWordExtractor'
  s.dependency 'Hex'
  s.dependency 'NSString-HYPContainsString'
  s.dependency "DDMathParser", :git => "git://github.com/hyperoslo/DDMathParser.git"
  s.dependency 'NSObject-HYPTesting'
end
