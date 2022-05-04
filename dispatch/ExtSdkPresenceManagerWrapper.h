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

@end

NS_ASSUME_NONNULL_END
