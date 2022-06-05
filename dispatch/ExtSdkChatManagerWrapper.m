//
//  ExtSdkChatManagerWrapper.m
//
//
//  Created by 杜洁鹏 on 2019/10/8.
//

#import "ExtSdkChatManagerWrapper.h"
#import "ExtSdkMethodTypeObjc.h"

#import "ExtSdkToJson.h"

@interface ExtSdkChatManagerWrapper () <EMChatManagerDelegate>

@end

@implementation ExtSdkChatManagerWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkChatManagerWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkChatManagerWrapper alloc] init];
    });
    return instance;
}

- (void)initSdk {
    [EMClient.sharedClient.chatManager removeDelegate:self];
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark - Actions

- (void)sendMessage:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {

    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJsonObject:param];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    [EMClient.sharedClient.chatManager sendMessage:msg
        progress:^(int progress) {
          [weakSelf onReceive:aChannelName
                   withParams:@{
                       @"progress" : @(progress),
                       @"localTime" : @(msg.localTime),
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMChatMessage *message, EMError *error) {
          if (error) {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"error" : [error toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"message" : [message toJsonObject],
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"message" : [message toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msg toJsonObject]];
}

- (void)resendMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result {

    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg = [EMChatMessage fromJsonObject:param];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    [EMClient.sharedClient.chatManager resendMessage:msg
        progress:^(int progress) {
          [weakSelf onReceive:aChannelName
                   withParams:@{
                       @"progress" : @(progress),
                       @"localTime" : @(msg.localTime),
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMChatMessage *message, EMError *error) {
          if (error) {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"error" : [error toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"message" : [message toJsonObject],
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"message" : [message toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msg toJsonObject]];
}

- (void)ackMessageRead:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    NSString *to = param[@"to"];
    [EMClient.sharedClient.chatManager sendMessageReadAck:msgId
                                                   toUser:to
                                               completion:^(EMError *aError) {
                                                 [weakSelf onResult:result
                                                     withMethodType:aChannelName
                                                          withError:aError
                                                         withParams:@(!aError)];
                                               }];
}

- (void)ackGroupMessageRead:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    NSString *groupId = param[@"group_id"];
    NSString *content = param[@"content"];
    [EMClient.sharedClient.chatManager
        sendGroupMessageReadAck:msgId
                        toGroup:groupId
                        content:content
                     completion:^(EMError *aError) {
                       [weakSelf onResult:result
                           withMethodType:aChannelName
                                withError:aError
                               withParams:@(!aError)];
                     }];
}

- (void)ackConversationRead:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"convId"];
    [EMClient.sharedClient.chatManager
        ackConversationRead:conversationId
                 completion:^(EMError *aError) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:aError
                           withParams:@(!aError)];
                 }];
}

- (void)recallMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    EMChatMessage *msg =
        [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    if (!msg) {
        EMError *error =
            [EMError errorWithDescription:@"The message was not found"
                                     code:EMErrorMessageInvalid];
        [weakSelf onResult:result
            withMethodType:aChannelName
                 withError:error
                withParams:nil];
        return;
    }
    [EMClient.sharedClient.chatManager
        recallMessageWithMessageId:msgId
                        completion:^(EMError *aError) {
                          [weakSelf onResult:result
                              withMethodType:aChannelName
                                   withError:aError
                                  withParams:@(!aError)];
                        }];
}

- (void)getMessageWithMessageId:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *msgId = param[@"msg_id"];
    EMChatMessage *msg =
        [EMClient.sharedClient.chatManager getMessageWithMessageId:msgId];
    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msg toJsonObject]];
}

- (void)getConversation:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *conId = param[@"convId"];
    EMConversationType type =
        [EMConversation typeFromInt:[param[@"convType"] intValue]];
    BOOL needCreate = [param[@"createIfNeed"] boolValue];
    EMConversation *con =
        [EMClient.sharedClient.chatManager getConversation:conId
                                                      type:type
                                          createIfNotExist:needCreate];

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[con toJsonObject]];
}

