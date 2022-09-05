//
//  ExtSdkCircleManagerWrapper.m
//  react-native-chat-sdk
//
//  Created by asterisk on 2022/8/24.
//

#import "ExtSdkCircleManagerWrapper.h"
#import "ExtSdkMethodTypeObjc.h"
#import "ExtSdkToJson.h"

@interface ExtSdkCircleManagerWrapper () <EMCircleManagerServerDelegate,
                                   EMCircleManagerChannelDelegate>

@end

@implementation ExtSdkCircleManagerWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkCircleManagerWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkCircleManagerWrapper alloc] init];
    });
    return instance;
}

- (void)initSdk {
    [EMClient.sharedClient.circleManager removeChannelDelegate:self];
    [EMClient.sharedClient.circleManager addChannelDelegate:self queue:nil];
    [EMClient.sharedClient.circleManager removeServerDelegate:self];
    [EMClient.sharedClient.circleManager addServerDelegate:self queue:nil];
}

- (void)createCircleServer:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    EMCircleServerAttribute *attribute = [[EMCircleServerAttribute alloc] init];
    attribute.name = param[@"serverName"];
    attribute.icon = param[@"serverIcon"];
    attribute.desc = param[@"serverDescription"];
    attribute.ext = param[@"serverExtension"];
    [EMClient.sharedClient.circleManager
        createServer:attribute
          completion:^(EMCircleServer *_Nullable server,
                       EMError *_Nullable error) {
            [weakSelf onResult:result
                withMethodType:aChannelName
                     withError:error
                    withParams:[server toJsonObject]];
          }];
}

- (void)destroyCircleServer:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        destroyServer:serverId
           completion:^(EMError *_Nullable error) {
             [weakSelf onResult:result
                 withMethodType:aChannelName
                      withError:error
                     withParams:nil];
           }];
}

- (void)updateCircleServer:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    EMCircleServerAttribute *attribute = [[EMCircleServerAttribute alloc] init];
    if (param[@"serverName"] != nil) {
        attribute.name = param[@"serverName"];
    }
    if (param[@"serverIcon"] != nil) {
        attribute.icon = param[@"serverIcon"];
    }
    if (param[@"serverDescription"]) {
        attribute.desc = param[@"serverDescription"];
    }
    if (param[@"serverExtension"] != nil) {
        attribute.ext = param[@"serverExtension"];
    }
    [EMClient.sharedClient.circleManager
        updateServer:serverId
           attribute:attribute
          completion:^(EMCircleServer *_Nullable server,
                       EMError *_Nullable error) {
            [weakSelf onResult:result
                withMethodType:aChannelName
                     withError:error
                    withParams:[server toJsonObject]];
          }];
}

- (void)joinCircleServer:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        joinServer:serverId
        completion:^(EMCircleServer *_Nullable server,
                     EMError *_Nullable error) {
          [weakSelf onResult:result
              withMethodType:aChannelName
                   withError:error
                  withParams:nil];
        }];
}

- (void)leaveCircleServer:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        leaveServer:serverId
         completion:^(EMError *_Nullable error) {
           [weakSelf onResult:result
               withMethodType:aChannelName
                    withError:error
                   withParams:nil];
         }];
}

- (void)removeUserFromCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        removeUserFromServer:serverId
                      userId:userId
                  completion:^(EMError *_Nullable error) {
                    [weakSelf onResult:result
                        withMethodType:aChannelName
                             withError:error
                            withParams:nil];
                  }];
}

- (void)inviteUserToCircleServer:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *userId = param[@"userId"];
    NSString *welcome = param[@"welcome"];
    [EMClient.sharedClient.circleManager
        inviteUserToServer:serverId
                    userId:userId
                   welcome:welcome
                completion:^(EMError *_Nullable error) {
                  [weakSelf onResult:result
                      withMethodType:aChannelName
                           withError:error
                          withParams:nil];
                }];
}

