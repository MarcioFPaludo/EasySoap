//
//  ESPNode.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 31/01/20.
//

#import "ESPNode_Private.h"
#import "ESPProperty_Private.h"
#import "NSDate+ESP.h"
#import "NSString+ESP.h"
#import <objc/runtime.h>

#define kGetPrefixString          (self.prefix ? [self.prefix stringByAppendingString:@":"] : @"")
#define kTypeException(Type)      ([NSException exceptionWithName:@"ESPInvalidTypeException" reason:[NSString stringWithFormat:@"EasySoap dont support properties of type %@", Type] userInfo:nil])

@implementation ESPNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:[self.class defaultPropertyValues]];
    }
    return self;
}


+ (NSArray<NSString *> *)ignoredProperties
{
    return @[];
}

+ (NSArray<NSString *> *)atributteProperties
{
    return @[];
}

+ (NSDictionary<NSString *,id> *)defaultPropertyValues
{
    return @{};
}

- (NSString *)name
{
    return _name && _name.length > 0 ? _name : NSStringFromClass(self.class);
}

- (void)parseObjcProperty:(objc_property_t)property readOnly:(BOOL *)readOnly rawType:(NSString **)rawType
{
    unsigned int count;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &count);
    
    for (size_t i = 0; i < count; ++i) {
        switch (*attrs[i].name) {
            case 'T':
            {
                *rawType = @(attrs[i].value);
                break;
            }
            case 'R':
            {
                *readOnly = YES;
                break;
            }
            case 'G':
                // getter
                break;
            case 'S':
                // setter
                break;
            case 'V':
                // backing ivar name
                break;
            case '&':
                // retain/assign
                break;
            case 'C':
                // copy
                break;
            case 'D':
                // dynamic
                break;
            case 'N':
                // nonatomic
                break;
            case 'P':
                // GC'able
                break;
            case 'W':
                // weak
                break;
            default:
                break;
        }
    }
    free(attrs);
}

- (ESPPropertyType)propertyTypeWithType:(NSString *)type
{
    const char *code = type.UTF8String;
    
    switch (*code)
    {
        case 's': {
            return ESPPropertyTypeShort;
        }
        case 'i': {
            return ESPPropertyTypeInt;
        }
        case 'l':  {
            return ESPPropertyTypeLong;
        }
        case 'q':  {
            return ESPPropertyTypeLongLong;
        }
        case 'f': {
            return ESPPropertyTypeFloat;
        }
        case 'd': {
            return ESPPropertyTypeDouble;
        }
        case 'c':
        case 'B': {
            return ESPPropertyTypeBool;
        }
        case '@': {
            return ESPPropertyTypeObject;
        }
        default:
            @throw kTypeException(type);
    }
}

- (void)eachProperty:(void (^)(NSString *propertyName, NSString *propertyType))handler
{
    NSArray<NSString *> *ignoredProperties = [self.class ignoredProperties];
    Class klass = self.class;
    
    do {
        unsigned int outCount, i;
        Class superClass = class_getSuperclass(klass);
        objc_property_t *properties = class_copyPropertyList(klass, &outCount);
        
        for(i = 0; i < outCount; i++) {
            NSString *propertyName = @(property_getName(properties[i])), *propertyType;
            BOOL readOnly = NO;
            
            [self parseObjcProperty:properties[i] readOnly:&readOnly rawType:&propertyType];
            
            if (readOnly || [ignoredProperties containsObject:propertyName]) {
                continue;
            }
            
            handler(propertyName, propertyType);
        }
        
        free(properties);
        klass = superClass;
    } while (klass != ESPNode.class);
}

#pragma mark - Serialize

- (NSString *)serialize
{
    NSString *name = [kGetPrefixString stringByAppendingString:self.name];
    return [NSString stringWithFormat:@"<%@%@>%@</%@>", name, [self serializeAtributtes], [self serializeElements], name];
}

- (NSString *)serializeAtributtes
{
    NSMutableString *atributtes = NSMutableString.string;
    NSString *rowType;
    BOOL readOnly;
    
    for (NSString *atributteName in [self.class atributteProperties]) {
        [self parseObjcProperty:class_getProperty(self.class, atributteName.UTF8String) readOnly:&readOnly rawType:&rowType];
        [atributtes appendFormat:@" %@:%@", atributteName, [ESPProperty stringForValue:[self valueForKey:atributteName] withType:[self propertyTypeWithType:rowType]]];
    }
    
    return atributtes;
}

- (NSString *)serializeElements
{
    NSMutableString *elements = NSMutableString.string;
    
    [self eachProperty:^(NSString *propertyName, NSString *propertyType) {
        if ([[self.class atributteProperties] indexOfObject:propertyName] == NSNotFound) {
            [elements appendString:[ESPPropertyWith(propertyName, self.prefix, [self propertyTypeWithType:propertyType], [self valueForKey:propertyName]) serialize]];
        }
    }];
    
    return elements;
}

@end
