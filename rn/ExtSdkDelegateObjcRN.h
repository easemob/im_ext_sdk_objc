//
//  ExtSdkDelegateObjcRN.h
//  im_flutter_sdk
//
//  Created by asterisk on 2022/3/14.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>
#import "ExtSdkDelegateObjc.h"

@interface ExtSdkDelegateObjcRN : RCTEventEmitter <ExtSdkDelegateObjc>

- (nonnull NSString *)getType;

- (void)onReceive:(nonnull NSString *)methodType withParams:(nullable id<NSObject>)data;

- (void)setType:(nonnull NSString *)listenerType;

@end