- (void)markAllMessagesAsRead:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSArray *conList = [EMClient.sharedClient.chatManager getAllConversations];
    EMError *error = nil;
    for (EMConversation *con in conList) {
        [con markAllMessagesAsRead:&error];
        if (error) {
            break;
        }
    }

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:error
            withParams:nil];
}

- (void)getUnreadMessageCount:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSArray *conList = [EMClient.sharedClient.chatManager getAllConversations];
    int unreadCount = 0;
    EMError *error = nil;
    for (EMConversation *con in conList) {
        unreadCount += con.unreadMessagesCount;
    }

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:error
            withParams:@(unreadCount)];
}

- (void)updateChatMessage:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    EMChatMessage *msg = [EMChatMessage fromJsonObject:param[@"message"]];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    [EMClient.sharedClient.chatManager
        updateMessage:msg
           completion:^(EMChatMessage *aMessage, EMError *aError) {
             [weakSelf onResult:result
                 withMethodType:aChannelName
                      withError:aError
                     withParams:[aMessage toJsonObject]];
           }];
}

- (void)importMessages:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSArray *dictAry = param[@"messages"];
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *dict in dictAry) {
        [messages addObject:[EMChatMessage fromJsonObject:dict]];
    }
    [[EMClient sharedClient].chatManager importMessages:messages
                                             completion:^(EMError *aError) {
                                               [weakSelf onResult:result
                                                   withMethodType:aChannelName
                                                        withError:aError
                                                       withParams:@(!aError)];
                                             }];
}

- (void)downloadAttachment:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg =
        [EMChatMessage fromJsonObject:param[@"message"]];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    EMChatMessage *needDownMSg = [EMClient.sharedClient.chatManager
        getMessageWithMessageId:msg.messageId];
    [EMClient.sharedClient.chatManager downloadMessageAttachment:needDownMSg
        progress:^(int progress) {
          [weakSelf onReceive:aChannelName
                   withParams:@{
                       @"progress" : @(progress),
                       @"localTime" : @(msg.localTime),
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMChatMessage *message, EMError *error) {
          if (error) {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"error" : [error toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"message" : [message toJsonObject],
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"message" : [message toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msg toJsonObject]];
}

- (void)downloadThumbnail:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    __block EMChatMessage *msg =
        [EMChatMessage fromJsonObject:param[@"message"]];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    EMChatMessage *needDownMSg = [EMClient.sharedClient.chatManager
        getMessageWithMessageId:msg.messageId];
    [EMClient.sharedClient.chatManager downloadMessageThumbnail:needDownMSg
        progress:^(int progress) {
          [weakSelf onReceive:aChannelName
                   withParams:@{
                       @"progress" : @(progress),
                       @"localTime" : @(msg.localTime),
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMChatMessage *message, EMError *error) {
          if (error) {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"error" : [error toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"message" : [message toJsonObject],
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:aChannelName
                       withParams:@{
                           @"message" : [message toJsonObject],
                           @"localTime" : @(msg.localTime),
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];

    [weakSelf onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:[msg toJsonObject]];
}

- (void)loadAllConversations:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSArray *conversations =
        [EMClient.sharedClient.chatManager getAllConversations];
    NSArray *sortedList = [conversations
        sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1,
                                                       id _Nonnull obj2) {
          if (((EMConversation *)obj1).latestMessage.timestamp >
              ((EMConversation *)obj2).latestMessage.timestamp) {
              return NSOrderedAscending;
          } else {
              return NSOrderedDescending;
          }
        }];
    NSMutableArray *conList = [NSMutableArray array];
    for (EMConversation *conversation in sortedList) {
        [conList addObject:[conversation toJsonObject]];
    }

    [self onResult:result
        withMethodType:aChannelName
             withError:nil
            withParams:conList];
}

- (void)getConversationsFromServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        getConversationsFromServer:^(NSArray *aCoversations, EMError *aError) {
          NSArray *sortedList = [aCoversations
              sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1,
                                                             id _Nonnull obj2) {
                if (((EMConversation *)obj1).latestMessage.timestamp >
                    ((EMConversation *)obj2).latestMessage.timestamp) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
              }];
          NSMutableArray *conList = [NSMutableArray array];
          for (EMConversation *conversation in sortedList) {
              [conList addObject:[conversation toJsonObject]];
          }

          [weakSelf onResult:result
              withMethodType:aChannelName
                   withError:nil
                  withParams:conList];
        }];
}

- (void)deleteConversation:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"convId"];
    BOOL isDeleteMsgs = [param[@"deleteMessages"] boolValue];
    [EMClient.sharedClient.chatManager
        deleteConversation:conversationId
          isDeleteMessages:isDeleteMsgs
                completion:^(NSString *aConversationId, EMError *aError) {
                  [weakSelf onResult:result
                      withMethodType:aChannelName
                           withError:aError
                          withParams:@(!aError)];
                }];
}

- (void)fetchHistoryMessages:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"convId"];
    EMConversationType type = (EMConversationType)[param[@"convType"] intValue];
    int pageSize = [param[@"pageSize"] intValue];
    NSString *startMsgId = param[@"startMsgId"];
    [EMClient.sharedClient.chatManager
        asyncFetchHistoryMessagesFromServer:conversationId
                           conversationType:type
                             startMessageId:startMsgId
                                   pageSize:pageSize
                                 completion:^(EMCursorResult *aResult,
                                              EMError *aError) {
                                   [weakSelf onResult:result
                                       withMethodType:aChannelName
                                            withError:aError
                                           withParams:[aResult toJsonObject]];
                                 }];
}

