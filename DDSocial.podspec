Pod::Spec.new do |s|  
  s.name             = "DDSocial"  
  s.version          = "1.0.0"  
  s.summary          = "A share auth wheels based on the official library content wecaht sina tencent facebook twitter mi"  
  s.homepage         = "https://github.com/393385724/DDSocial"  
  s.license          = 'MIT'  
  s.author           = { "llg" => "393385724@qq.com" }  
  s.source           = { :git => "https://github.com/393385724/DDSocial.git", :tag => s.version.to_s }  
  
  s.platform     = :ios, '7.0'  
  s.requires_arc = true 

  s.subspec 'Core' do |core|
    core.source_files  = 'DDSocialShare/Core/*.{h,m}'
    core.frameworks    = 'Foundation', 'UIKit'
  end

  s.subspec 'Tencent' do |tencent|
    tencent.source_files = 'DDSocialShare/Tencent/Handler/*.{h,m}'
    tencent.ios.vendored_frameworks = 'DDSocialShare/Tencent/TencentSDK/*.framework'
    tencent.resource = "DDSocialShare/Tencent/TencentSDK/*.bundle"
    tencent.libraries = 'z', 'sqlite3','stdc++','iconv'  
    tencent.frameworks = 'SystemConfiguration','CoreGraphics', 'CoreTelephony', 'Security'
    tencent.dependency 'DDSocial/Core'
  end

  s.subspec 'Wechat' do |wechat|
    wechat.source_files = 'DDSocialShare/Wechat/Handler/*.{h,m}','DDSocialShare/Wechat/WeChatSDK/*.h'
    wechat.ios.vendored_libraries = 'DDSocialShare/Wechat/WeChatSDK/*.a'
    wechat.libraries = 'z', 'sqlite3','stdc++'
    wechat.frameworks = 'SystemConfiguration','CoreTelephony'
    wechat.dependency 'DDSocial/Core'
  end

  s.subspec 'Sina' do |sina|
    sina.source_files = 'DDSocialShare/Sina/*.{h,m}'
    sina.dependency 'WeiboSDK', '~> 3.1.3'   
    sina.dependency 'DDSocial/Core'
  end

  s.subspec 'Facebook' do |facebook|
    facebook.source_files = 'DDSocialShare/Facebook/*.{h,m}'
    facebook.dependency 'FBSDKLoginKit', '~> 4.10.0'
    facebook.dependency 'FBSDKShareKit', '~> 4.10.0'
    facebook.dependency 'DDSocial/Core'
  end

  s.subspec 'Twitter' do |twitter|
    twitter.source_files = 'DDSocialShare/Twitter/*.{h,m}'
    twitter.dependency 'TwitterKit','~> 1.15.1'
    twitter.dependency 'DDSocial/Core'
  end
  
  s.subspec 'MI' do |mi|
    mi.dependency 'DDMISDK', '~> 1.0.1' 
  end
  
  s.subspec 'Share' do |share|
    share.source_files  = 'DDSocialShare/Handler/*.{h,m}' 
    share.dependency 'DDSocial/Tencent'
    share.dependency 'DDSocial/Wechat'
    share.dependency 'DDSocial/Sina'
    share.dependency 'DDSocial/Facebook'
    share.dependency 'DDSocial/Twitter'
  end

  s.subspec 'Auth' do |auth|
    auth.source_files = 'DDSocialAuth/*.{h,m}'
    auth.dependency 'DDSocial/MI'
    auth.dependency 'DDSocial/Share'
  end
end  