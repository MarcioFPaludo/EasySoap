//
//  NSString+ESP.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 20/03/20.
//

#import "NSString+ESP.h"

@implementation NSString (ESP)

- (NSString *)soapEscape
{
    NSString *string = [self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    
    return string;
}

@end
