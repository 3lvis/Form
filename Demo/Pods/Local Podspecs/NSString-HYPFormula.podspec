Pod::Spec.new do |s|
  s.name = "NSString-HYPFormula"
  s.version = "1.1"
  s.summary = "Creating and running string-based formulas have never been this easy"
  s.description = <<-DESC
                   * Creating and running string-based formulas have never been this easy
                   DESC
  s.homepage = "https://github.com/hyperoslo/NSString-HYPFormula"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv" => "teknologi@hyper.no" }
  s.social_media_url = "https://twitter.com/hyperoslo"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/NSString-HYPFormula.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
