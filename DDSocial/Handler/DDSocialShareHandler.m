//
//  DDSocialShareHandler.m
//  DDSocialDemo
//
//  Created by lilingang on 16/1/4.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDSocialShareHandler.h"
#import "DDSocialHandlerProtocol.h"
#import <UIKit/UIKit.h>

@interface DDSocialShareHandler ()

@property (nonatomic, strong) id<DDSocialHandlerProtocol> wechatHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> sinaHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> tencentHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> facebookHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> googleHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> twitterHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> miliaoHandler;
@property (nonatomic, strong) id<DDSocialHandlerProtocol> miHandler;

@end

@implementation DDSocialShareHandler

+ (DDSocialShareHandler *)sharedInstance{
    static DDSocialShareHandler *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Public Methods

+ (BOOL)isInstalledPlatform:(DDSSPlatform)platform{
    Class class = [self classWithPlatForm:platform];
    if (class) {
        return [class isInstalled];
    } else {
        return NO;
    }
}

+ (BOOL)canShareToScence:(DDSSScene)scene{
    DDSSPlatform platform = DDSSPlatformNone;
    if (scene == DDSSSceneWXSession || scene == DDSSSceneWXTimeline) {
        platform = DDSSPlatformWeChat;
    } else if (scene == DDSSSceneSina){
        platform = DDSSPlatformSina;
    } else if (scene == DDSSSceneQQFrined || scene == DDSSSceneQZone){
        platform = DDSSPlatformQQ;
    } else if (scene == DDSSSceneFacebook){
        platform = DDSSPlatformFacebook;
    } else if (scene == DDSSSceneTwitter){
        platform = DDSSPlatformTwitter;
    } else if (scene == DDSSSceneMiLiaoSession || scene == DDSSSceneMiLiaoTimeline){
        platform = DDSSPlatformMiLiao;
    }
    return [DDSocialShareHandler isInstalledPlatform:platform];
}

- (void)registerPlatform:(DDSSPlatform)platform {
    [self registerPlatform:platform appKey:@"" appSecret:@"" redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey{
    [self registerPlatform:platform appKey:appKey appSecret:@"" redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret {
    [self registerPlatform:platform appKey:appKey appSecret:appSecret redirectURL:@"" appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
             redirectURL:(NSString *)redirectURL{
    [self registerPlatform:platform appKey:appKey appSecret:@"" redirectURL:redirectURL appDescription:@""];
}

- (void)registerPlatform:(DDSSPlatform)platform
                  appKey:(NSString *)appKey
               appSecret:(NSString *)appSecret
             redirectURL:(NSString *)redirectURL
          appDescription:(NSString *)appDescription {
    id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];
    if ([handlerProtocol respondsToSelector:@selector(registerWithAppKey:appSecret:redirectURL:appDescription:)] && handlerProtocol) {
        [handlerProtocol registerWithAppKey:appKey appSecret:appSecret redirectURL:redirectURL appDescription:appDescription];
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    BOOL canOpenURL = NO;
    for (DDSSPlatform platform = DDSSPlatformNone; platform < DDSSPlatformCount; platform ++) {
        if (platform == DDSSPlatformNone) {
            continue;
        }
        id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];
        if ([handlerProtocol respondsToSelector:@selector(application:handleOpenURL:sourceApplication:annotation:)] && handlerProtocol) {
            canOpenURL = [handlerProtocol application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
            if (canOpenURL) {
                break;
            }
        }
    }
    return canOpenURL;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    NSString *sourceApplicationKey = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    id annotationApplicationKey = options[UIApplicationOpenURLOptionsAnnotationKey];
    return [self application:app handleOpenURL:url sourceApplication:sourceApplicationKey annotation:annotationApplicationKey];
}

- (BOOL)authWithPlatform:(DDSSPlatform)platform
                authMode:(DDSSAuthMode)authMode
              controller:(UIViewController *)viewController
                 handler:(DDSSAuthEventHandler)handler{
    id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];
    if (handlerProtocol && [handlerProtocol respondsToSelector:@selector(authWithMode:controller:handler:)]) {
        return [handlerProtocol authWithMode:authMode controller:viewController handler:handler];
    } else {
        return NO;
    }
}

- (BOOL)getUserInfoWithPlatform:(DDSSPlatform)platform
                       authItem:(DDAuthItem *)authItem
                        handler:(DDSSUserInfoEventHandler)handler{
    id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];
    if (handlerProtocol && [handlerProtocol respondsToSelector:@selector(getUserInfoWithAuthItem:handler:)]) {
        return [handlerProtocol getUserInfoWithAuthItem:authItem handler:handler];
    } else {
        return NO;
    }
}

- (BOOL)shareWithPlatform:(DDSSPlatform)platform
               controller:(UIViewController *)viewController
               shareScene:(DDSSScene)shareScene
              contentType:(DDSSContentType)contentType
                 protocol:(id<DDSocialShareContentProtocol>)protocol
                  handler:(DDSSShareEventHandler)handler{
    if (![self respondsToSelectorWithProtocol:protocol type:contentType] || !handler) {
        return NO;
    }
    id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];

    if (handlerProtocol && [handlerProtocol respondsToSelector:@selector(shareWithController:shareScene:contentType:protocol:handler:)]) {
        return [handlerProtocol shareWithController:viewController shareScene:shareScene contentType:contentType protocol:protocol handler:handler];
    } else {
        return NO;
    }
}

- (BOOL)linkupWithPlatform:(DDSSPlatform)platform
                      item:(DDLinkupItem *)linkupItem{
    id <DDSocialHandlerProtocol> handlerProtocol = [self handlerWithPlatForm:platform];
    if (handlerProtocol && [handlerProtocol respondsToSelector:@selector(linkupWithItem:)]) {
        return [handlerProtocol linkupWithItem:linkupItem];
    } else {
        return NO;
    }
}

#pragma mark - Private Methods

- (BOOL)respondsToSelectorWithProtocol:(id<DDSocialShareContentProtocol>)protocol type:(DDSSContentType)shareType{
    if (shareType == DDSSContentTypeText) {
        return [self respondsToSelectorWithTextProtocol:(id<DDSocialShareTextProtocol>)protocol];
    }
    else if (shareType == DDSSContentTypeImage){
        return [self respondsToSelectorWithImageProtocol:(id<DDSocialShareImageProtocol>)protocol];
    }
    else if (shareType == DDSSContentTypeWebPage){
        return [self respondsToSelectorWithWebPageProtocol:(id<DDSocialShareWebPageProtocol>)protocol];
    }
    else {
        return NO;
    }
}

- (BOOL)respondsToSelectorWithTextProtocol:(id<DDSocialShareTextProtocol>)protocol{
    return [self protocol:protocol respondsToSelector:@selector(ddShareText)];
}

- (BOOL)respondsToSelectorWithImageProtocol:(id<DDSocialShareImageProtocol>)protocol{
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithImageData)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithTitle)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithDescription)];
    [self protocol:protocol respondsToSelector:@selector(ddShareImageWithWebpageUrl)];
    return YES;
}

