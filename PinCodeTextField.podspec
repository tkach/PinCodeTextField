
Pod::Spec.new do |s|

  s.name         = "PinCodeTextField"
  s.version      = "0.0.1"
  s.summary      = "Simple pin code text input based on UIKeyInput"

  s.description  = <<-DESC
                  Simple pin code text input with underlines for each character placeholder
                   DESC

  s.homepage     = "https://github.com/tkach/PinCodeTextField"

  s.license      = { :type => "MIT", :file => 'MIT-LICENSE.txt' }


  s.author       = { "Alex Tkachenko" => "tkach2004@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/tkach/PinCodeTextField.git", :tag => "0.0.1" }

  s.source_files  = "Pod", "Pod/**/*.{swift}"
end
