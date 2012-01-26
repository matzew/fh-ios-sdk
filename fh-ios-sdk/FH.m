//
//  FH.m
//  fh-ios-sdk
//
//  Created by Craig Brookes on 25/01/2012.
//  Copyright (c) 2012 Feedhenry. All rights reserved.
//

#import "FH.h"
#import "FHRemote.h"
#import "FHLocal.h"
#import "ASIFormDataRequest.h"
#import "FHResponse.h"

@implementation FH
/*
  Action factory should perhaps move to its own class
 */

+ (FHAct *)buildAction:(FH_ACTION)action{
    FHAct * act = nil;
    switch (action) {
        case FH_ACTION_ACT:
            act = [[[FHRemote alloc] init] autorelease];
            act.method = @"act";
            break;
        case FH_ACTION_AUTH:
            act = [[[FHRemote alloc] init] autorelease];
            act.method = @"auth";
        default:
            act = [[[FHAct alloc] init] autorelease];
            act.method = @"unknown";
            break;
    }
    return act;
};
+ (FHAct *)buildAction:(FH_ACTION)action WithArgs:(NSDictionary *)arguments{
    //calls builaction
    FHAct * act = [self buildAction:action];
    act.args = arguments;
    return act;
};

+ (FHAct *)buildAction:(FH_ACTION)action WithArgs:(NSDictionary *)arguments AndResponseDelegate:(id<FHResponseDelegate>)del{
    FHAct * act     = [self buildAction:action];
    act.args        = arguments;
    act.delegate    = del;
    return act;
};
+ (void)act:(FHAct *)action WithSuccess:(void (^)(id success))sucornil AndFailure:(void (^)(id failed))failornil{
    if(action._location == FH_LOCATION_DEVICE){
        
    }else if(action._location == FH_LOCATION_REMOTE){
        FHRemote * remoteAction = (FHRemote *)action;
        [remoteAction buildURL];         
        NSURL * apicall = remoteAction.url;
        //startrequest
        __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:apicall];
        
        if(action.args && [action.args count]>0){
            NSArray * keys = [action.args allKeys];
            for (NSString * key in keys ) {
                id ob = [action.args objectForKey:key];
                if([ob isKindOfClass:[NSString class]]){
                    [request setPostValue:ob forKey:key];
                }
            }
        }
        
        [request setCompletionBlock:^{
            NSString * resposne = [request responseString];
            NSLog(@"full response string %@ ",resposne);
            FHResponse * fhResponse = [[[FHResponse alloc] init] autorelease];
            [fhResponse parseResponseString:resposne];

            //parse build response delegate
            if(sucornil)sucornil(fhResponse);
            else{
                SEL sucSel = @selector(requestDidSucceedWithResponse:);
                if (action.delegate && [action.delegate respondsToSelector:sucSel]) {
                    [action.delegate performSelectorOnMainThread:sucSel withObject:fhResponse waitUntilDone:YES];
                }
                
            }
        }];
        [request setFailedBlock:^{
            NSError * reqError = [request error];
            if(failornil)failornil(reqError);
            SEL delFailSel = @selector(requestDidFailWithError:);
            if (action.delegate && [action.delegate respondsToSelector:delFailSel]) {
                [action.delegate performSelectorOnMainThread:delFailSel withObject:reqError waitUntilDone:YES];
            }
        }];
        [request startAsynchronous];
    }
    
};




@end