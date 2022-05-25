//
//  ExtSdkChatThreadManagerWrapper.m
//  im_flutter_sdk
//
//  Created by asterisk on 2022/5/25.
//

#import "ExtSdkChatThreadManagerWrapper.h"

@implementation ExtSdkChatThreadManagerWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkChatThreadManagerWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkChatThreadManagerWrapper alloc] init];
    });
    return instance;
}

- (void)fetchChatThread:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)fetchChatThreadDetail:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)fetchJoinedChatThreads:(NSDictionary *)param
                withMethodType:(NSString *)aChannelName
                        result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)fetchChatThreadsWithParentId:(NSDictionary *)param
                      withMethodType:(NSString *)aChannelName
                              result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)fetchChatThreadMember:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)fetchLastMessageWithChatThreads:(NSDictionary *)param
                         withMethodType:(NSString *)aChannelName
                                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)removeMemberFromChatThread:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)updateChatThreadSubject:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)createChatThread:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)joinChatThread:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)leaveChatThread:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

- (void)destroyChatThread:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    // TODO:
}

@end
