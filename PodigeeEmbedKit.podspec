Pod::Spec.new do |s|
 s.name = 'PodigeeEmbedKit'
 s.version = '0.0.1'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'iOS Framework to embed podcast episodes hosted on Podigee'
 s.homepage = 'https://podigee.com'
 s.social_media_url = 'https://twitter.com/podigee'
 s.authors = { "Podigee" => "hello@podigee.com" }
 s.source = { :git => "https://github.com/podigee/PodigeeEmbedKit.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "10.0", :osx => "10.12", :tvos => "10.0", :watchos => "3.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.framework  = "Foundation"
 end
end
