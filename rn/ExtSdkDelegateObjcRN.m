//
//  ExtSdkDelegateObjcRN.m
//  im_flutter_sdk
//
//  Created by asterisk on 2022/3/14.
//

#import "ExtSdkDelegateObjcRN.h"
#import "ExtSdkThreadUtilObjc.h"

@interface ExtSdkDelegateObjcRN () {
    NSString* _listenerType;
}

@end

@implementation ExtSdkDelegateObjcRN

- (nonnull NSString *)getType {
    return _listenerType;
}

- (void)onReceive:(nonnull NSString *)methodType withParams:(nullable id<NSObject>)data {
    [ExtSdkThreadUtilObjc mainThreadExecute:^{
        [self sendEventWithName:methodType body:data];
    }];
}

- (void)setType:(nonnull NSString *)listenerType {
    _listenerType = listenerType;
}

@end

