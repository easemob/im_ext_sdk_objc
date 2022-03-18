//
//  ExtSdkCallbackObjcFlutter.m
//  im_flutter_sdk
//
//  Created by asterisk on 2022/3/14.
//

#import "ExtSdkCallbackObjcFlutter.h"
#import "ExtSdkChannelManager.h"
#import "ExtSdkThreadUtilObjc.h"

@interface ExtSdkCallbackObjcFlutter () {
    FlutterResult _result;
}

@end

@implementation ExtSdkCallbackObjcFlutter

- (nonnull instancetype)init:(nonnull FlutterResult)result {
    _result = result;
    return self;
}

- (void)onFail:(int)code withExtension:(nullable id<NSObject>)ext {
    __weak typeof(self) weakSelf = self;
    [ExtSdkThreadUtilObjc mainThreadExecute:^{
      typeof(self) strongSelf = weakSelf;
      if (!strongSelf) {
          return;
      }
      FlutterResult _result = [strongSelf getResult];
      if (nil != _result) {
          _result(ext);
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
      FlutterResult _result = [strongSelf getResult];
      if (nil != _result) {
          _result(data);
      }
    }];
}

- (FlutterResult)getResult {
    return self->_result;
}

@end
