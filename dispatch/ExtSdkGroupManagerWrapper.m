//
//  ExtSdkGroupManagerWrapper.m
//  FlutterTest
//
//  Created by 杜洁鹏 on 2019/10/17.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import "ExtSdkGroupManagerWrapper.h"

#import "ExtSdkToJson.h"

#import "ExtSdkMethodTypeObjc.h"

@interface ExtSdkGroupManagerWrapper () <EMGroupManagerDelegate>

@end

@implementation ExtSdkGroupManagerWrapper

+ (nonnull instancetype)getInstance {
    static ExtSdkGroupManagerWrapper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      instance = [[ExtSdkGroupManagerWrapper alloc] init];
    });
    return instance;
}

- (void)initSdk {
    [EMClient.sharedClient.groupManager removeDelegate:self];
    [EMClient.sharedClient.groupManager addDelegate:self delegateQueue:nil];
}

#pragma mark - Actions

- (void)getGroupWithId:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    EMGroup *group = [EMGroup groupWithId:param[@"groupId"]];
    [weakSelf onResult:result
        withMethodType:ExtSdkMethodKeyGetGroupWithId
             withError:nil
            withParams:[group toJsonObject]];
}

- (void)getJoinedGroups:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSArray *joinedGroups =
        [EMClient.sharedClient.groupManager getJoinedGroups];
    NSMutableArray *list = [NSMutableArray array];
    for (EMGroup *group in joinedGroups) {
        [list addObject:[group toJsonObject]];
    }
    [weakSelf onResult:result
        withMethodType:ExtSdkMethodKeyGetJoinedGroups
             withError:nil
            withParams:list];
}

- (void)getGroupsWithoutPushNotification:(NSDictionary *)param
                          withMethodType:(NSString *)aChannelName
                                  result:
                                      (nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    EMError *error = nil;
    NSArray *groups = [EMClient.sharedClient.groupManager
        getGroupsWithoutPushNotification:&error];
    NSMutableArray *list = [NSMutableArray array];
    for (EMGroup *group in groups) {
        [list addObject:[group toJsonObject]];
    }
    [weakSelf onResult:result
        withMethodType:ExtSdkMethodKeyGetJoinedGroups
             withError:error
            withParams:list];
}

- (void)getJoinedGroupsFromServer:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getJoinedGroupsFromServerWithPage:[param[@"pageNum"] intValue]
                                 pageSize:[param[@"pageSize"] intValue]
                               completion:^(NSArray *aList, EMError *aError) {
                                 NSMutableArray *list = [NSMutableArray array];
                                 for (EMGroup *group in aList) {
                                     [list addObject:[group toJsonObject]];
                                 }
                                 [weakSelf onResult:result
                                     withMethodType:
                                         ExtSdkMethodKeyGetJoinedGroupsFromServer
                                          withError:aError
                                         withParams:list];
                               }];
}

- (void)getPublicGroupsFromServer:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getPublicGroupsFromServerWithCursor:param[@"cursor"]
                                   pageSize:[param[@"pageSize"] integerValue]
                                 completion:^(EMCursorResult *aResult,
                                              EMError *aError) {
                                   [weakSelf onResult:result
                                       withMethodType:
                                           ExtSdkMethodKeyGetPublicGroupsFromServer
                                            withError:aError
                                           withParams:[aResult toJsonObject]];
                                 }];
}

- (void)createGroup:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        createGroupWithSubject:param[@"groupName"]
                   description:param[@"desc"]
                      invitees:param[@"inviteMembers"]
                       message:param[@"inviteReason"]
                       setting:[EMGroupOptions formJson:param[@"options"]]
                    completion:^(EMGroup *aGroup, EMError *aError) {
                      [weakSelf onResult:result
                          withMethodType:ExtSdkMethodKeyCreateGroup
                               withError:aError
                              withParams:[aGroup toJsonObject]];
                    }];
}

