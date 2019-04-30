Pod::Spec.new do |s|
    
    s.name                       = 'JhtAnimationTools'
    s.version                    = '1.0.7'
    s.summary                    = '购物车类的抛物线动画 && 阻尼动画'
    s.homepage                   = 'https://github.com/jinht/ShopCarAnimation'
    s.license                    = { :type => 'MIT', :file => 'LICENSE' }
    s.author                     = { 'Jinht' => 'jinjob@icloud.com' }
    s.social_media_url           = 'https://blog.csdn.net/Anticipate91'
    s.platform                   = :ios
    s.ios.deployment_target      = '8.0'
    s.source                     = { :git => 'https://github.com/jinht/ShopCarAnimation.git', :tag => s.version }
    s.source_files               = 'JhtAnimationTools/*.{h,m}'
    s.frameworks                 = 'UIKit'

end