- (void)acceptCircleServerInvitation:(NSDictionary *)param
                      withMethodType:(NSString *)aChannelName
                              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *inviter = param[@"inviter"];
    [EMClient.sharedClient.circleManager
        acceptServerInvitation:serverId
                       inviter:inviter
                    completion:^(EMCircleServer *_Nullable server,
                                 EMError *_Nullable error) {
                      [weakSelf onResult:result
                          withMethodType:aChannelName
                               withError:error
                              withParams:[server toJsonObject]];
                    }];
}

- (void)declineCircleServerInvitation:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *inviter = param[@"inviter"];
    [EMClient.sharedClient.circleManager
        declineServerInvitation:serverId
                        inviter:inviter
                     completion:^(EMError *_Nullable error) {
                       [weakSelf onResult:result
                           withMethodType:aChannelName
                                withError:error
                               withParams:nil];
                     }];
}

- (void)addTagsToCircleServer:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSArray<NSString *> *tags = param[@"serverTags"];
    [EMClient.sharedClient.circleManager
        addTagsToServer:serverId
                   tags:tags
             completion:^(NSArray<EMCircleServerTag *> *_Nullable tags,
                          EMError *_Nullable error) {
               NSMutableArray<NSDictionary *> *jsonTags =
                   [NSMutableArray array];
               for (EMCircleServerTag *item in tags) {
                   [jsonTags addObject:[item toJsonObject]];
               }
               [weakSelf onResult:result
                   withMethodType:aChannelName
                        withError:error
                       withParams:jsonTags];
             }];
}

- (void)removeTagsFromCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSArray<NSString *> *tags = param[@"serverTags"];
    [EMClient.sharedClient.circleManager
        removeTagsFromServer:serverId
                      tagIds:tags
                  completion:^(EMError *_Nullable error) {
                    [weakSelf onResult:result
                        withMethodType:aChannelName
                             withError:error
                            withParams:nil];
                  }];
}

- (void)fetchCircleServerTags:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        fetchServerTags:serverId
             completion:^(NSArray<EMCircleServerTag *> *_Nullable tags,
                          EMError *_Nullable error) {
               NSMutableArray<NSDictionary *> *jsonTags =
                   [NSMutableArray array];
               for (EMCircleServerTag *item in tags) {
                   [jsonTags addObject:[item toJsonObject]];
               }
               [weakSelf onResult:result
                   withMethodType:aChannelName
                        withError:error
                       withParams:jsonTags];
             }];
}

- (void)addModeratorToCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        addModeratorToServer:serverId
                      userId:userId
                  completion:^(EMError *_Nullable error) {
                    [weakSelf onResult:result
                        withMethodType:aChannelName
                             withError:error
                            withParams:nil];
                  }];
}

- (void)removeModeratorFromCircleServer:(NSDictionary *)param
                         withMethodType:(NSString *)aChannelName
                                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        removeModeratorFromServer:serverId
                           userId:userId
                       completion:^(EMError *_Nullable error) {
                         [weakSelf onResult:result
                             withMethodType:aChannelName
                                  withError:error
                                 withParams:nil];
                       }];
}

- (void)fetchSelfCircleServerRole:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        fetchSelfServerRole:serverId
                 completion:^(EMCircleUserRole role, EMError *_Nullable error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:@([EMCircleUser userRoleTypeToInt:role])];
                 }];
}

- (void)fetchJoinedCircleServers:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *cursor = param[@"cursor"];
    NSNumber *limit = param[@"pageSize"];
    [EMClient.sharedClient.circleManager
        fetchJoinedServers:limit.intValue
                    cursor:cursor
                completion:^(EMCursorResult<EMCircleServer *> *_Nullable ret,
                             EMError *_Nullable error) {
                  [weakSelf onResult:result
                      withMethodType:aChannelName
                           withError:error
                          withParams:[ret toJsonObject]];
                }];
}

