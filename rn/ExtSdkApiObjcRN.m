//
//  ExtSdkApiObjcRN.m
//  react-native-easemob
//
//  Created by asterisk on 2022/3/29.
//

#import "ExtSdkApiObjcRN.h"
#import "ExtSdkApiRNImpl.h"
#import "ExtSdkCallbackObjcRN.h"
#import "ExtSdkDelegateObjcRN.h"
#import "ExtSdkThreadUtilObjc.h"
#import "ExtSdkMethodTypeObjc.h"
#import <HyphenateChat/EMClient.h>
#import <UIKit/UIApplication.h>

static NSString *const TAG = @"ExtSdkApiRN";

@interface ExtSdkApiRN () {
    id<ExtSdkApiObjc> impl;
    id<ExtSdkDelegateObjc> delegate;
}

@end

@implementation ExtSdkApiRN

//+ (nonnull instancetype)getInstance {
//    static ExtSdkApiRN *instance = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//      instance = [[ExtSdkApiRN alloc] init];
//      instance->impl = [[ExtSdkApiRNImpl alloc] init];
//    });
//    return instance;
//}

- (instancetype)init {
    NSLog(@"%@: init:", TAG);
    self = [super init];
    if (self) {
        self->impl = [[ExtSdkApiRNImpl alloc] init];
        self->delegate = [[ExtSdkDelegateObjcRN alloc] initWithApi:self];
        [self registerSystemNotify];
    }
    return self;
}

- (void)onReceive:(nonnull NSString *)methodType withParams:(nullable id<NSObject>)data {
    NSLog(@"%@: onReceive:", TAG);
    [ExtSdkThreadUtilObjc mainThreadExecute:^{
      [self sendEventWithName:methodType body:data];
    }];
}

- (id<ExtSdkApiObjc>)getApi {
    return self->impl;
}

#pragma mark - Others

