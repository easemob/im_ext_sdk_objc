//
//  ExtSdkChatManagerWrapper.h
//
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ExtSdkWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtSdkChatManagerWrapper : ExtSdkWrapper

+ (nonnull instancetype)getInstance;

- (void)initSdk;

- (void)sendMessage:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)resendMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)ackMessageRead:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)ackGroupMessageRead:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;
- (void)ackConversationRead:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)recallMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)getMessageWithMessageId:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)getConversation:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)markAllMessagesAsRead:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)getUnreadMessageCount:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)updateChatMessage:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)importMessages:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)downloadAttachment:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)downloadThumbnail:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)loadAllConversations:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)getConversationsFromServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)deleteConversation:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchHistoryMessages:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchGroupReadAck:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)searchChatMsgFromDB:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)deleteRemoteConversation:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)translateMessage:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchSupportLanguages:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)addReaction:(NSDictionary *)param
     withMethodType:(NSString *)aChannelNameP
             result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeReaction:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchReactionList:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchReactionDetail:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)reportMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)deleteMessagesBeforeTimestamp:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchConversationsFromServerWithPage:(NSDictionary *)param
                              withMethodType:(NSString *)aChannelName
                                      result:(nonnull id<ExtSdkCallbackObjc>)
                                                 result;

- (void)removeMessagesFromServerWithMsgIds:(NSDictionary *)param
                            withMethodType:(NSString *)aChannelName
                                    result:
                                        (nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeMessagesFromServerWithTs:(NSDictionary *)param
                        withMethodType:(NSString *)aChannelName
                                result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchHistoryMessagesByOptions:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result;

@end

NS_ASSUME_NONNULL_END
