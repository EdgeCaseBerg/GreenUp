//
//  CSocketController.m
//  GoGreen
//
//  Created by Jordan Rouille on 8/31/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "CSocketController.h"
#import "greenhttp.h"
#import <netdb.h>
#include <arpa/inet.h>

@implementation CSocketController

#pragma mark - Singleton Constructor

static CSocketController* theCSocketController = nil;

+(CSocketController*)sharedCSocketController
{
    @synchronized([theCSocketController class])
    {
        if (theCSocketController == nil)
            theCSocketController = [[self alloc] init];
        
        return theCSocketController;
    }
    return nil;
}

#pragma mark - GET REQUESTS
-(id)performGETRequestToHost:(NSString *)host withRelativeURL:(NSString *)relativeURL withPort:(int)port withProperties:(NSDictionary *)properties
{
    //return [NSDictionary dictionaryWithObject:@"400" forKey:@"status_code"];
    //GET IP FROM HOST
    //struct hostent *host_entry = gethostbyname([host UTF8String]);
    const char *ip;
    //ip = inet_ntoa(*((struct in_addr *)host_entry->h_addr_list[0]));
    ip = [host UTF8String];
    
    //CREATE URL STRING PROPERTIES
    NSMutableString *urlParameters = [[NSMutableString alloc] init];
    BOOL first = TRUE;
    for(NSString *key in properties.allKeys)
    {
        if(first)
        {
            [urlParameters appendString:@"?"];
        }
        else
        {
            [urlParameters appendString:@"&"];
        }
        
        first = FALSE;
        
        [urlParameters appendFormat:@"%@=%@", key, [properties objectForKey:key]];
    }
    
    if(ip)
    {
        NSString *finalRelativeURL = [NSString stringWithFormat:@"%@%@", relativeURL, urlParameters];
        const char *relativeURLCString = [finalRelativeURL cStringUsingEncoding:NSUTF8StringEncoding];
        char * request = gh_build_get_query((char *)[host UTF8String], (char *)relativeURLCString);
        char *charPointer = gh_make_request(request, (char *)[host UTF8String], (char *)ip, port);
        NSString *response = [NSString stringWithUTF8String:charPointer];
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        id finalResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //always call free
        
        if(charPointer != [@"PROBLEM" UTF8String])
            free(charPointer);
        
        return finalResponse;
    }
    else
    {
        return @"Invalid IP Address";
    }
}

#pragma mark - PUT REQUESTS
-(id)performPUTRequestToHost:(NSString *)host withRelativeURL:(NSString *)relativeURL withPort:(int)port withProperties:(id)properties
{
    BOOL parseFailed = FALSE;
    
    //GET IP FROM HOST
    //struct hostent *host_entry = gethostbyname([host UTF8String]);
    const char *ip;
    //ip = inet_ntoa(*((struct in_addr *)host_entry->h_addr_list[0]));
    ip = [host UTF8String];
    
    //CREATE RAW JSON OF PROPERTIES
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:properties options:0 error:&error];
    
    NSString *jsonString = nil;
    if (!jsonData)
    {
        parseFailed = TRUE;
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if(!parseFailed)
    {
        if(ip)
        {
            const char *payload = [jsonString cStringUsingEncoding:NSUTF8StringEncoding];

            
            char *request = gh_build_put_query((char *)[host UTF8String], (char *)[relativeURL UTF8String], (char *)payload);

            char *charPointer = gh_make_request(request, (char *)[host UTF8String], (char *)ip, port);
            NSString *response = [NSString stringWithFormat:@"%s", charPointer];
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            id finalResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //always call free
            if(charPointer != [@"PROBLEM" UTF8String])
                free(charPointer);
            
            return finalResponse;
        }
        else
        {
            return @"Invalid IP Address";
        }
    }
    else
    {
        return @"Could Not Parse Properties Dictionary";
    }
}


#pragma mark - POST REQUESTS
-(id)performPOSTRequestToHost:(NSString *)host withRelativeURL:(NSString *)relativeURL withPort:(int)port withProperties:(NSDictionary *)properties
{
    BOOL parseFailed = FALSE;
    
    //GET IP FROM HOST
    //struct hostent *host_entry = gethostbyname([host UTF8String]);
    const char *ip;
    //ip = inet_ntoa(*((struct in_addr *)host_entry->h_addr_list[0]));
    ip = [host UTF8String];
    //CREATE RAW JSON OF PROPERTIES
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:properties options:0 error:&error];
    
    NSString *jsonString = nil;
    if (!jsonData)
    {
        parseFailed = TRUE;
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if(!parseFailed)
    {
        if(ip)
        {
            const char *payload = [jsonString cStringUsingEncoding:NSUTF8StringEncoding];
            
            char *request = gh_build_post_query((char *)[host UTF8String], (char *)[relativeURL UTF8String], (char *)payload);
            char *charPointer = gh_make_request(request, (char *)[host UTF8String], (char *)ip, port);
            NSString *response = [NSString stringWithFormat:@"%s", charPointer];
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            id finalResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //always call free
            if(charPointer != [@"PROBLEM" UTF8String])
                free(charPointer);
            
            return finalResponse;
        }
        else
        {
            return @"Invalid IP Address";
        }
    }
    else
    {
        return @"Could Not Parse Properties Dictionary";
    }
}

@end
