Pod::Spec.new do |s|
  s.name = "Form"
  s.version = "3.3.5"
  s.summary = "JSON driven form"
  s.homepage = "https://github.com/hyperoslo/Form"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/Form.git',
    :tag => s.version.to_s
  }
  s.resource_bundles = {
      'Form' => ['Assets/*.{png}']
  }
  s.source_files = 'Source/**/*.{h,m}'
  s.frameworks = 'Foundation'
  s.requires_arc = true

  s.dependency 'HYPImagePicker', '~> 0.3'
  s.dependency 'HYPMathParser', '~> 0.4.0'
  s.dependency 'HYPNorwegianAccountNumber', '~> 1.2.1'
  s.dependency 'HYPNorwegianSSN', '~> 1.10'
  s.dependency 'Hex', '~> 1.1.1'
  s.dependency 'ISO8601DateFormatter', '~> 0.7'
  s.dependency 'NSDictionary-ANDYSafeValue', '~> 0.3'
  s.dependency 'NSDictionary-HYPNestedAttributes', '~> 0.4.1'
  s.dependency 'NSJSONSerialization-ANDYJSONFile', '~> 1.1'
  s.dependency 'NSObject-HYPTesting', '~> 1.2'
  s.dependency 'NSString-HYPContainsString', '~> 0.1'
  s.dependency 'NSString-HYPFormula', '~> 1.6.1'
  s.dependency 'NSString-HYPRelationshipParser', '~> 0.4.1'
  s.dependency 'NSString-HYPWordExtractor', '~> 1.1'
  s.dependency 'NSString-ZENInflections', '~> 1.2'
  s.dependency 'UIButton-ANDYHighlighted', '~> 0.2.1'
end