- (void)fetchCircleServerDetail:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        fetchServerDetail:serverId
               completion:^(EMCircleServer *_Nullable server,
                            EMError *_Nullable error) {
                 [weakSelf onResult:result
                     withMethodType:aChannelName
                          withError:error
                         withParams:[server toJsonObject]];
               }];
}

- (void)fetchCircleServersWithKeyword:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *keyword = param[@"keyword"];
    [EMClient.sharedClient.circleManager
        fetchServersWithKeyword:keyword
                     completion:^(NSArray<EMCircleServer *> *_Nullable servers,
                                  EMError *_Nullable error) {
                       NSMutableArray *jsonServers = [NSMutableArray array];
                       for (EMCircleServer *item in servers) {
                           [jsonServers addObject:[item toJsonObject]];
                       }
                       [weakSelf onResult:result
                           withMethodType:aChannelName
                                withError:error
                               withParams:jsonServers];
                     }];
}

- (void)fetchCircleServerMembers:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSNumber *limit = param[@"pageSize"];
    NSString *cursor = param[@"cursor"];
    [EMClient.sharedClient.circleManager
        fetchServerMembers:serverId
                     limit:limit.intValue
                    cursor:cursor
                completion:^(EMCursorResult<EMCircleUser *> *_Nullable ret,
                             EMError *_Nullable error) {
                  [weakSelf onResult:result
                      withMethodType:aChannelName
                           withError:error
                          withParams:[ret toJsonObject]];
                }];
}

- (void)checkSelfInCircleServer:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    [EMClient.sharedClient.circleManager
        checkSelfIsInServer:serverId
                 completion:^(BOOL isJoined, EMError *_Nullable error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:@(isJoined)];
                 }];
}

- (void)createCircleChannel:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSNumber *channelType = param[@"channelType"];
    EMCircleChannelAttribute *attribute =
        [[EMCircleChannelAttribute alloc] init];
    attribute.name = param[@"channelName"];
    attribute.desc = param[@"channelDescription"];
    attribute.ext = param[@"channelExtension"];
    attribute.rank =
        [EMCircleChannel rankFromInt:[param[@"channelRank"] integerValue]];
    EMCircleChannelType channelTypeEnum =
        [EMCircleChannel typeFromInt:[channelType integerValue]];
    [EMClient.sharedClient.circleManager
        createChannel:serverId
            attribute:attribute
                 type:channelTypeEnum
           completion:^(EMCircleChannel *_Nullable channel,
                        EMError *_Nullable error) {
             [weakSelf onResult:result
                 withMethodType:aChannelName
                      withError:error
                     withParams:[channel toJsonObject]];
           }];
}

- (void)destroyCircleChannel:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        destroyChannel:serverId
             channelId:channelId
            completion:^(EMError *_Nullable error) {
              [weakSelf onResult:result
                  withMethodType:aChannelName
                       withError:error
                      withParams:nil];
            }];
}

- (void)updateCircleChannel:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    EMCircleChannelAttribute *attribute =
        [[EMCircleChannelAttribute alloc] init];
    if (param[@"channelName"] != nil) {
        attribute.name = param[@"channelName"];
    }
    if (param[@"channelDescription"] != nil) {
        attribute.desc = param[@"channelDescription"];
    }
    if (param[@"channelExtension"] != nil) {
        attribute.ext = param[@"channelExtension"];
    }
    if (param[@"channelRank"] != nil) {
        attribute.rank =
            [EMCircleChannel rankFromInt:[param[@"channelRank"] integerValue]];
    }
    [EMClient.sharedClient.circleManager
        updateChannel:serverId
            channelId:channelId
            attribute:attribute
           completion:^(EMCircleChannel *_Nullable channel,
                        EMError *_Nullable error) {
             [weakSelf onResult:result
                 withMethodType:aChannelName
                      withError:error
                     withParams:[channel toJsonObject]];
           }];
}

