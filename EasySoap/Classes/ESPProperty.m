//
//  ESPProperty.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 20/03/20.
//

#import "ESPProperty.h"
#import "NSString+ESP.h"
#import "NSDate+ESP.h"
#import "ESPArray.h"
#import "ESPNode.h"

#define kElementStringWith(Name)                ([NSString stringWithFormat:@"<%@/>", Name])
#define KElementStringWith(Name, Value)         ([NSString stringWithFormat:@"<%@>%@</%@>", Name, Value, Name])
#define kTypeException(Type)                    ([NSException exceptionWithName:@"ESPInvalidTypeException" reason:[NSString stringWithFormat:@"EasySoap dont support properties of type %@", Type] userInfo:nil])

@interface ESPProperty ()

@property (nonatomic, retain) id value;

@end

@implementation ESPProperty

#pragma mark - Initialization

+ (instancetype)elementWithName:(NSString *)name type:(ESPPropertyType)type value:(id)value
{
    return [[ESPProperty alloc] initWithName:name prefix:nil type:type value:value];
}

+ (instancetype)elementWithName:(NSString *)name prefix:(NSString *)prefix type:(ESPPropertyType)type value:(id)value
{
    return [[ESPProperty alloc] initWithName:name prefix:prefix type:type value:value];
}

- (instancetype)initWithName:(NSString *)name prefix:(NSString *)prefix type:(ESPPropertyType)type value:(id)value
{
    self = [super init];
    if (self) {
        self.prefix = prefix;
        self.value = value;
        self.name = name;
        self.type = type;
    }
    return self;
}

#pragma mark - Serialization

+ (NSString *)stringForValue:(nonnull id)value withType:(ESPPropertyType)type
{
    NSString *valueString;
    
    switch (type) {
        case ESPPropertyTypeBool: {
            value = [value boolValue] ? @"Y" : @"N";
            break;
        }
        case ESPPropertyTypeInt:
        case ESPPropertyTypeLong:
        case ESPPropertyTypeFloat:
        case ESPPropertyTypeShort:
        case ESPPropertyTypeDouble:
        case ESPPropertyTypeLongLong: {
            valueString = [value stringValue];
            break;
        }
        case ESPPropertyTypeString: {
            valueString = [((NSString *)value) soapEscape];
            break;
        }
        case ESPPropertyTypeObject: {
            if ([value isKindOfClass:NSString.class]) {
                valueString = [((NSString *)value) soapEscape];
            } else if ([value isKindOfClass:NSData.class]) {
                valueString = [((NSData *)value) base64EncodedStringWithOptions:0];
            } else if ([value isKindOfClass:NSDate.class]) {
                valueString = [((NSDate *)value) soapString];
            } else {
                @throw kTypeException(NSStringFromClass([value class]));
            }
            break;
        }
    }
    
    return valueString;
}

- (NSString *)serialize
{
    NSString *serializedString = @"", *name = self.name, *prefix = self.prefix;
    
    if (prefix && prefix.length > 0 ) {
        name = [prefix stringByAppendingFormat:@":%@", name];
    }
    
    if (_value) {
        if (_type == ESPPropertyTypeObject && ([_value isKindOfClass:ESPArray.class] || [_value isKindOfClass:ESPNode.class])) {
            if (!((ESPNode *)_value).prefix || ((ESPNode *)_value).prefix.length <= 0) {
                ((ESPNode *)_value).prefix = prefix;
            }
            
            if ([_value isKindOfClass:ESPArray.class] && [_value count] <= 0) {
                serializedString = kElementStringWith([((ESPNode *)_value).prefix stringByAppendingString:[_value name]]);
            } else {
                serializedString = [_value serialize];
            }
        } else {
            serializedString = KElementStringWith(name, [ESPProperty stringForValue:_value withType:_type]);
        }
    } else if (_required) {
        serializedString = kElementStringWith(name);
    }
    
    return serializedString;
}

@end
