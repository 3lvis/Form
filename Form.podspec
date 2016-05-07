Pod::Spec.new do |s|
  s.name = "Form"
  s.version = "3.10.0"
  s.summary = "JSON driven form"
  s.homepage = "https://github.com/hyperoslo/Form"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '8.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/Form.git',
    :tag => s.version.to_s
  }
  s.resource_bundles = {
      'Form' => ['Assets/*.{png}']
  }
  s.source_files = 'Source/**/*.{h,m,swift}'
  s.frameworks = 'Foundation'
  s.requires_arc = true

  s.dependency 'FormTextField', '~> 0.7.2'
  s.dependency 'Hex', '~> 3.0.0'
  s.dependency 'HYP8601', '~> 0.7.2'
  s.dependency 'HYPMathParser', '~> 0.4.1'
  s.dependency 'HYPNorwegianAccountNumber', '~> 1.2.1'
  s.dependency 'HYPNorwegianSSN', '~> 1.10.2'
  s.dependency 'NSDictionary-ANDYSafeValue', '~> 0.3'
  s.dependency 'NSDictionary-HYPNestedAttributes', '~> 0.4.1'
  s.dependency 'NSJSONSerialization-ANDYJSONFile', '~> 1.1'
  s.dependency 'NSObject-HYPTesting', '~> 1.2'
  s.dependency 'NSString-HYPContainsString', '~> 0.1'
  s.dependency 'NSString-HYPFormula', '~> 1.6.2'
  s.dependency 'NSString-HYPRelationshipParser', '~> 0.4.1'
  s.dependency 'NSString-HYPWordExtractor', '~> 1.2'
  s.dependency 'NSString-ZENInflections', '~> 1.2'
  s.dependency 'UIButton-ANDYHighlighted', '~> 0.2.1'
  s.dependency 'UIViewController-HYPKeyboardToolbar', '~> 0.1'
end
