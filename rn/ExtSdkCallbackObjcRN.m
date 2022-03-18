//
//  ExtSdkCallbackObjcRN.m
//  im_flutter_sdk
//
//  Created by asterisk on 2022/3/14.
//

#import "ExtSdkCallbackObjcRN.h"
#import "ExtSdkThreadUtilObjc.h"

@interface ExtSdkCallbackObjcRN () {
    RCTPromiseResolveBlock _resolve;
    RCTPromiseRejectBlock _reject;
}

@end

@implementation ExtSdkCallbackObjcRN

- (nonnull instancetype)initWithResolve:(nonnull RCTPromiseResolveBlock)resolve
                             withReject:(nonnull RCTPromiseRejectBlock)reject {
    _resolve = resolve;
    _reject = reject;
    return self;
}

- (void)onFail:(int)code withExtension:(nullable id<NSObject>)ext {
    __weak typeof(self) weakSelf = self;
    [ExtSdkThreadUtilObjc mainThreadExecute:^{
      typeof(self) strongSelf = weakSelf;
      if (!strongSelf) {
          return;
      }
      RCTPromiseRejectBlock callback = [strongSelf getReject];
      if (nil != callback) {
          NSDictionary *map = (NSDictionary *)ext;
          NSDictionary *error = map[@"error"];
          NSNumber *code = error[@"code"];
          NSString *description = error[@"description"];
          callback([NSString stringWithFormat:@"%d", [code intValue]], description, nil);
      }
    }];
}

- (void)onSuccess:(nullable id<NSObject>)data {
    __weak typeof(self) weakSelf = self;
    [ExtSdkThreadUtilObjc mainThreadExecute:^{
      typeof(self) strongSelf = weakSelf;
      if (!strongSelf) {
          return;
      }
      RCTPromiseResolveBlock callback = [strongSelf getResolve];
      if (nil != callback) {
          callback(data);
      }
    }];
}

- (RCTPromiseResolveBlock)getResolve {
    return self->_resolve;
}

- (RCTPromiseRejectBlock)getReject {
    return self->_reject;
}

@end
