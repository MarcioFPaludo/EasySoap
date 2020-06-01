//
//  ESPRequest.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 04/03/20.
//

#import "ESPRequest_Private.h"
#import "ESPEnvelope_Private.h"
#import "ESPSerializeProtocol.h"
#include <libxml/tree.h>

@implementation ESPRequest

- (instancetype)initWithParametters:(NSDictionary<ESPRequestParametterKey,id> *)parametters
{
    self = [super init];
    
    if (self)
    {
        NSMutableDictionary<ESPRequestParametterKey, id> *paramettersDictionary = [NSMutableDictionary dictionaryWithCapacity:parametters.count];
        for (ESPRequestParametterKey parametter in parametters) {
            id object = parametters[parametter];
            
            if ([parametter isEqualToString:ESPRequestParametterURL]) {
                if ([object isKindOfClass:NSString.class]) {
                    object = [NSURL URLWithString:object];
                }
                else if (![object isKindOfClass:NSURL.class]) {
                    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ESPRequestParametterURL only accept NSString or NSURL" userInfo:nil];
                }
                
                paramettersDictionary[ESPRequestParametterURL] = object;
                self.reachability = [[ESPReachability alloc] initWithHostname:((NSURL *)object).host];
            }
            else
            paramettersDictionary[parametter] = object;
        }
        
        self.showLogs = YES;
        self.parametters = [NSDictionary dictionaryWithDictionary:paramettersDictionary];
    }
    
    return self;
}

- (void)sendDataWithCompletion:(void (^)(ESPEnvelope * _Nullable envelope, NSError * _Nullable error))completionHandler
{
    if (!self.reachability.isReachable){
        completionHandler(nil, [NSError errorWithDomain:@"EasySoap" code:400 userInfo:@{@"The network or host not available":NSLocalizedDescriptionKey}]);
        return;
    }
    
    NSURL *url = self.parametters[ESPRequestParametterURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
#if DEBUG
    NSLog(@"Request URL: %@", url.absoluteString);
#endif
    
    id soapAction = self.parametters[ESPRequestParametterSOAPAction];
    if (soapAction) {
        [urlRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    }
    
    id postData = self.parametters[ESPRequestParametterPostData];
    if (postData) {
        if ([postData respondsToSelector:@selector(serialize)]){
            postData = [postData performSelector:@selector(serialize)];
        }
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
#if DEBUG
        NSLog(@"Post Data:%@", postData);
#endif
    }
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    _dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#if DEBUG
        NSLog(@"SoapRequest response:%@", dataString);
#endif
        if (!error) {
            ESPEnvelope *envelope = [ESPEnvelope envelopWithString:dataString];
            if (!envelope) {
                completionHandler(nil, [NSError errorWithDomain:@"Response.Error" code:554 userInfo:@{ NSLocalizedDescriptionKey : dataString}]);
            } else if ([envelope hasFaultWithError:&error]) {
                completionHandler(nil, error);
            } else {
                completionHandler(envelope, nil);
            }
        } else {
            completionHandler(nil, error);
        }
    }];
    
    [_dataTask resume];
}

- (BOOL)cancel
{
    if (_dataTask) {
        [_dataTask cancel];
        _dataTask = nil;
        return YES;
    }
    
    return NO;
}

@end