- (void)getGroupSpecificationFromServer:(NSDictionary *)param
                         withMethodType:(NSString *)aChannelName
                                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupSpecificationFromServerWithId:param[@"groupId"]
                                   completion:^(EMGroup *aGroup,
                                                EMError *aError) {
                                     [weakSelf onResult:result
                                         withMethodType:
                                             ExtSdkMethodKeyGetGroupSpecificationFromServer
                                              withError:aError
                                             withParams:[aGroup toJsonObject]];
                                   }];
}

- (void)getGroupMemberListFromServer:(NSDictionary *)param
                      withMethodType:(NSString *)aChannelName
                              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupMemberListFromServerWithId:param[@"groupId"]
                                    cursor:param[@"cursor"]
                                  pageSize:[param[@"pageSize"] intValue]
                                completion:^(EMCursorResult *aResult,
                                             EMError *aError) {
                                  [weakSelf onResult:result
                                      withMethodType:
                                          ExtSdkMethodKeyGetGroupMemberListFromServer
                                           withError:aError
                                          withParams:[aResult toJsonObject]];
                                }];
}

- (void)getGroupBlockListFromServer:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupBlacklistFromServerWithId:param[@"groupId"]
                               pageNumber:[param[@"pageNum"] intValue]
                                 pageSize:[param[@"pageSize"] intValue]
                               completion:^(NSArray *aList, EMError *aError) {
                                 [weakSelf onResult:result
                                     withMethodType:
                                         ExtSdkMethodKeyGetGroupBlockListFromServer
                                          withError:aError
                                         withParams:aList];
                               }];
}

- (void)getGroupMuteListFromServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupMuteListFromServerWithId:param[@"groupId"]
                              pageNumber:[param[@"pageNum"] intValue]
                                pageSize:[param[@"pageSize"] intValue]
                              completion:^(NSArray *aList, EMError *aError) {
                                [weakSelf onResult:result
                                    withMethodType:
                                        ExtSdkMethodKeyGetGroupMuteListFromServer
                                         withError:aError
                                        withParams:aList];
                              }];
}

- (void)getGroupWhiteListFromServer:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupWhiteListFromServerWithId:param[@"groupId"]
                               completion:^(NSArray *aList, EMError *aError) {
                                 [weakSelf onResult:result
                                     withMethodType:
                                         ExtSdkMethodKeyGetGroupWhiteListFromServer
                                          withError:aError
                                         withParams:aList];
                               }];
}

- (void)isMemberInWhiteListFromServer:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        isMemberInWhiteListFromServerWithGroupId:param[@"groupId"]
                                      completion:^(BOOL inWhiteList,
                                                   EMError *aError) {
                                        [weakSelf onResult:result
                                            withMethodType:
                                                ExtSdkMethodKeyIsMemberInWhiteListFromServer
                                                 withError:aError
                                                withParams:@(inWhiteList)];
                                      }];
}

- (void)getGroupFileListFromServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupFileListWithId:param[@"groupId"]
                    pageNumber:[param[@"pageNum"] intValue]
                      pageSize:[param[@"pageSize"] intValue]
                    completion:^(NSArray *aList, EMError *aError) {
                      NSMutableArray *array = [NSMutableArray array];
                      for (EMGroupSharedFile *file in aList) {
                          [array addObject:[file toJsonObject]];
                      }
                      [weakSelf onResult:result
                          withMethodType:
                              ExtSdkMethodKeyGetGroupFileListFromServer
                               withError:aError
                              withParams:array];
                    }];
}

- (void)getGroupAnnouncementFromServer:(NSDictionary *)param
                        withMethodType:(NSString *)aChannelName
                                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        getGroupAnnouncementWithId:param[@"groupId"]
                        completion:^(NSString *aAnnouncement, EMError *aError) {
                          [weakSelf onResult:result
                              withMethodType:
                                  ExtSdkMethodKeyGetGroupAnnouncementFromServer
                                   withError:aError
                                  withParams:aAnnouncement];
                        }];
}

