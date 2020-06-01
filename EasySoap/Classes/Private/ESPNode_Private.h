//
//  ESPNode_Private.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 31/01/20.
//

#import "ESPNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESPNode ()

- (NSString *)serializeElements;
- (NSString *)serializeAtributtes;
- (void)eachProperty:(void (^)(NSString *propertyName, NSString *propertyType))handler;

@end

NS_ASSUME_NONNULL_END