- (void)joinCircleChannel:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        joinChannel:serverId
          channelId:channelId
         completion:^(EMCircleChannel *_Nullable channel,
                      EMError *_Nullable error) {
           [weakSelf onResult:result
               withMethodType:aChannelName
                    withError:error
                   withParams:[channel toJsonObject]];
         }];
}

- (void)leaveCircleChannel:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        leaveChannel:serverId
           channelId:channelId
          completion:^(EMError *_Nullable error) {
            [weakSelf onResult:result
                withMethodType:aChannelName
                     withError:error
                    withParams:nil];
          }];
}

- (void)removeUserFromCircleChannel:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        removeUserFromChannel:serverId
                    channelId:channelId
                       userId:userId
                   completion:^(EMError *_Nullable error) {
                     [weakSelf onResult:result
                         withMethodType:aChannelName
                              withError:error
                             withParams:nil];
                   }];
}

- (void)inviteUserToCircleChannel:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSString *userId = param[@"userId"];
    NSString *welcome = param[@"welcome"];
    [EMClient.sharedClient.circleManager
        inviteUserToChannel:serverId
                  channelId:channelId
                     userId:userId
                    welcome:welcome
                 completion:^(EMError *_Nullable error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:nil];
                 }];
}

- (void)acceptCircleChannelInvitation:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSString *inviter = param[@"inviter"];
    [EMClient.sharedClient.circleManager
        acceptChannelInvitation:serverId
                      channelId:channelId
                        inviter:inviter
                     completion:^(EMCircleChannel *_Nullable channel,
                                  EMError *_Nullable error) {
                       [weakSelf onResult:result
                           withMethodType:aChannelName
                                withError:error
                               withParams:[channel toJsonObject]];
                     }];
}

- (void)declineCircleChannelInvitation:(NSDictionary *)param
                        withMethodType:(NSString *)aChannelName
                                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSString *inviter = param[@"inviter"];
    [EMClient.sharedClient.circleManager
        declineChannelInvitation:serverId
                       channelId:channelId
                         inviter:inviter
                      completion:^(EMError *_Nullable error) {
                        [weakSelf onResult:result
                            withMethodType:aChannelName
                                 withError:error
                                withParams:nil];
                      }];
}

- (void)muteUserInCircleChannel:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSNumber *duration = param[@"duration"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        muteUserInChannel:userId
                 serverId:serverId
                channelId:channelId
                 duration:[duration integerValue]
               completion:^(EMError *_Nullable error) {
                 [weakSelf onResult:result
                     withMethodType:aChannelName
                          withError:error
                         withParams:nil];
               }];
}

- (void)unmuteUserInCircleChannel:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSString *userId = param[@"userId"];
    [EMClient.sharedClient.circleManager
        unmuteUserInChannel:userId
                   serverId:serverId
                  channelId:channelId
                 completion:^(EMError *_Nullable error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:nil];
                 }];
}

- (void)fetchCircleChannelDetail:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        fetchChannelDetail:serverId
                 channelId:channelId
                completion:^(EMCircleChannel *_Nullable channel,
                             EMError *_Nullable error) {
                  [weakSelf onResult:result
                      withMethodType:aChannelName
                           withError:error
                          withParams:[channel toJsonObject]];
                }];
}

- (void)fetchPublicCircleChannelInServer:(NSDictionary *)param
                          withMethodType:(NSString *)aChannelName
                                  result:
                                      (nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSNumber *limit = param[@"pageSize"];
    NSString *cursor = param[@"cursor"];
    [EMClient.sharedClient.circleManager
        fetchPublicChannelsInServer:serverId
                              limit:[limit integerValue]
                             cursor:cursor
                         completion:^(
                             EMCursorResult<EMCircleChannel *> *_Nullable ret,
                             EMError *_Nullable error) {
                           [weakSelf onResult:result
                               withMethodType:aChannelName
                                    withError:error
                                   withParams:[ret toJsonObject]];
                         }];
}

