Pod::Spec.new do |s|
  s.name = "HYPNorwegianSSN"
  s.version = "1.5"
  s.summary = "A convenient way of validating and extracting info from a Norwegian Social Security Number"
  s.description = <<-DESC
                   * A convenient way of validating and extracting info from a Norwegian Social Security Number
                   DESC
  s.homepage = "https://github.com/hyperoslo/HYPNorwegianSSN"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv" => "teknologi@hyper.no" }
  s.social_media_url = "https://twitter.com/hyperoslo"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/HYPNorwegianSSN.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
