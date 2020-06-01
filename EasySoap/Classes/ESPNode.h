//
//  ESPNode.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 31/01/20.
//

#import <Foundation/Foundation.h>
#import "ESPSerializeProtocol.h"
#import <libxml/tree.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESPNode : NSObject<ESPSerializeProtocol>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *prefix;

+ (NSArray<NSString *> *)ignoredProperties;
+ (NSArray<NSString *> *)atributteProperties;
+ (NSDictionary<NSString *, id> *)defaultPropertyValues;

- (NSString *)serialize;

@end

NS_ASSUME_NONNULL_END
