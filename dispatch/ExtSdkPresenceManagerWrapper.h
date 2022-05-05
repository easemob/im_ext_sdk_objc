//
//  ExtSdkPresenceManagerWrapper.h
//  im_flutter_sdk
//
//  Created by 佐玉 on 2022/5/4.
//

#import "ExtSdkWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtSdkPresenceManagerWrapper : ExtSdkWrapper

+ (nonnull instancetype)getInstance;

- (void)initSdk;

- (void)subscribe:(NSDictionary *)param
      channelName:(NSString *)aChannelName
           result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)unsubscribe:(NSDictionary *)param
        channelName:(NSString *)aChannelName
             result:(nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchSubscribedMembersWithPageNum:(NSDictionary *)param
                              channelName:(NSString *)aChannelName
                                   result:
                                       (nonnull id<ExtSdkCallbackObjc>)result;

- (void)fetchPresenceStatus:(NSDictionary *)param
                channelName:(NSString *)aChannelName
                     result:(nonnull id<ExtSdkCallbackObjc>)result;

@end

NS_ASSUME_NONNULL_END
