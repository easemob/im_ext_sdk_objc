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

static NSString *const TAG = @"ExtSdkApiRN";

@implementation ExtSdkApiRN (Objc)

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

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

@end
