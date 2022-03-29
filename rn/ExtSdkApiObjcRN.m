//
//  ExtSdkApiObjcRN.m
//  react-native-easemob
//
//  Created by asterisk on 2022/3/29.
//

#import "ExtSdkApiObjcRN.h"
#import "ExtSdkCallbackObjcRN.h"
#import "ExtSdkDelegateObjcRN.h"
#import "ExtSdkThreadUtilObjc.h"
#import <HyphenateChat/EMClient.h>
#import <UIKit/UIApplication.h>

static NSString *const TAG = @"ExtSdkApiRN";

@implementation ExtSdkApiRN (Objc)

- (instancetype)init {
    //    if (super = [super init]) {
    [self registerSystemNotify];
    //    }
    return self;
}

#pragma mark - RCTBridgeModule

RCT_EXPORT_MODULE(ExtSdkApiRN)

RCT_EXPORT_METHOD(callMethod
                  : (NSString *)methodName
                  : (NSDictionary *)params
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject) {
    id<ExtSdkCallbackObjc> callback = [[ExtSdkCallbackObjcRN alloc] initWithResolve:resolve withReject:reject];
    __weak typeof(self) weakself = self; // TODO: 后续解决 mm文件无法使用typeof关键字: 使用分类方式解决
    [ExtSdkThreadUtilObjc asyncExecute:^{
      [weakself callSdkApi:methodName withParams:params withCallback:callback];
    }];
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

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    NSLog(@"%@: applicationWillEnterForeground:", TAG);
    [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
}
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"%@: applicationDidEnterBackground:", TAG);
    [[EMClient sharedClient] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

@end
