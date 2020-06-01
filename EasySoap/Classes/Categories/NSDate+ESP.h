//
//  NSDate+ESP.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 07/02/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ESP)

- (NSString *)soapString;
+ (NSDate *)dateWithSoapString:(NSString *)soapString;

@end

NS_ASSUME_NONNULL_END