- (BOOL)respondsToSelectorWithWebPageProtocol:(id<DDSocialShareWebPageProtocol>)protocol{
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithTitle)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithDescription)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithImageData)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithWebpageUrl)];
    [self protocol:protocol respondsToSelector:@selector(ddShareWebPageWithObjectID)];
    return YES;
}

- (BOOL)protocol:(id)protocol respondsToSelector:(SEL)selector{
    if (![protocol respondsToSelector:selector]) {
        NSAssert(NO,([NSString stringWithFormat:@"%@ not implementation method %@ ",NSStringFromProtocol(protocol),NSStringFromSelector(selector)]));
    }
    return YES;
}

+ (Class)classWithPlatForm:(DDSSPlatform)platForm{
    if (platForm == DDSSPlatformQQ) {
        return NSClassFromString(@"DDTencentHandler");
    } else if (platForm == DDSSPlatformSina){
        return NSClassFromString(@"DDSinaHandler");
    } else if (platForm == DDSSPlatformWeChat){
        return NSClassFromString(@"DDWeChatHandler");
    } else if (platForm == DDSSPlatformMI){
        return NSClassFromString(@"DDMIHandler");
    } else if (platForm == DDSSPlatformMiLiao){
        return NSClassFromString(@"DDMiLiaoHandler");
    } else if (platForm == DDSSPlatformFacebook){
        return NSClassFromString(@"DDFacebookHandler");
    } else if (platForm == DDSSPlatformTwitter){
        return NSClassFromString(@"DDTwitterHandler");
    } else if (platForm == DDSSPlatformGoogle){
        return NSClassFromString(@"DDGoogleHandler");
    } else {
        return nil;
    }
}

- (id<DDSocialHandlerProtocol>)handlerWithPlatForm:(DDSSPlatform)platForm{
    if (platForm == DDSSPlatformQQ) {
        return self.tencentHandler;
    } else if (platForm == DDSSPlatformSina){
        return self.sinaHandler;
    } else if (platForm == DDSSPlatformWeChat){
        return self.wechatHandler;
    } else if (platForm == DDSSPlatformMI){
        return self.miHandler;
    } else if (platForm == DDSSPlatformMiLiao){
        return self.miliaoHandler;
    } else if (platForm == DDSSPlatformFacebook){
        return self.facebookHandler;
    } else if (platForm == DDSSPlatformTwitter){
        return self.twitterHandler;
    } else if (platForm == DDSSPlatformGoogle){
        return self.googleHandler;
    } else {
        return nil;
    }
}

#pragma mark - Getter and Setter

- (id<DDSocialHandlerProtocol>)wechatHandler{
    if (!_wechatHandler) {
        _wechatHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformWeChat] new];
    }
    return _wechatHandler;
}

- (id<DDSocialHandlerProtocol>)sinaHandler{
    if (!_sinaHandler) {
        _sinaHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformSina] new];
    }
    return _sinaHandler;
}

- (id<DDSocialHandlerProtocol>)tencentHandler{
    if (!_tencentHandler) {
        _tencentHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformQQ] new];
    }
    return _tencentHandler;
}

- (id<DDSocialHandlerProtocol>)facebookHandler{
    if (!_facebookHandler) {
        _facebookHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformFacebook] new];
    }
    return _facebookHandler;
}

- (id<DDSocialHandlerProtocol>)googleHandler{
    if (!_googleHandler) {
        _googleHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformGoogle] new];
    }
    return _googleHandler;
}

- (id<DDSocialHandlerProtocol>)twitterHandler{
    if (!_twitterHandler) {
        _twitterHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformTwitter] new];
    }
    return _twitterHandler;
}

- (id<DDSocialHandlerProtocol>)miliaoHandler{
    if (!_miliaoHandler) {
        _miliaoHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformMiLiao] new];
    }
    return _miliaoHandler;
}

- (id<DDSocialHandlerProtocol>)miHandler{
    if (!_miHandler) {
        _miHandler = [[DDSocialShareHandler classWithPlatForm:DDSSPlatformMI] new];
    }
    return _miHandler;
}
@end
