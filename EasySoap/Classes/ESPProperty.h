//
//  ESPProperty.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 20/03/20.
//

#import <Foundation/Foundation.h>
#import "ESPSerializeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define ESPIntProperty(Name, Prefix, Value)          ESPPropertyWith(Name, Prefix, ESPPropertyTypeInt, Value)
#define ESPLongProperty(Name, Prefix, Value)         ESPPropertyWith(Name, Prefix, ESPPropertyTypeLong, Value)
#define ESPLongLongProperty(Name, Prefix, Value)     ESPPropertyWith(Name, Prefix, ESPPropertyTypeLongLong, Value)
#define ESPStringProperty(Name, Prefix, Value)       ESPPropertyWith(Name, Prefix, ESPPropertyTypeString, Value)
#define ESPObjectProperty(Name, Prefix, Value)       ESPPropertyWith(Name, Prefix, ESPPropertyTypeObject, Value)
#define ESPShortProperty(Name, Prefix, Value)        ESPPropertyWith(Name, Prefix, ESPPropertyTypeShort, Value)
#define ESPDoubleProperty(Name, Prefix, Value)       ESPPropertyWith(Name, Prefix, ESPPropertyTypeDouble, Value)
#define ESPFloatProperty(Name, Prefix, Value)        ESPPropertyWith(Name, Prefix, ESPPropertyTypeFloat, Value)
#define ESPBoolProperty(Name, Prefix, Value)         ESPPropertyWith(Name, Prefix, ESPPropertyTypeBool, Value)
#define ESPPropertyWith(Name, Prefix, Type, Value)   [[ESPProperty alloc] initWithName:Name prefix:Prefix type:Type value:Value]

typedef enum : NSUInteger {
    ESPPropertyTypeBool,
    ESPPropertyTypeDouble,
    ESPPropertyTypeFloat,
    ESPPropertyTypeInt,
    ESPPropertyTypeLong,
    ESPPropertyTypeLongLong,
    ESPPropertyTypeObject,
    ESPPropertyTypeShort,
    ESPPropertyTypeString,
} ESPPropertyType;

@interface ESPProperty : NSObject<ESPSerializeProtocol>

@property (nonatomic, assign) BOOL required;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, assign) ESPPropertyType type;

+ (instancetype)elementWithName:(NSString *)name type:(ESPPropertyType)type value:(nullable id)value;
+ (instancetype)elementWithName:(NSString *)name prefix:(nullable NSString *)prefix type:(ESPPropertyType)type value:(nullable id)value;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name prefix:(nullable NSString *)prefix type:(ESPPropertyType)type value:(nullable id)value NS_DESIGNATED_INITIALIZER;

- (NSString *)serialize;

@end

NS_ASSUME_NONNULL_END
