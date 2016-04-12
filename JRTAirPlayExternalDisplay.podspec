Pod::Spec.new do |s|
  s.name         = "JRTAirPlayExternalDisplay"
  s.version      = "0.0.3"
  s.summary      = "JRTAirPlayExternalDisplay is a class that helps the most common implementation."
  s.homepage     = "https://github.com/ifobos/JRTAirPlayExternalDisplay"
  s.license      = "MIT"
  s.author       = { "ifobos" => "juancarlos.garcia.alfaro@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ifobos/JRTAirPlayExternalDisplay.git", :tag => "0.0.3" }
  s.source_files = "JRTAirPlayExternalDisplay/JRTAirPlayExternalDisplay/PodFiles/*.{h,m}"
  s.requires_arc = true
end