- (void)addMembers:(NSDictionary *)param
    withMethodType:(NSString *)aChannelName
            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        addMembers:param[@"members"]
           toGroup:param[@"groupId"]
           message:param[@"welcome"]
        completion:^(EMGroup *aGroup, EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyAddMembers
                   withError:aError
                  withParams:[aGroup toJsonObject]];
        }];
}

- (void)inviterUser:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        addMembers:param[@"members"]
           toGroup:param[@"groupId"]
           message:param[@"reason"]
        completion:^(EMGroup *aGroup, EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyInviterUser
                   withError:aError
                  withParams:[aGroup toJsonObject]];
        }];
}

- (void)removeMembers:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        removeMembers:param[@"members"]
            fromGroup:param[@"groupId"]
           completion:^(EMGroup *aGroup, EMError *aError) {
             [weakSelf onResult:result
                 withMethodType:ExtSdkMethodKeyRemoveMembers
                      withError:aError
                     withParams:[aGroup toJsonObject]];
           }];
}

- (void)blockMembers:(NSDictionary *)param
      withMethodType:(NSString *)aChannelName
              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        blockMembers:param[@"members"]
           fromGroup:param[@"groupId"]
          completion:^(EMGroup *aGroup, EMError *aError) {
            [weakSelf onResult:result
                withMethodType:ExtSdkMethodKeyBlockMembers
                     withError:aError
                    withParams:[aGroup toJsonObject]];
          }];
}

- (void)unblockMembers:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        unblockMembers:param[@"members"]
             fromGroup:param[@"groupId"]
            completion:^(EMGroup *aGroup, EMError *aError) {
              [weakSelf onResult:result
                  withMethodType:ExtSdkMethodKeyUnblockMembers
                       withError:aError
                      withParams:[aGroup toJsonObject]];
            }];
}

- (void)updateGroupSubject:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        updateGroupSubject:param[@"name"]
                  forGroup:param[@"groupId"]
                completion:^(EMGroup *aGroup, EMError *aError) {
                  [weakSelf onResult:result
                      withMethodType:ExtSdkMethodKeyUpdateGroupSubject
                           withError:aError
                          withParams:[aGroup toJsonObject]];
                }];
}

- (void)updateDescription:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        updateDescription:param[@"desc"]
                 forGroup:param[@"groupId"]
               completion:^(EMGroup *aGroup, EMError *aError) {
                 [weakSelf onResult:result
                     withMethodType:ExtSdkMethodKeyUpdateDescription
                          withError:aError
                         withParams:[aGroup toJsonObject]];
               }];
}

- (void)leaveGroup:(NSDictionary *)param
    withMethodType:(NSString *)aChannelName
            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        leaveGroup:param[@"groupId"]
        completion:^(EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyLeaveGroup
                   withError:aError
                  withParams:nil];
        }];
}

- (void)destroyGroup:(NSDictionary *)param
      withMethodType:(NSString *)aChannelName
              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
            destroyGroup:param[@"groupId"]
        finishCompletion:^(EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyDestroyGroup
                   withError:aError
                  withParams:nil];
        }];
}

- (void)blockGroup:(NSDictionary *)param
    withMethodType:(NSString *)aChannelName
            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        blockGroup:param[@"groupId"]
        completion:^(EMGroup *aGroup, EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyBlockGroup
                   withError:aError
                  withParams:[aGroup toJsonObject]];
        }];
}

- (void)unblockGroup:(NSDictionary *)param
      withMethodType:(NSString *)aChannelName
              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        unblockGroup:param[@"groupId"]
          completion:^(EMGroup *aGroup, EMError *aError) {
            [weakSelf onResult:result
                withMethodType:ExtSdkMethodKeyUnblockGroup
                     withError:aError
                    withParams:[aGroup toJsonObject]];
          }];
}

- (void)updateGroupOwner:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        updateGroupOwner:param[@"groupId"]
                newOwner:param[@"owner"]
              completion:^(EMGroup *aGroup, EMError *aError) {
                [weakSelf onResult:result
                    withMethodType:ExtSdkMethodKeyUpdateGroupOwner
                         withError:aError
                        withParams:[aGroup toJsonObject]];
              }];
}