- (void)fetchGroupReadAck:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msg_id"];
    int pageSize = [param[@"pageSize"] intValue];
    NSString *ackId = param[@"ack_id"];
    NSString *groupId = param[@"group_id"];

    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        asyncFetchGroupMessageAcksFromServer:msgId
                                     groupId:groupId
                             startGroupAckId:ackId
                                    pageSize:pageSize
                                  completion:^(EMCursorResult *aResult,
                                               EMError *aError,
                                               int totalCount) {
                                    [weakSelf onResult:result
                                        withMethodType:aChannelName
                                             withError:aError
                                            withParams:[aResult toJsonObject]];
                                  }];
}

- (void)searchChatMsgFromDB:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *keywords = param[@"keywords"];
    long long timeStamp = [param[@"timeStamp"] longLongValue];
    int maxCount = [param[@"maxCount"] intValue];
    NSString *from = param[@"from"];
    EMMessageSearchDirection direction =
        [self searchDirectionFromString:param[@"direction"]];
    [EMClient.sharedClient.chatManager
        loadMessagesWithKeyword:keywords
                      timestamp:timeStamp
                          count:maxCount
                       fromUser:from
                searchDirection:direction
                     completion:^(NSArray *aMessages, EMError *aError) {
                       NSMutableArray *msgList = [NSMutableArray array];
                       for (EMChatMessage *msg in aMessages) {
                           [msgList addObject:[msg toJsonObject]];
                       }

                       [weakSelf onResult:result
                           withMethodType:aChannelName
                                withError:aError
                               withParams:msgList];
                     }];
}

- (void)deleteRemoteConversation:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = param[@"conversationId"];
    EMConversationType type = EMConversationTypeChat;
    BOOL isDeleteRemoteMessage = [param[@"isDeleteRemoteMessage"] boolValue];
    int intType = [param[@"conversationType"] intValue];
    if (intType == 0) {
        type = EMConversationTypeChat;
    } else if (intType == 1) {
        type = EMConversationTypeGroupChat;
    } else {
        type = EMConversationTypeChatRoom;
    }

    [EMClient.sharedClient.chatManager
        deleteServerConversation:conversationId
                conversationType:type
          isDeleteServerMessages:isDeleteRemoteMessage
                      completion:^(NSString *aConversationId, EMError *aError) {
                        [weakSelf onResult:result
                            withMethodType:aChannelName
                                 withError:aError
                                withParams:@(!aError)];
                      }];
}

