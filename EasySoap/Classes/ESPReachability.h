//
//  ESPReachability.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 05/03/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESPReachability : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHostname:(NSString *)hostname NS_DESIGNATED_INITIALIZER;
- (BOOL)isReachable;

@end

NS_ASSUME_NONNULL_END
