//
//  ExtSdkCircleManager.h
//  react-native-chat-sdk
//
//  Created by asterisk on 2022/8/24.
//

#import "ExtSdkWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtSdkCircleManagerWrapper : ExtSdkWrapper

+ (nonnull instancetype)getInstance;

- (void)initSdk;

- (void)createCircleServer:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)destroyCircleServer:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)updateCircleServer:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)joinCircleServer:(NSDictionary *)param
          withMethodType:(NSString *)aChannelName
                  result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)leaveCircleServer:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeUserFromCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)inviteUserToCircleServer:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)acceptCircleServerInvitation:(NSDictionary *)param
                      withMethodType:(NSString *)aChannelName
                              result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)declineCircleServerInvitation:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)addTagsToCircleServer:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeTagsFromCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleServerTags:(NSDictionary *)param
               withMethodType:(NSString *)aChannelName
                       result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)addModeratorToCircleServer:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeModeratorFromCircleServer:(NSDictionary *)param
                         withMethodType:(NSString *)aChannelName
                                 result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchSelfCircleServerRole:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchJoinedCircleServers:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleServerDetail:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleServersWithKeyword:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleServerMembers:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)checkSelfInCircleServer:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)createCircleChannel:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)destroyCircleChannel:(NSDictionary *)param
              withMethodType:(NSString *)aChannelName
                      result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)updateCircleChannel:(NSDictionary *)param
             withMethodType:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)joinCircleChannel:(NSDictionary *)param
           withMethodType:(NSString *)aChannelName
                   result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)leaveCircleChannel:(NSDictionary *)param
            withMethodType:(NSString *)aChannelName
                    result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)removeUserFromCircleChannel:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)inviteUserToCircleChannel:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)acceptCircleChannelInvitation:(NSDictionary *)param
                       withMethodType:(NSString *)aChannelName
                               result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)declineCircleChannelInvitation:(NSDictionary *)param
                        withMethodType:(NSString *)aChannelName
                                result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)muteUserInCircleChannel:(NSDictionary *)param
                 withMethodType:(NSString *)aChannelName
                         result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)unmuteUserInCircleChannel:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleChannelDetail:(NSDictionary *)param
                  withMethodType:(NSString *)aChannelName
                          result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchPublicCircleChannelInServer:(NSDictionary *)param
                          withMethodType:(NSString *)aChannelName
                                  result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleChannelMembers:(NSDictionary *)param
                   withMethodType:(NSString *)aChannelName
                           result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchVisiblePrivateCircleChannelInServer:(NSDictionary *)param
                                  withMethodType:(NSString *)aChannelName
                                          result:
                                              (nonnull id<ExtSdkCallbackObjc>)
                                                  result;

- (void)checkSelfIsInCircleChannel:(NSDictionary *)param
                    withMethodType:(NSString *)aChannelName
                            result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchCircleChannelMuteUsers:(NSDictionary *)param
                     withMethodType:(NSString *)aChannelName
                             result:(nonnull id<ExtSdkCallbackObjc>)result;

@end

NS_ASSUME_NONNULL_END
