//
//  ESPService.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 06/03/20.
//

#import <Foundation/Foundation.h>
#import "ESPEnvelope.h"

NS_ASSUME_NONNULL_BEGIN

@class ESPService;

@protocol ESPServiceDelegate <NSObject>

- (void)service:(ESPService *)service returnWithEnvelope:(ESPEnvelope *)envelope;
- (void)service:(ESPService *)service returnWithError:(NSError *)error;

@end

@interface ESPService : NSObject

@property (retain) NSString *url;
@property (retain) NSString *nspace;
@property (retain) NSString *soapAction;
@property (retain, nullable) NSString *password;
@property (retain, nullable) NSString *username;
@property (weak) id<ESPServiceDelegate> delegate;

- (void)executeServiceWithEnvelop:(ESPEnvelope *)envelope;

@end

NS_ASSUME_NONNULL_END
