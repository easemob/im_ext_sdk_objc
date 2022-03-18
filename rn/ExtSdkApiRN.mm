#import "ExtSdkApiRN.h"
#include "ExtSdkApiObjcImpl.h"
#import "ExtSdkCallbackObjc.h"
#import "ExtSdkCallbackObjcRN.h"
#import "ExtSdkDelegateObjc.h"
#import "ExtSdkDelegateObjcRN.h"
#include "ExtSdkObjectObjcImpl.h"
#import "ExtSdkThreadUtilObjc.h"
#import <HyphenateChat/EMClient.h>
#import <UIKit/UIApplication.h>

static NSString *const TAG = @"ExtSdkApiRN";

@interface ExtSdkApiRN ()

@end

@implementation ExtSdkApiRN

+ (nonnull instancetype)getInstance {
    static ExtSdkApiRN *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkApiRN alloc] init];
    });
    return instance;
}

- (instancetype)init {
    //    if (super = [super init]) {
    [self registerSystemNotify];
    //    }
    return self;
}

#pragma mark - ExtSdkApiObjc

- (void)addListener:(nonnull id<ExtSdkDelegateObjc>)listener {
    NSLog(@"%@: addListener:", TAG);
    EXT_SDK_NAMESPACE_USING
    ExtSdkApi::getInstance()->addListener(std::make_shared<ExtSdkObjectObjcImpl>(listener));
}

- (void)callSdkApi:(nonnull NSString *)methodType
        withParams:(nullable id<NSObject>)params
      withCallback:(nonnull id<ExtSdkCallbackObjc>)callback {
    NSLog(@"%@: callSdkApi: %@: %@", TAG, methodType, nil != params ? params : @"");
    EXT_SDK_NAMESPACE_USING
    std::string cpp_method_type = std::string([methodType UTF8String]);
    std::shared_ptr<ExtSdkObject> cpp_params = std::make_shared<ExtSdkObjectObjcImpl>(params);
    std::shared_ptr<ExtSdkObject> cpp_callback = std::make_shared<ExtSdkObjectObjcImpl>(callback);
    ExtSdkApi::getInstance()->callSdkApi(cpp_method_type, cpp_params, cpp_callback);
}

- (void)delListener:(nonnull id<ExtSdkDelegateObjc>)listener {
    NSLog(@"%@: delListener:", TAG);
    // TODO: no implement
}

- (void)init:(nonnull id<NSObject>)config {
    NSLog(@"%@: init:", TAG);
    EXT_SDK_NAMESPACE_USING
    std::shared_ptr<ExtSdkObjectObjcImpl> cpp_config = std::make_shared<ExtSdkObjectObjcImpl>(config);
    ExtSdkApi::getInstance()->init(cpp_config);
}

- (void)unInit:(nullable id<NSObject>)params {
    NSLog(@"%@: unInit:", TAG);
    EXT_SDK_NAMESPACE_USING
    ExtSdkApi::getInstance()->unInit();
}

#pragma mark - RCTBridgeModule

RCT_EXPORT_MODULE(ExtSdkApiRN)

RCT_EXPORT_METHOD(callMethod
                  : (NSString *)methodName
                  : (NSDictionary *)params
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject) {
    ExtSdkCallbackObjcRN* callback = [[ExtSdkCallbackObjcRN alloc] initWithResolve:resolve withReject:reject];
    [self callSdkApi:methodName withParams:params withCallback:callback];
}

#pragma mark - Others

- (void)registerSystemNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification*)notification {
    NSLog(@"%@: applicationWillEnterForeground:", TAG);
    [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
}
- (void)applicationDidEnterBackground:(NSNotification*)notification {
    NSLog(@"%@: applicationDidEnterBackground:", TAG);
    [[EMClient sharedClient] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

@end