- (void)translateMessage:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    EMChatMessage *msg = [EMChatMessage fromJsonObject:param[@"message"]];
    NSArray *languages = param[@"languages"];

    if ([self checkMessageParams:result
                  withMethodType:aChannelName
                     withMessage:msg]) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        translateMessage:msg
         targetLanguages:languages
              completion:^(EMChatMessage *message, EMError *error) {
                [weakSelf onResult:result
                    withMethodType:aChannelName
                         withError:error
                        withParams:@{@"message" : [message toJsonObject]}];
              }];
}

- (void)fetchSupportLanguages:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        fetchSupportedLangurages:^(
            NSArray<EMTranslateLanguage *> *_Nullable languages,
            EMError *_Nullable error) {
          [weakSelf onResult:result
              withMethodType:aChannelName
                   withError:error
                  withParams:[languages toJsonArray]];
        }];
}

- (void)addReaction:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *reaction = param[@"reaction"];
    NSString *msgId = param[@"msgId"];
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager addReaction:reaction
                                         toMessage:msgId
                                        completion:^(EMError *error) {
                                          [weakSelf onResult:result
                                              withMethodType:aChannelName
                                                   withError:error
                                                  withParams:nil];
                                        }];
}

- (void)removeReaction:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *reaction = param[@"reaction"];
    NSString *msgId = param[@"msgId"];
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager removeReaction:reaction
                                          fromMessage:msgId
                                           completion:^(EMError *error) {
                                             [weakSelf onResult:result
                                                 withMethodType:aChannelName
                                                      withError:error
                                                     withParams:nil];
                                           }];
}

- (void)fetchReactionList:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSArray *msgIds = param[@"msgIds"];
    NSString *groupId = param[@"groupId"];
    EMChatType type =
        [EMChatMessage chatTypeFromInt:[param[@"chatType"] intValue]];
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        getReactionList:msgIds
                groupId:groupId
               chatType:type
             completion:^(NSDictionary<NSString *, NSArray *> *dic,
                          EMError *error) {
               NSMutableDictionary *dictionary =
                   [NSMutableDictionary dictionary];
               for (NSString *key in dic.allKeys) {
                   NSArray *ary = dic[key];
                   NSMutableArray *list = [NSMutableArray array];
                   for (EMMessageReaction *reaction in ary) {
                       [list addObject:[reaction toJsonObject]];
                   }
                   dictionary[key] = list;
               }

               [weakSelf onResult:result
                   withMethodType:aChannelName
                        withError:error
                       withParams:dictionary];
             }];
}

- (void)fetchReactionDetail:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msgId"];
    NSString *reaction = param[@"reaction"];
    NSString *cursor = param[@"cursor"];
    int pageSize = 50;
    if (param[@"pageSize"] != nil) {
        pageSize = [param[@"pageSize"] intValue];
    }
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        getReactionDetail:msgId
                 reaction:reaction
                   cursor:cursor
                 pageSize:pageSize
               completion:^(EMMessageReaction *reaction,
                            NSString *_Nullable cursor, EMError *error) {
                 EMCursorResult *cursorResult = nil;
                 if (error == nil) {
                     cursorResult =
                         [EMCursorResult cursorResultWithList:@[ reaction ]
                                                    andCursor:cursor];
                 }

                 [weakSelf onResult:result
                     withMethodType:aChannelName
                          withError:error
                         withParams:[cursorResult toJsonObject]];
               }];
}

