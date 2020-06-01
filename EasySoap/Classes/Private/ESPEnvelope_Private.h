//
//  ESPEnvelope_Private.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 05/03/20.
//

#import "ESPEnvelope.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESPEnvelope ()

+ (instancetype)envelopWithString:(NSString *)string;
- (BOOL)hasFaultWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