- (void)registerSystemNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    NSLog(@"%@: applicationWillEnterForeground:", TAG);
    [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
}
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"%@: applicationDidEnterBackground:", TAG);
    [[EMClient sharedClient] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

#pragma mark - RCTBridgeModule

RCT_EXPORT_MODULE(ExtSdkApiRN)

RCT_EXPORT_METHOD(callMethod
                  : (NSString *)methodName
                  : (NSDictionary *)params
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject) {
    NSLog(@"%@: callMethod:", TAG);
    id<ExtSdkCallbackObjc> callback = [[ExtSdkCallbackObjcRN alloc] initWithResolve:resolve withReject:reject];
    __weak typeof(self) weakself = self; // TODO: 后续解决 mm文件无法使用typeof关键字: 使用分类方式解决
    [ExtSdkThreadUtilObjc asyncExecute:^{
      if (weakself) {
          [[weakself getApi] callSdkApi:methodName withParams:params withCallback:callback];
      }
    }];
}

- (dispatch_queue_t)methodQueue {
    NSLog(@"%@: methodQueue:", TAG);
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    NSLog(@"%@: requiresMainQueueSetup:", TAG);
    return YES;
}

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    NSLog(@"%@: supportedEvents:", TAG);
    return @[
        /// EMClientWrapper
        ExtSdkMethodKeyInit,
        ExtSdkMethodKeyCreateAccount,
        ExtSdkMethodKeyLogin,
        ExtSdkMethodKeyLogout,
        ExtSdkMethodKeyChangeAppKey,
        ExtSdkMethodKeyIsLoggedInBefore,
        ExtSdkMethodKeyUploadLog,
        ExtSdkMethodKeyCompressLogs,
        ExtSdkMethodKeyKickDevice,
        ExtSdkMethodKeyKickAllDevices,
        ExtSdkMethodKeyCurrentUser,
        ExtSdkMethodKeyGetLoggedInDevicesFromServer,
        ExtSdkMethodKeyGetToken,

        /// EMClientDelegate
        ExtSdkMethodKeyOnConnected,
        ExtSdkMethodKeyOnDisconnected,
        ExtSdkMethodKeyOnMultiDeviceEvent,

        ExtSdkMethodKeySendDataToFlutter,

        /// EMContactManagerWrapper
        ExtSdkMethodKeyAddContact,
        ExtSdkMethodKeyDeleteContact,
        ExtSdkMethodKeyGetAllContactsFromServer,
        ExtSdkMethodKeyGetAllContactsFromDB,
        ExtSdkMethodKeyAddUserToBlockList,
        ExtSdkMethodKeyRemoveUserFromBlockList,
        ExtSdkMethodKeyGetBlockListFromServer,
        ExtSdkMethodKeyGetBlockListFromDB,
        ExtSdkMethodKeyAcceptInvitation,
        ExtSdkMethodKeyDeclineInvitation,
        ExtSdkMethodKeyGetSelfIdsOnOtherPlatform,

        /// EMContactDelegate
        ExtSdkMethodKeyOnContactChanged,

        /// EMChatManagerWrapper
        ExtSdkMethodKeySendMessage,
        ExtSdkMethodKeyResendMessage,
        ExtSdkMethodKeyAckMessageRead,
        ExtSdkMethodKeyAckGroupMessageRead,
        ExtSdkMethodKeyAckConversationRead,
        ExtSdkMethodKeyRecallMessage,
        ExtSdkMethodKeyGetConversation,
        ExtSdkMethodKeyMarkAllChatMsgAsRead,
        ExtSdkMethodKeyGetUnreadMessageCount,
        ExtSdkMethodKeyUpdateChatMessage,
        ExtSdkMethodKeyDownloadAttachment,
        ExtSdkMethodKeyDownloadThumbnail,
        ExtSdkMethodKeyImportMessages,
        ExtSdkMethodKeyLoadAllConversations,
        ExtSdkMethodKeyGetConversationsFromServer,

        ExtSdkMethodKeyDeleteConversation,
        // ExtSdkMethodKeySetVoiceMessageListened,
        // ExtSdkMethodKeyUpdateParticipant,
        ExtSdkMethodKeyUpdateConversationsName,
        ExtSdkMethodKeyFetchHistoryMessages,
        ExtSdkMethodKeySearchChatMsgFromDB,
        ExtSdkMethodKeyGetMessage,
        ExtSdkMethodKeyAsyncFetchGroupAcks,

        /// EMChatManagerDelegate
        ExtSdkMethodKeyOnMessagesReceived,
        ExtSdkMethodKeyOnCmdMessagesReceived,
        ExtSdkMethodKeyOnMessagesRead,
        ExtSdkMethodKeyOnGroupMessageRead,
        ExtSdkMethodKeyOnMessagesDelivered,
        ExtSdkMethodKeyOnMessagesRecalled,

        ExtSdkMethodKeyOnConversationUpdate,
        ExtSdkMethodKeyOnConversationHasRead,

        /// EMMessageListener
        ExtSdkMethodKeyOnMessageProgressUpdate,
        ExtSdkMethodKeyOnMessageSuccess,
        ExtSdkMethodKeyOnMessageError,
        ExtSdkMethodKeyOnMessageReadAck,
        ExtSdkMethodKeyOnMessageDeliveryAck,
        ExtSdkMethodKeyOnMessageStatusChanged,

        /// EMConversationWrapper

        ExtSdkMethodKeyGetUnreadMsgCount,
        ExtSdkMethodKeyMarkAllMsgsAsRead,
        ExtSdkMethodKeyMarkMsgAsRead,
        ExtSdkMethodKeySyncConversationExt,
        ExtSdkMethodKeySyncConversationName,
        ExtSdkMethodKeyRemoveMsg,
        ExtSdkMethodKeyGetLatestMsg,
        ExtSdkMethodKeyGetLatestMsgFromOthers,
        ExtSdkMethodKeyClearAllMsg,
        ExtSdkMethodKeyInsertMsg,
        ExtSdkMethodKeyAppendMsg,
        ExtSdkMethodKeyUpdateConversationMsg,

        ExtSdkMethodKeyLoadMsgWithId,
        ExtSdkMethodKeyLoadMsgWithStartId,
        ExtSdkMethodKeyLoadMsgWithKeywords,
        ExtSdkMethodKeyLoadMsgWithMsgType,
        ExtSdkMethodKeyLoadMsgWithTime,

        /// EMChatroomManagerWrapper

        ExtSdkMethodKeyJoinChatRoom,
        ExtSdkMethodKeyLeaveChatRoom,
        ExtSdkMethodKeyGetChatroomsFromServer,
        ExtSdkMethodKeyFetchChatRoomFromServer,
        ExtSdkMethodKeyGetChatRoom,
        ExtSdkMethodKeyGetAllChatRooms,
        ExtSdkMethodKeyCreateChatRoom,
        ExtSdkMethodKeyDestroyChatRoom,
        ExtSdkMethodKeyChatRoomUpdateSubject,
        ExtSdkMethodKeyChatRoomUpdateDescription,
        ExtSdkMethodKeyGetChatroomMemberListFromServer,
        ExtSdkMethodKeyChatRoomMuteMembers,
        ExtSdkMethodKeyChatRoomUnmuteMembers,
        ExtSdkMethodKeyChangeChatRoomOwner,
        ExtSdkMethodKeyChatRoomAddAdmin,
        ExtSdkMethodKeyChatRoomRemoveAdmin,
        ExtSdkMethodKeyGetChatroomMuteListFromServer,
        ExtSdkMethodKeyChatRoomRemoveMembers,
        ExtSdkMethodKeyChatRoomBlockMembers,
        ExtSdkMethodKeyChatRoomUnblockMembers,
        ExtSdkMethodKeyFetchChatroomBlockListFromServer,
        ExtSdkMethodKeyUpdateChatRoomAnnouncement,
        ExtSdkMethodKeyFetchChatroomAnnouncement,

        ExtSdkMethodKeyAddMembersToChatRoomWhiteList,
        ExtSdkMethodKeyRemoveMembersFromChatRoomWhiteList,
        ExtSdkMethodKeyFetchChatRoomWhiteListFromServer,
        ExtSdkMethodKeyIsMemberInChatRoomWhiteListFromServer,

        ExtSdkMethodKeyMuteAllChatRoomMembers,
        ExtSdkMethodKeyUnMuteAllChatRoomMembers,

        ExtSdkMethodKeyChatroomChanged,

        /// EMGroupManagerWrapper

        ExtSdkMethodKeyGetGroupWithId,
        ExtSdkMethodKeyGetJoinedGroups,
        ExtSdkMethodKeyGetGroupsWithoutPushNotification,
        ExtSdkMethodKeyGetJoinedGroupsFromServer,
        ExtSdkMethodKeyGetPublicGroupsFromServer,
        ExtSdkMethodKeyCreateGroup,
        ExtSdkMethodKeyGetGroupSpecificationFromServer,
        ExtSdkMethodKeyGetGroupMemberListFromServer,
        ExtSdkMethodKeyGetGroupBlockListFromServer,
        ExtSdkMethodKeyGetGroupMuteListFromServer,
        ExtSdkMethodKeyGetGroupWhiteListFromServer,
        ExtSdkMethodKeyIsMemberInWhiteListFromServer,
        ExtSdkMethodKeyGetGroupFileListFromServer,
        ExtSdkMethodKeyGetGroupAnnouncementFromServer,
        ExtSdkMethodKeyAddMembers,
        ExtSdkMethodKeyInviterUser,
        ExtSdkMethodKeyRemoveMembers,
        ExtSdkMethodKeyBlockMembers,
        ExtSdkMethodKeyUnblockMembers,
        ExtSdkMethodKeyUpdateGroupSubject,
        ExtSdkMethodKeyUpdateDescription,
        ExtSdkMethodKeyLeaveGroup,
        ExtSdkMethodKeyDestroyGroup,
        ExtSdkMethodKeyBlockGroup,
        ExtSdkMethodKeyUnblockGroup,
        ExtSdkMethodKeyUpdateGroupOwner,
        ExtSdkMethodKeyAddAdmin,
        ExtSdkMethodKeyRemoveAdmin,
        ExtSdkMethodKeyMuteMembers,
        ExtSdkMethodKeyUnMuteMembers,
        ExtSdkMethodKeyMuteAllMembers,
        ExtSdkMethodKeyUnMuteAllMembers,
        ExtSdkMethodKeyAddWhiteList,
        ExtSdkMethodKeyRemoveWhiteList,
        ExtSdkMethodKeyUploadGroupSharedFile,
        ExtSdkMethodKeyDownloadGroupSharedFile,
        ExtSdkMethodKeyRemoveGroupSharedFile,
        ExtSdkMethodKeyUpdateGroupAnnouncement,
        ExtSdkMethodKeyUpdateGroupExt,
        ExtSdkMethodKeyJoinPublicGroup,
        ExtSdkMethodKeyRequestToJoinPublicGroup,
        ExtSdkMethodKeyAcceptJoinApplication,
        ExtSdkMethodKeyDeclineJoinApplication,
        ExtSdkMethodKeyAcceptInvitationFromGroup,
        ExtSdkMethodKeyDeclineInvitationFromGroup,
        ExtSdkMethodKeyIgnoreGroupPush,

        ExtSdkMethodKeyOnGroupChanged,

        /// EMPushManagerWrapper
        ExtSdkMethodKeyGetImPushConfig,
        ExtSdkMethodKeyGetImPushConfigFromServer,
        ExtSdkMethodKeyUpdatePushNickname,

        ExtSdkMethodKeyImPushNoDisturb,
        ExtSdkMethodKeyUpdateImPushStyle,
        ExtSdkMethodKeyUpdateGroupPushService,
        ExtSdkMethodKeyGetNoDisturbGroups,
        ExtSdkMethodKeyBindDeviceToken,

        /// EMUserInfoManagerWrapper
        ExtSdkMethodKeyUpdateOwnUserInfo,
        ExtSdkMethodKeyUpdateOwnUserInfoWithType,
        ExtSdkMethodKeyFetchUserInfoById,
        ExtSdkMethodKeyFetchUserInfoByIdWithType,
    ];
}

@end