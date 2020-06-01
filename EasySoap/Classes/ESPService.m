//
//  ESPService.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 06/03/20.
//

#import "ESPService.h"
#import "ESPRequest.h"

@implementation ESPService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.username = nil;
        self.password = nil;
    }
    return self;
}


- (void)executeServiceWithEnvelop:(ESPEnvelope *)envelope
{
    ESPRequest *request = [[ESPRequest alloc] initWithParametters:@{ESPRequestParametterURL : self.url,
                                                                    ESPRequestParametterPostData : envelope,
                                                                    ESPRequestParametterSOAPAction : self.soapAction}];
    
    [request sendDataWithCompletion:^(ESPEnvelope * _Nullable envelope, NSError * _Nullable error) {
        SEL selector;
        id object;
        
        if (!error) {
            object = envelope;
            selector = @selector(handleWithEnvelope:);
        } else {
            object = error;
            selector = @selector(handleWithError:);
        }
        
        [self performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
    }];
}

- (void)handleWithEnvelope:(ESPEnvelope *)envelope
{
    [_delegate service:self returnWithEnvelope:envelope];
}

- (void)handleWithError:(NSError *)error
{
    [_delegate service:self returnWithError:error];
}

@end
