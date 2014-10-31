Pod::Spec.new do |s|
  s.name = "HYPForms"
  s.version = "0.29"
  s.summary = "JSON driven forms"
  s.description = <<-DESC
                   * JSON driven forms
                   DESC
  s.homepage = "https://github.com/hyperoslo/HYPForms"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Elvis Nuñez" => "elvis@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/HYPForms.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/**/*.{h,m}'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