- (void)addAdmin:(NSDictionary *)param
    withMethodType:(NSString *)aChannelName
            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
          addAdmin:param[@"admin"]
           toGroup:param[@"groupId"]
        completion:^(EMGroup *aGroup, EMError *aError) {
          [weakSelf onResult:result
              withMethodType:ExtSdkMethodKeyAddAdmin
                   withError:aError
                  withParams:[aGroup toJsonObject]];
        }];
}

- (void)removeAdmin:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        removeAdmin:param[@"admin"]
          fromGroup:param[@"groupId"]
         completion:^(EMGroup *aGroup, EMError *aError) {
           [weakSelf onResult:result
               withMethodType:ExtSdkMethodKeyRemoveAdmin
                    withError:aError
                   withParams:[aGroup toJsonObject]];
         }];
}

- (void)muteMembers:(NSDictionary *)param
     withMethodType:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
             muteMembers:param[@"members"]
        muteMilliseconds:[param[@"duration"] integerValue]
               fromGroup:param[@"groupId"]
              completion:^(EMGroup *aGroup, EMError *aError) {
                [weakSelf onResult:result
                    withMethodType:ExtSdkMethodKeyMuteMembers
                         withError:aError
                        withParams:[aGroup toJsonObject]];
              }];
}

- (void)unMuteMembers:(NSDictionary *)param
       withMethodType:(NSString *)aChannelName
               result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        unmuteMembers:param[@"members"]
            fromGroup:param[@"groupId"]
           completion:^(EMGroup *aGroup, EMError *aError) {
             [weakSelf onResult:result
                 withMethodType:ExtSdkMethodKeyUnMuteMembers
                      withError:aError
                     withParams:[aGroup toJsonObject]];
           }];
}

- (void)muteAllMembers:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        muteAllMembersFromGroup:param[@"groupId"]
                     completion:^(EMGroup *aGroup, EMError *aError) {
                       [weakSelf onResult:result
                           withMethodType:ExtSdkMethodKeyMuteAllMembers
                                withError:aError
                               withParams:[aGroup toJsonObject]];
                     }];
}

- (void)unMuteAllMembers:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        unmuteAllMembersFromGroup:param[@"groupId"]
                       completion:^(EMGroup *aGroup, EMError *aError) {
                         [weakSelf onResult:result
                             withMethodType:ExtSdkMethodKeyUnMuteAllMembers
                                  withError:aError
                                 withParams:[aGroup toJsonObject]];
                       }];
}

- (void)addWhiteList:(NSDictionary *)param
      withMethodType:(NSString *)aChannelName
              result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        addWhiteListMembers:param[@"members"]
                  fromGroup:param[@"groupId"]
                 completion:^(EMGroup *aGroup, EMError *aError) {
                   [weakSelf onResult:result
                       withMethodType:ExtSdkMethodKeyAddWhiteList
                            withError:aError
                           withParams:[aGroup toJsonObject]];
                 }];
}

- (void)removeWhiteList:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        removeWhiteListMembers:param[@"members"]
                     fromGroup:param[@"groupId"]
                    completion:^(EMGroup *aGroup, EMError *aError) {
                      [weakSelf onResult:result
                          withMethodType:ExtSdkMethodKeyRemoveWhiteList
                               withError:aError
                              withParams:[aGroup toJsonObject]];
                    }];
}

