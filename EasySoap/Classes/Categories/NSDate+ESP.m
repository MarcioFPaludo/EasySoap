//
//  NSDate+ESP.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 07/02/20.
//

#import "NSDate+ESP.h"

@implementation NSDate (ESP)

+ (NSDateFormatter*)dateFormatter
{
    static NSDateFormatter* formatter;
    
    if(!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
        formatter.lenient = YES;
    }
    
    return formatter;
}

+ (NSDate *)dateWithSoapString:(NSString *)soapString
{
    if ([soapString rangeOfString:@"T"].length != 1)
        soapString = [NSString stringWithFormat:@"%@T00:00:00.000", soapString];
    if ([soapString rangeOfString:@"."].length != 1)
        soapString = [NSString stringWithFormat:@"%@.000", soapString];

    if (soapString == nil || [soapString isEqualToString:@""])
        return nil;
    
    return [[NSDate dateFormatter] dateFromString:soapString];
}

- (NSString *)soapString
{
    return [[NSDate dateFormatter] stringFromDate:self];
}

@end