- (void)reportMessage:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result {
    NSString *msgId = param[@"msgId"];
    NSString *tag = param[@"tag"];
    NSString *reason = param[@"reason"];
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.chatManager
        reportMessageWithId:msgId
                        tag:tag
                     reason:reason
                 completion:^(EMError *error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:nil];
                 }];
}

#pragma mark - EMChatManagerDelegate

- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [self onReceive:ExtSdkMethodKeyOnConversationUpdate withParams:nil];
}

- (void)onConversationRead:(NSString *)from to:(NSString *)to {
    [self onReceive:ExtSdkMethodKeyOnConversationHasRead
         withParams:@{@"from" : from, @"to" : to}];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    NSMutableArray *msgList = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        [msgList addObject:[msg toJsonObject]];
    }
    [self onReceive:ExtSdkMethodKeyOnMessagesReceived withParams:msgList];
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    NSMutableArray *cmdMsgList = [NSMutableArray array];
    for (EMChatMessage *msg in aCmdMessages) {
        [cmdMsgList addObject:[msg toJsonObject]];
    }

    [self onReceive:ExtSdkMethodKeyOnCmdMessagesReceived withParams:cmdMsgList];
}

- (void)messagesDidRead:(NSArray *)aMessages {
    NSMutableArray *list = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        NSDictionary *json = [msg toJsonObject];
        [list addObject:json];
        [self onReceive:ExtSdkMethodKeyOnMessageReadAck withParams:json];
    }

    [self onReceive:ExtSdkMethodKeyOnMessagesRead withParams:list];
}

- (void)messagesDidDeliver:(NSArray *)aMessages {
    NSMutableArray *list = [NSMutableArray array];
    for (EMChatMessage *msg in aMessages) {
        NSDictionary *json = [msg toJsonObject];
        [list addObject:json];
        [self onReceive:ExtSdkMethodKeyOnMessageDeliveryAck
             withParams:@{@"message" : json}];
    }

    [self onReceive:ExtSdkMethodKeyOnMessagesDelivered withParams:list];
}

- (void)messagesInfoDidRecall:
    (NSArray<EMRecallMessageInfo *> *)aRecallMessagesInfo {
    NSMutableArray *list = [NSMutableArray array];
    for (EMRecallMessageInfo *info in aRecallMessagesInfo) {
        [list addObject:[info.recallMessage toJsonObject]];
    }

    [self onReceive:ExtSdkMethodKeyOnMessagesRecalled withParams:list];
}

- (void)messageStatusDidChange:(EMChatMessage *)aMessage
                     withError:(EMError *)aError {
}

// TODO: 安卓未找到对应回调
- (void)messageAttachmentStatusDidChange:(EMChatMessage *)aMessage
                               withError:(EMError *)aError {
}

- (void)groupMessageDidRead:(EMChatMessage *)aMessage
                  groupAcks:(NSArray *)aGroupAcks {
    NSMutableArray *list = [NSMutableArray array];
    for (EMGroupMessageAck *ack in aGroupAcks) {
        NSDictionary *json = [ack toJsonObject];
        [list addObject:json];
    }

    [self onReceive:ExtSdkMethodKeyOnGroupMessageRead withParams:list];
}

- (EMMessageSearchDirection)searchDirectionFromString:(NSString *)aDirection {
    return [aDirection isEqualToString:@"up"] ? EMMessageSearchDirectionUp
                                              : EMMessageSearchDirectionDown;
}

- (void)groupMessageAckHasChanged {
    [self onReceive:ExtSdkMethodKeyChatOnReadAckForGroupMessageUpdated
         withParams:nil];
}

- (void)messageReactionDidChange:(NSArray<EMMessageReactionChange *> *)changes {
    NSMutableArray *list = [NSMutableArray array];
    for (EMMessageReactionChange *change in changes) {
        [list addObject:[change toJsonObject]];
    }

    [self onReceive:ExtSdkMethodKeyChatOnMessageReactionDidChange
         withParams:list];
}

@end