- (void)uploadGroupSharedFile:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *groupId = param[@"groupId"];
    NSString *filePath = param[@"filePath"];
    [EMClient.sharedClient.groupManager uploadGroupSharedFileWithId:groupId
        filePath:filePath
        progress:^(int progress) {
          [weakSelf onReceive:ExtSdkMethodKeyUploadGroupSharedFile
                   withParams:@{
                       @"progress" : @(progress),
                       @"groupId" : groupId,
                       @"filePath" : filePath,
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMGroupSharedFile *aSharedFile, EMError *aError) {
          if (aError) {
              [weakSelf onReceive:ExtSdkMethodKeyUploadGroupSharedFile
                       withParams:@{
                           @"error" : [aError toJsonObject],
                           @"groupId" : groupId,
                           @"filePath" : filePath,
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:ExtSdkMethodKeyUploadGroupSharedFile
                       withParams:@{
                           @"groupId" : groupId,
                           @"filePath" : filePath,
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];
    [self onResult:result
        withMethodType:ExtSdkMethodKeyUploadGroupSharedFile
             withError:nil
            withParams:nil];
}

- (void)downloadGroupSharedFile:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    NSString *groupId = param[@"groupId"];
    NSString *savePath = param[@"savePath"];
    NSString *fileId = param[@"fileId"];
    [EMClient.sharedClient.groupManager downloadGroupSharedFileWithId:groupId
        filePath:savePath
        sharedFileId:fileId
        progress:^(int progress) {
          [weakSelf onReceive:ExtSdkMethodKeyDownloadGroupSharedFile
                   withParams:@{
                       @"progress" : @(progress),
                       @"groupId" : groupId,
                       @"filePath" : savePath,
                       @"callbackType" : ExtSdkMethodKeyOnMessageProgressUpdate
                   }];
        }
        completion:^(EMGroup *aGroup, EMError *aError) {
          if (aError) {
              [weakSelf onReceive:ExtSdkMethodKeyDownloadGroupSharedFile
                       withParams:@{
                           @"error" : [aError toJsonObject],
                           @"groupId" : groupId,
                           @"filePath" : savePath,
                           @"callbackType" : ExtSdkMethodKeyOnMessageError
                       }];
          } else {
              [weakSelf onReceive:ExtSdkMethodKeyDownloadGroupSharedFile
                       withParams:@{
                           @"groupId" : groupId,
                           @"filePath" : savePath,
                           @"callbackType" : ExtSdkMethodKeyOnMessageSuccess
                       }];
          }
        }];
    [self onResult:result
        withMethodType:ExtSdkMethodKeyDownloadGroupSharedFile
             withError:nil
            withParams:nil];
}

- (void)removeGroupSharedFile:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        removeGroupSharedFileWithId:param[@"groupId"]
                       sharedFileId:param[@"fileId"]
                         completion:^(EMGroup *aGroup, EMError *aError) {
                           [weakSelf onResult:result
                               withMethodType:
                                   ExtSdkMethodKeyRemoveGroupSharedFile
                                    withError:aError
                                   withParams:@(!aError)];
                         }];
}

- (void)updateGroupAnnouncement:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        updateGroupAnnouncementWithId:param[@"groupId"]
                         announcement:param[@"announcement"]
                           completion:^(EMGroup *aGroup, EMError *aError) {
                             [weakSelf onResult:result
                                 withMethodType:
                                     ExtSdkMethodKeyUpdateGroupAnnouncement
                                      withError:aError
                                     withParams:[aGroup toJsonObject]];
                           }];
}

- (void)updateGroupExt:(NSDictionary *)param
        withMethodType:(NSString *)aChannelName
                result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        updateGroupExtWithId:param[@"groupId"]
                         ext:param[@"ext"]
                  completion:^(EMGroup *aGroup, EMError *aError) {
                    [weakSelf onResult:result
                        withMethodType:ExtSdkMethodKeyUpdateGroupExt
                             withError:aError
                            withParams:[aGroup toJsonObject]];
                  }];
}

- (void)joinPublicGroup:(NSDictionary *)param
         withMethodType:(NSString *)aChannelName
                 result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        joinPublicGroup:param[@"groupId"]
             completion:^(EMGroup *aGroup, EMError *aError) {
               [weakSelf onResult:result
                   withMethodType:ExtSdkMethodKeyJoinPublicGroup
                        withError:aError
                       withParams:[aGroup toJsonObject]];
             }];
}

- (void)requestToJoinPublicGroup:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        requestToJoinPublicGroup:param[@"groupId"]
                         message:param[@"reason"]
                      completion:^(EMGroup *aGroup, EMError *aError) {
                        [weakSelf onResult:result
                            withMethodType:
                                ExtSdkMethodKeyRequestToJoinPublicGroup
                                 withError:aError
                                withParams:[aGroup toJsonObject]];
                      }];
}

