//
//  ExtSdkToJson.h
//  im_flutter_sdk
//
//  Created by 杜洁鹏 on 2020/9/27.
//

#import <Foundation/Foundation.h>

#import <HyphenateChat/EMChatMessage.h>
#import <HyphenateChat/EMChatThread.h>
#import <HyphenateChat/EMChatThreadEvent.h>
#import <HyphenateChat/EMChatroom.h>
#import <HyphenateChat/EMCircleChannel.h>
#import <HyphenateChat/EMCircleChannelExt.h>
#import <HyphenateChat/EMCircleServer.h>
#import <HyphenateChat/EMCircleServerEvent.h>
#import <HyphenateChat/EMCircleServerTag.h>
#import <HyphenateChat/EMCircleUser.h>
#import <HyphenateChat/EMConversation.h>
#import <HyphenateChat/EMCursorResult.h>
#import <HyphenateChat/EMDeviceConfig.h>
#import <HyphenateChat/EMError.h>
#import <HyphenateChat/EMGroup.h>
#import <HyphenateChat/EMGroupMessageAck.h>
#import <HyphenateChat/EMGroupOptions.h>
#import <HyphenateChat/EMGroupSharedFile.h>
#import <HyphenateChat/EMMessageBody.h>
#import <HyphenateChat/EMMessageReaction.h>
#import <HyphenateChat/EMMessageReactionChange.h>
#import <HyphenateChat/EMOptions.h>
#import <HyphenateChat/EMPageResult.h>
#import <HyphenateChat/EMPresence.h>
#import <HyphenateChat/EMPushOptions.h>
#import <HyphenateChat/EMSilentModeParam.h>
#import <HyphenateChat/EMSilentModeResult.h>
#import <HyphenateChat/EMSilentModeTime.h>
#import <HyphenateChat/EMTranslateLanguage.h>
#import <HyphenateChat/EMUserInfo.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExtSdkToJson <NSObject>
- (NSDictionary *)toJsonObject;
@end

@interface EMChatroom (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMConversation (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (int)typeToInt:(EMConversationType)aType;
+ (EMConversationType)typeFromInt:(int)aType;
@end

@interface EMCursorResult (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMDeviceConfig (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMError (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMGroup (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (EMGroupPermissionType)premissionTypeFromInt:(int)type;
+ (int)premissionTypeToInt:(EMGroupPermissionType)type;
@end

@interface EMGroupOptions (Json) <ExtSdkToJson>
+ (EMGroupOptions *)formJson:(NSDictionary *)dict;
- (NSDictionary *)toJsonObject;
+ (EMGroupStyle)styleFromInt:(int)style;
+ (int)styleToInt:(EMGroupStyle)style;
@end

@interface EMGroupSharedFile (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMGroupMessageAck (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMChatMessage (Json) <ExtSdkToJson>
+ (EMChatMessage *)fromJsonObject:(NSDictionary *)aJson;
- (NSDictionary *)toJsonObject;
+ (EMChatType)chatTypeFromInt:(int)aType;
+ (int)chatTypeToInt:(EMChatType)aType;
@end

@interface EMMessageBody (Json) <ExtSdkToJson>
+ (EMMessageBody *)fromJsonObject:(NSDictionary *)aJson;
- (NSDictionary *)toJsonObject;
+ (EMMessageBodyType)typeFromString:(NSString *)aStrType;
@end

@interface EMOptions (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (EMOptions *)fromJsonObject:(NSDictionary *)aJson;
@end

@interface EMPageResult (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMPresence (Helper) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMPushOptions (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMUserInfo (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (EMUserInfo *)fromJsonObject:(NSDictionary *)aJson;
@end

@interface EMTranslateLanguage (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface NSArray (Json)
- (NSArray *)toJsonArray;
@end

@interface EMMessageReaction (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMMessageReactionChange (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMChatThread (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMChatThreadEvent (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMSilentModeParam (Json)
+ (EMSilentModeParam *)formJsonObject:(NSDictionary *)dict;
+ (int)remindTypeToInt:(EMPushRemindType)type;
@end

@interface EMSilentModeResult (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMSilentModeTime (Helper) <ExtSdkToJson>
+ (EMSilentModeTime *)formJsonObject:(NSDictionary *)dict;
- (NSDictionary *)toJsonObject;
@end

@interface EMCircleServerTag (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMCircleServer (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMCircleUser (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (int)userRoleTypeToInt:(EMCircleUserRole)role;
@end

@interface EMCircleChannel (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
+ (EMCircleChannelType)typeFromInt:(NSUInteger)type;
+ (EMCircleChannelRank)rankFromInt:(NSUInteger)rank;
+ (NSUInteger)typeToInt:(EMCircleChannelType)type;
+ (NSUInteger)rankToInt:(EMCircleChannelRank)rank;
@end

@interface EMCircleServerEvent (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

@interface EMCircleChannelExt (Json) <ExtSdkToJson>
- (NSDictionary *)toJsonObject;
@end

NS_ASSUME_NONNULL_END