- (void)fetchCircleChannelMembers:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    NSNumber *limit = param[@"pageSize"];
    NSString *cursor = param[@"cursor"];
    [EMClient.sharedClient.circleManager
        fetchChannelMembers:serverId
                  channelId:channelId
                      limit:[limit integerValue]
                     cursor:cursor
                 completion:^(EMCursorResult<EMCircleUser *> *_Nullable ret,
                              EMError *_Nullable error) {
                   [weakSelf onResult:result
                       withMethodType:aChannelName
                            withError:error
                           withParams:[ret toJsonObject]];
                 }];
}

- (void)fetchVisiblePrivateCircleChannelInServer:(NSDictionary *)param
                                  withMethodType:(NSString *)aChannelName
                                          result:
                                              (nonnull id<ExtSdkCallbackObjc>)
                                                  result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSNumber *limit = param[@"pageSize"];
    NSString *cursor = param[@"cursor"];
    [EMClient.sharedClient.circleManager
        fetchVisibelPrivateChannelsInServer:serverId
                                      limit:[limit integerValue]
                                     cursor:cursor
                                 completion:^(EMCursorResult<EMCircleChannel *>
                                                  *_Nullable ret,
                                              EMError *_Nullable error) {
                                   [weakSelf onResult:result
                                       withMethodType:aChannelName
                                            withError:error
                                           withParams:[ret toJsonObject]];
                                 }];
}

- (void)checkSelfIsInCircleChannel:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        checkSelfIsInChannel:serverId
                   channelId:channelId
                  completion:^(BOOL isJoined, EMError *_Nullable error) {
                    [weakSelf onResult:result
                        withMethodType:aChannelName
                             withError:error
                            withParams:@(isJoined)];
                  }];
}

- (void)fetchCircleChannelMuteUsers:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *serverId = param[@"serverId"];
    NSString *channelId = param[@"channelId"];
    [EMClient.sharedClient.circleManager
        fetchChannelMuteUsers:serverId
                    channelId:channelId
                   completion:^(
                       NSDictionary<NSString *, NSNumber *> *_Nullable muteInfo,
                       EMError *_Nullable error) {
                     [weakSelf onResult:result
                         withMethodType:aChannelName
                              withError:error
                             withParams:muteInfo];
                   }];
}

#pragma mark - EMCircleManagerServerDelegate

- (void)onServerDestroyed:(NSString *)serverId initiator:(NSString *)initiator {
    NSDictionary *param = @{@"serverId" : serverId, @"initiator" : initiator};
    [self onReceive:MKonCircleServerDestroyed withParams:param];
}

- (void)onServerUpdated:(EMCircleServerEvent *)event {
    [self onReceive:MKonCircleServerUpdated withParams:[event toJsonObject]];
}

- (void)onMemberJoinedServer:(NSString *)serverId member:(NSString *)member {
    NSDictionary *param = @{@"serverId" : serverId, @"memberId" : member};
    [self onReceive:MKonMemberJoinedCircleServer withParams:param];
}

- (void)onMemberLeftServer:(NSString *)serverId member:(NSString *)member {
    NSDictionary *param = @{@"serverId" : serverId, @"memberId" : member};
    [self onReceive:MKonMemberLeftCircleServer withParams:param];
}

- (void)onMemberRemovedFromServer:(NSString *)serverId
                          members:(NSArray<NSString *> *)members {
    NSDictionary *param = @{@"serverId" : serverId, @"memberIds" : members};
    [self onReceive:MKonMemberRemovedFromCircleServer withParams:param];
}

- (void)onReceiveServerInvitation:(EMCircleServerEvent *)event
                          inviter:(NSString *)inviter {
    NSDictionary *param =
        @{@"event" : [event toJsonObject], @"inviter" : inviter};
    [self onReceive:MKonReceiveInvitationFromCircleServer withParams:param];
}

- (void)onServerInvitaionBeAccepted:(NSString *)serverId
                            invitee:(NSString *)invitee {
    NSDictionary *param = @{@"serverId" : serverId, @"invitee" : invitee};
    [self onReceive:MKonInvitationBeAcceptedFromCircleServer withParams:param];
}

