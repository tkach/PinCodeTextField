
Pod::Spec.new do |s|

  s.name         = "PinCodeTextField"
  s.version      = "0.0.3"
  s.summary      = "Simple pin code text input based on UIKeyInput"

  s.description  = <<-DESC
                  Simple pin code text input with underlines for each character placeholder
                   DESC

  s.homepage     = "https://github.com/tkach/PinCodeTextField"

  s.license      = { :type => "MIT", :file => 'MIT-LICENSE.txt' }


  s.author       = { "Alex Tkachenko" => "tkach2004@gmail.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/tkach/PinCodeTextField.git", :tag => "#{s.version}" }

  

  s.subspec 'Core' do |sp|
    sp.source_files  = ["Pod/Common/*.{swift}", "Pod/Common/**/*.{swift}" ]
  end

  s.subspec 'ObjC' do |sp|
    sp.dependency 'PinCodeTextField/Core'
    sp.source_files  = ["Pod/Objective-C/*.swift"]
  end

  s.subspec 'Swift' do |sp|
    sp.dependency 'PinCodeTextField/Core'
    sp.source_files  = ["Pod/Swift/*.swift"]
  end

  s.default_subspecs = 'Swift'

end
