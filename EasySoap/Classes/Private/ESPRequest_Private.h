//
//  ESPRequest_Private.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 04/03/20.
//

#import "ESPRequest.h"
#import "ESPReachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESPRequest ()

@property (nonatomic, retain) ESPReachability *reachability;
@property (nonatomic, retain) NSDictionary<ESPRequestParametterKey, id> *parametters;
@property (nonatomic, retain) NSURLSessionDataTask *dataTask;

@end

NS_ASSUME_NONNULL_END
