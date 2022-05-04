//
//  ExtSdkPresenceManagerWrapper.m
//  im_flutter_sdk
//
//  Created by 佐玉 on 2022/5/4.
//

#import "ExtSdkPresenceManagerWrapper.h"

@interface ExtSdkPresenceManagerWrapper () <EMPresenceManagerDelegate>

@end

@implementation ExtSdkPresenceManagerWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkPresenceManagerWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkPresenceManagerWrapper alloc] init];
    });
    return instance;
}

- (void)initSdk {
    [EMClient.sharedClient.presenceManager removeDelegate:self];
    [EMClient.sharedClient.presenceManager addDelegate:self delegateQueue:nil];
}

- (void)publishPresenceWithDescription:(NSDictionary *)param
                           channelName:(NSString *)aChannelName
                                result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *desc = param[@"desc"];
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.presenceManager
        publishPresenceWithDescription:desc
                            completion:^(EMError *error) {
                              [weakSelf onResult:result
                                  withMethodType:aChannelName
                                       withError:error
                                      withParams:nil];
                            }];
}

- (void)subscribe:(NSArray<NSString *> *)members
           expiry:(NSInteger)expiry
       completion:(void (^)(NSArray<EMPresence *> *presences,
                            EMError *error))aCompletion {
}

- (void)unsubscribe:(NSArray<NSString *> *)members
         completion:(void (^)(EMError *error))aCompletion {
}

- (void)fetchSubscribedMembersWithPageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                               Completion:
                                   (void (^)(NSArray<NSString *> *members,
                                             EMError *error))aCompletion {
}

- (void)fetchPresenceStatus:(NSArray<NSString *> *)members
                 completion:(void (^)(NSArray<EMPresence *> *presences,
                                      EMError *error))aCompletion {
}

- (void)presenceStatusDidChanged:(NSArray<EMPresence *> *)presences {
}

@end
