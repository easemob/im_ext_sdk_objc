//
//  ExtSdkChatMessageWrapper.m
//  im_flutter_sdk
//
//  Created by asterisk on 2022/5/25.
//

#import "ExtSdkChatMessageWrapper.h"
#import "ExtSdkToJson.h"

@implementation ExtSdkChatMessageWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkChatMessageWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkChatMessageWrapper alloc] init];
    });
    return instance;
}

- (void)getReaction:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msgId"];
    NSString *reaction = param[@"reaction"];
    EMChatMessage *msg =
        [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    EMMessageReaction *msgReaction = [msg getReaction:reaction];
    [self onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msgReaction toJsonObject]];
}

- (void)getReactionList:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msgId"];
    EMChatMessage *msg =
        [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    NSMutableArray *list = [NSMutableArray array];
    for (EMMessageReaction *reaction in msg.reactionList) {
        [list addObject:[reaction toJsonObject]];
    }
    [self onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:list];
}

- (void)getGroupAckCount:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msgId"];
    EMChatMessage *msg =
        [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    if (msg != nil) {
        [self onResult:result
            withMethodType:aChannelName
                 withError:nil
                withParams:@(msg.groupAckCount ?: 0)];
    } else {
        [self onResult:result
            withMethodType:aChannelName
                 withError:[EMError
                               errorWithDescription:@"No message was found."
                                               code:1]
                withParams:nil];
    }
}

@end
