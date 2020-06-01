//
//  ESPEnvelope.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 05/03/20.
//

#import <Foundation/Foundation.h>
#import "ESPSerializeProtocol.h"
#import <libxml/tree.h>

@class ESPNode;

NS_ASSUME_NONNULL_BEGIN

@interface ESPEnvelope : NSObject<ESPSerializeProtocol>

@property (nonatomic, retain) NSString *methodPrefix;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMethod:(NSString *)method namespace:(NSString *)nspace parametters:(NSArray<id <ESPSerializeProtocol>>  *)parametters;
- (instancetype)initWithMethod:(NSString *)method namespace:(NSString *)nspace headers:(nullable NSArray<id <ESPSerializeProtocol>> *)headers parametters:(NSArray<id <ESPSerializeProtocol>> *)parametters NS_DESIGNATED_INITIALIZER;

+ (xmlNodePtr)findNodeWithName:(const char *)name parentNode:(xmlNodePtr)parentNode; 
- (xmlNodePtr)bodyChildNode;
- (xmlNodePtr)findNodeWithName:(const char *)name;

@end

NS_ASSUME_NONNULL_END