- (void)acceptJoinApplication:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        approveJoinGroupRequest:param[@"groupId"]
                         sender:param[@"username"]
                     completion:^(EMGroup *aGroup, EMError *aError) {
                       [weakSelf onResult:result
                           withMethodType:ExtSdkMethodKeyAcceptJoinApplication
                                withError:aError
                               withParams:[aGroup toJsonObject]];
                     }];
}

- (void)declineJoinApplication:(NSDictionary *)param
                withMethodType:(NSString *)aChannelName
                        result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        declineJoinGroupRequest:param[@"groupId"]
                         sender:param[@"username"]
                         reason:param[@"reason"]
                     completion:^(EMGroup *aGroup, EMError *aError) {
                       [weakSelf onResult:result
                           withMethodType:ExtSdkMethodKeyDeclineJoinApplication
                                withError:aError
                               withParams:[aGroup toJsonObject]];
                     }];
}

- (void)acceptInvitationFromGroup:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        acceptInvitationFromGroup:param[@"groupId"]
                          inviter:param[@"inviter"]
                       completion:^(EMGroup *aGroup, EMError *aError) {
                         [weakSelf onResult:result
                             withMethodType:
                                 ExtSdkMethodKeyAcceptInvitationFromGroup
                                  withError:aError
                                 withParams:[aGroup toJsonObject]];
                       }];
}

- (void)declineInvitationFromGroup:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result {
    __weak typeof(self) weakSelf = self;
    [EMClient.sharedClient.groupManager
        declineGroupInvitation:param[@"groupId"]
                       inviter:param[@"inviter"]
                        reason:param[@"reason"]
                    completion:^(EMError *aError) {
                      [weakSelf onResult:result
                          withMethodType:
                              ExtSdkMethodKeyDeclineInvitationFromGroup
                               withError:aError
                              withParams:nil];
                    }];
}

#pragma mark - ExtSdkGroupManagerDelegate

- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage {
    NSDictionary *map = @{
        @"type" : @"onInvitationReceived",
        @"groupId" : aGroupId,
        @"inviter" : aInviter,
        @"message" : aMessage
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee {
    NSDictionary *map = @{
        @"type" : @"onInvitationAccepted",
        @"groupId" : aGroup.groupId,
        @"invitee" : aInvitee
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason {
    NSDictionary *map = @{
        @"type" : @"onInvitationDeclined",
        @"groupId" : aGroup.groupId,
        @"invitee" : aInvitee,
        @"reason" : aReason
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage {
    NSDictionary *map = @{
        @"type" : @"onAutoAcceptInvitationFromGroup",
        @"groupId" : aGroup.groupId,
        @"message" : aMessage,
        @"inviter" : aInviter
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)didLeaveGroup:(EMGroup *)aGroup reason:(EMGroupLeaveReason)aReason {
    NSString *type;
    if (aReason == EMGroupLeaveReasonBeRemoved) {
        type = @"onUserRemoved";
    } else if (aReason == EMGroupLeaveReasonDestroyed) {
        type = @"onGroupDestroyed";
    }
    NSDictionary *map = @{
        @"type" : type,
        @"groupId" : aGroup.groupId,
        @"groupName" : aGroup.groupName
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
                              user:(NSString *)aUsername
                            reason:(NSString *)aReason {
    NSDictionary *map = @{
        @"type" : @"onRequestToJoinReceived",
        @"groupId" : aGroup.groupId,
        @"applicant" : aUsername,
        @"reason" : aReason
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
                            reason:(NSString *)aReason {
    NSDictionary *map = @{
        @"type" : @"onRequestToJoinDeclined",
        @"groupId" : aGroupId,
        @"reason" : aReason
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup {
    NSDictionary *map = @{
        @"type" : @"onRequestToJoinAccepted",
        @"groupId" : aGroup.groupId,
        @"groupName" : aGroup.groupName,
        @"accepter" : aGroup.owner,
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
             addedMutedMembers:(NSArray *)aMutedMembers
                    muteExpire:(NSInteger)aMuteExpire {
    NSDictionary *map = @{
        @"type" : @"onMuteListAdded",
        @"groupId" : aGroup.groupId,
        @"mutes" : aMutedMembers,
        @"muteExpire" : [NSNumber numberWithInteger:aMuteExpire]
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupMuteListDidUpdate:(EMGroup *)aGroup
           removedMutedMembers:(NSArray *)aMutedMembers {
    NSDictionary *map = @{
        @"type" : @"onMuteListRemoved",
        @"groupId" : aGroup.groupId,
        @"mutes" : aMutedMembers
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupWhiteListDidUpdate:(EMGroup *)aGroup
          addedWhiteListMembers:(NSArray *)aMembers {
    NSDictionary *map = @{
        @"type" : @"onWhiteListAdded",
        @"groupId" : aGroup.groupId,
        @"whitelist" : aMembers
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupWhiteListDidUpdate:(EMGroup *)aGroup
        removedWhiteListMembers:(NSArray *)aMembers {
    NSDictionary *map = @{
        @"type" : @"onWhiteListRemoved",
        @"groupId" : aGroup.groupId,
        @"whitelist" : aMembers
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupAllMemberMuteChanged:(EMGroup *)aGroup
                 isAllMemberMuted:(BOOL)aMuted {
    NSDictionary *map = @{
        @"type" : @"onAllMemberMuteStateChanged",
        @"groupId" : aGroup.groupId,
        @"isMuted" : @(aMuted)
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                     addedAdmin:(NSString *)aAdmin {
    NSDictionary *map = @{
        @"type" : @"onAdminAdded",
        @"groupId" : aGroup.groupId,
        @"administrator" : aAdmin
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupAdminListDidUpdate:(EMGroup *)aGroup
                   removedAdmin:(NSString *)aAdmin {
    NSDictionary *map = @{
        @"type" : @"onAdminRemoved",
        @"groupId" : aGroup.groupId,
        @"administrator" : aAdmin
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupOwnerDidUpdate:(EMGroup *)aGroup
                   newOwner:(NSString *)aNewOwner
                   oldOwner:(NSString *)aOldOwner {
    NSDictionary *map = @{
        @"type" : @"onOwnerChanged",
        @"groupId" : aGroup.groupId,
        @"newOwner" : aNewOwner,
        @"oldOwner" : aOldOwner
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)userDidJoinGroup:(EMGroup *)aGroup user:(NSString *)aUsername {
    NSDictionary *map = @{
        @"type" : @"onMemberJoined",
        @"groupId" : aGroup.groupId,
        @"member" : aUsername
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)userDidLeaveGroup:(EMGroup *)aGroup user:(NSString *)aUsername {
    NSDictionary *map = @{
        @"type" : @"onMemberExited",
        @"groupId" : aGroup.groupId,
        @"member" : aUsername
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupAnnouncementDidUpdate:(EMGroup *)aGroup
                      announcement:(NSString *)aAnnouncement {
    NSDictionary *map = @{
        @"type" : @"onAnnouncementChanged",
        @"groupId" : aGroup.groupId,
        @"announcement" : aAnnouncement
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupFileListDidUpdate:(EMGroup *)aGroup
               addedSharedFile:(EMGroupSharedFile *)aSharedFile {
    NSDictionary *map = @{
        @"type" : @"onSharedFileAdded",
        @"groupId" : aGroup.groupId,
        @"sharedFile" : [aSharedFile toJsonObject]
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

- (void)groupFileListDidUpdate:(EMGroup *)aGroup
             removedSharedFile:(NSString *)aFileId {
    NSDictionary *map = @{
        @"type" : @"onSharedFileDeleted",
        @"groupId" : aGroup.groupId,
        @"fileId" : aFileId
    };
    [self onReceive:ExtSdkMethodKeyOnGroupChanged withParams:map];
}

@end
