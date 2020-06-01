//
//  ESPRequest.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 04/03/20.
//

#import <Foundation/Foundation.h>
#import "ESPEnvelope.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ESPRequestParametterKey;

#define ESPRequestParametterURL             @"ESPRequestParametterURL"
#define ESPRequestParametterPostData        @"ESPRequestParametterPostData"
#define ESPRequestParametterSOAPAction      @"ESPRequestParametterSOAPAction"

@interface ESPRequest : NSObject

@property (nonatomic, assign) BOOL showLogs;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithParametters:(NSDictionary<ESPRequestParametterKey, id> *)parametters NS_DESIGNATED_INITIALIZER;

- (BOOL)cancel;
- (void)sendDataWithCompletion:(void (^)(ESPEnvelope * _Nullable envelope, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
