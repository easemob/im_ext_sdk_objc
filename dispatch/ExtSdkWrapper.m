//
//  ExtSdkWrapper.m
//
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ExtSdkWrapper.h"
#import "ExtSdkDispatch.h"
#import "ExtSdkToJson.h"

#define easemob_dispatch_main_async_safe(block)                                \
    if ([NSThread isMainThread]) {                                             \
        block();                                                               \
    } else {                                                                   \
        dispatch_async(dispatch_get_main_queue(), block);                      \
    }

static NSString *const TAG = @"ExtSdkWrapper";
@implementation ExtSdkWrapper

- (void)onResult:(nonnull id<ExtSdkCallbackObjc>)result
    withMethodType:(nonnull NSString *)methodType
         withError:(nullable EMError *)error
        withParams:(nullable NSObject *)params {
    NSLog(@"%@: onResult: %@, %@, %@", TAG, methodType,
          error ? [error toJsonObject] : @"", params ? params : @"");
    if (nil == error) {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (params) {
            data[methodType] = params;
        }
        [result onSuccess:data];
    } else {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"error"] = [error toJsonObject];
        [result onFail:error.code withExtension:data];
    }
}

- (void)onReceive:(NSString *)methodType
       withParams:(nullable NSObject *)params {
    [[ExtSdkDispatch getInstance] onReceive:methodType withParams:params];
}

- (BOOL)checkMessageParams:(nonnull id<ExtSdkCallbackObjc>)result
            withMethodType:(nonnull NSString *)methodType
               withMessage:(nullable EMChatMessage *)message {
    if (message == nil) {
        [self onResult:result
            withMethodType:methodType
                 withError:[EMError errorWithDescription:
                                        @"The message does not exist."
                                                    code:1]
                withParams:nil];
        return YES;
    }
    return NO;
}

@end
