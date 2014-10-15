Pod::Spec.new do |s|
  s.name = "HYPNorwegianAccountNumber"
  s.version = "1.2"
  s.summary = "Makes validating Norwegian account numbers easy as pie"
  s.description = <<-DESC
                   * Makes validating Norwegian account numbers easy as pie
                   DESC
  s.homepage = "https://github.com/hyperoslo/HYPNorwegianAccountNumber"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv" => "teknologi@hyper.no" }
  s.social_media_url = "https://twitter.com/hyperoslo"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/HYPNorwegianAccountNumber.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