- (void)onServerInvitaionBeDeclined:(NSString *)serverId
                            invitee:(NSString *)invitee {
    NSDictionary *param = @{@"serverId" : serverId, @"invitee" : invitee};
    [self onReceive:MKonInvitationBeDeclinedFromCircleServer withParams:param];
}

- (void)onServerRoleAssigned:(NSString *)serverId
                      member:(NSString *)member
                        role:(EMCircleUserRole)role {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"memberId" : member,
        @"role" : @([EMCircleUser userRoleTypeToInt:role]),
    };
    [self onReceive:MKonRoleAssignedFromCircleServer withParams:param];
}

#pragma mark - EMCircleManagerChannelDelegate

- (void)onChannelCreated:(NSString *)serverId
               channelId:(NSString *)channelId
                 creator:(NSString *)creator {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"creator" : creator,
    };
    [self onReceive:MKonCircleChannelCreated withParams:param];
}

- (void)onChannelDestroyed:(NSString *)serverId
                 channelId:(NSString *)channelId
                 initiator:(NSString *)initiator {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"initiator" : initiator,
    };
    [self onReceive:MKonCircleChannelDestroyed withParams:param];
}

- (void)onChannelUpdated:(NSString *)serverId
               channelId:(NSString *)channelId
                    name:(NSString *)name
                    desc:(NSString *)desc
               initiator:(NSString *)initiator {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"channelName" : name,
        @"channelDescription" : desc,
        @"initiator" : initiator,
    };
    [self onReceive:MKonCircleChannelUpdated withParams:param];
}

- (void)onMemberJoinedChannel:(NSString *)serverId
                    channelId:(NSString *)channelId
                       member:(NSString *)member {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"memberId" : member,
    };
    [self onReceive:MKonMemberJoinedCircleChannel withParams:param];
}

- (void)onMemberLeftChannel:(NSString *)serverId
                  channelId:(NSString *)channelId
                     member:(NSString *)member {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"memberId" : member,
    };
    [self onReceive:MKonMemberLeftCircleChannel withParams:param];
}

- (void)onMemberRemovedFromChannel:(NSString *)serverId
                         channelId:(NSString *)channelId
                            member:(NSString *)member
                         initiator:(NSString *)initiator {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"memberId" : member,
        @"initiator" : initiator,
    };
    [self onReceive:MKonMemberRemovedFromCircleChannel withParams:param];
}

- (void)onReceiveChannelInvitation:(EMCircleChannelExt *)invite
                           inviter:(NSString *)inviter {
    NSDictionary *param = @{
        @"channelExtension" : [invite toJsonObject],
        @"inviter" : inviter,
    };
    [self onReceive:MKonReceiveInvitationFromCircleChannel withParams:param];
}

- (void)onChannelInvitaionBeAccepted:(NSString *)serverId
                           channelId:(NSString *)channelId
                             invitee:(NSString *)invitee {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"invitee" : invitee,
    };
    [self onReceive:MKonInvitationBeAcceptedFromCircleChannel withParams:param];
}

- (void)onChannelInvitaionBeDeclined:(NSString *)serverId
                           channelId:(NSString *)channelId
                             invitee:(NSString *)invitee {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"invitee" : invitee,
    };
    [self onReceive:MKonInvitationBeDeclinedFromCircleChannel withParams:param];
}

- (void)onMemberMuteChangeInChannel:(NSString *)serverId
                          channelId:(NSString *)channelId
                              muted:(BOOL)isMuted
                            members:(NSArray<NSString *> *)members {
    NSDictionary *param = @{
        @"serverId" : serverId,
        @"channelId" : channelId,
        @"isMuted" : @(isMuted),
        @"memberIds" : members,
    };
    [self onReceive:MKonMemberMuteChangedInCircleChannel withParams:param];
}

@end
