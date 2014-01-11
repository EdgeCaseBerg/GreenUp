//
//  NetworkingController.m
//  HockeyApp
//
//  Created by Anders Melen on 11/5/13.
//  Copyright (c) 2013 . All rights reserved.
//

#import "NetworkingController.h"
#import "DataModelEntityResources.h"
#import "coreDataController.h"
#import "MainViewController.h"

//#define API_URL @"http://50.157.168.182/hockeyapp/api/" //---- REAL MIKE HOST
#define API_URL @"http://199.195.248.180/hockeyapp/api/" //---- REAL JOSH HOST

#define REQUEST_TYPE_GET_TEAM @"get_team"
#define REQUEST_TYPE_GET_PLAYER @"get_player"
#define REQUEST_TYPE_SYNC_PLAYERS @"sync_changed_players"
#define REQUEST_TYPE_LOGIN @"login"

static NetworkingController *sharedNetworkingController;

@implementation NetworkingController

+ (NetworkingController *) shared
{
	if (sharedNetworkingController == nil)
	{
		sharedNetworkingController = [[NetworkingController alloc] init];
	}
	return sharedNetworkingController;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
    self.statusCode = [(NSHTTPURLResponse *)response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *data = nil;
    if(self.responseData != nil)
        data = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    
    //Handle Request
    if([self.currentRequest isEqualToString:REQUEST_TYPE_GET_TEAM])
    {
        if([[data objectForKey:@"status_code"] integerValue] == 200)
        {
            NSArray *teams = [data objectForKey:@"teams"];
            if(teams != nil)
            {
                if(teams.count != 0)
                {
                    //Remove Old Teams and Players
                    [[coreDataController shared] deleteAllObjectsWithEntityName:Team_Entity andPredicate:nil];
                    [[coreDataController shared] deleteAllObjectsWithEntityName:Player_Entity andPredicate:nil];
                    
                    for(NSDictionary *team in teams)
                    {
                        [Team parseJSONToObject:team];
                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"It looks like your RinkNote account doesn't have any teams. Please visit the RinkNote website and add or upload some teams" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"It looks like your RinkNote account doesn't have any teams. Please visit the RinkNote website and add or upload some teams" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            //Save New Data
            [[coreDataController shared] saveContext];
            
            //Make Sure we Have Atleast One Player On One Team
            NSArray *players = [theCoreDataController fetchAllObjectsWithEntityName:Player_Entity andSortDescriptors:nil];
            if(players.count == 0)
            {
                [[MainViewController shared] createFakeTeamsWithNumPlayers:5 andGeneralMetrics:TRUE andPostitions:2 andNumMetrics:2 andWipeOldData:FALSE];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingTeams" object:@TRUE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingTeams" object:data];
        }
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_GET_PLAYER])
    {
        
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_SYNC_PLAYERS])
    {
        if([[data objectForKey:@"status_code"] integerValue] == 200)
        {
            NSArray *teams = [data objectForKey:@"teams"];
            for(NSDictionary *team in teams)
            {
                [Team parseJSONToObject:team];
            }
            
            //Save New Data
            [[coreDataController shared] saveContext];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedSyncingPlayers" object:@TRUE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedSyncingPlayers" object:data];
        }
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_LOGIN])
    {
        /*
        //Add New Recruiter
        Recruiter *loggedInRecruiter = [theCoreDataController insertNewEntityWithName:Recruiter_Entity];
        loggedInRecruiter.recruiterName = @"Test Account";
        loggedInRecruiter.recruiterID = @1;
        loggedInRecruiter.recruiterToken = @"recruiter";
        [theCoreDataController saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:@TRUE];
         */
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        if([[data objectForKey:@"status_code"] integerValue] == 200)
        {
            //Remove Old Recruiter(s) we only want to store one!
            [theCoreDataController deleteAllObjectsWithEntityName:Recruiter_Entity andPredicate:nil];
            
            //Add New Recruiter
            Recruiter *loggedInRecruiter = [theCoreDataController insertNewEntityWithName:Recruiter_Entity];
            
            NSDictionary *userDictionary = [data objectForKey:@"user"];
            NSDictionary *recruiter = [data objectForKey:@"recruiter"];

            if([recruiter objectForKey:@"first_name"] != nil && [recruiter objectForKey:@"last_name"] != nil)
                loggedInRecruiter.recruiterName = [NSString stringWithFormat:@"%@ %@", [recruiter objectForKey:@"first_name"], [recruiter objectForKey:@"last_name"]];
            if([userDictionary objectForKey:@"id"] != nil)
                loggedInRecruiter.recruiterID = [NSNumber numberWithInt:[[userDictionary objectForKey:@"id"] integerValue]];
            if([userDictionary objectForKey:@"token"] != nil)
                loggedInRecruiter.recruiterToken = [userDictionary objectForKey:@"token"];
            
            [theCoreDataController saveContext];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:@TRUE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:data];
        }
    }
    
    //Clear Request Type
    self.currentRequest = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDictionary *data = nil;
    if(self.responseData != nil)
        data = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    
    if([self.currentRequest isEqualToString:REQUEST_TYPE_GET_TEAM])
    {
        if(data == nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingTeams" object:@FALSE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingTeams" object:data];
        }
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_GET_PLAYER])
    {
    
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_SYNC_PLAYERS])
    {
        if(data == nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedSyncingPlayers" object:@FALSE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedSyncingPlayers" object:data];
        }
    }
    else if([self.currentRequest isEqualToString:REQUEST_TYPE_LOGIN])
    {
        /*
        if(data == nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:@FALSE];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:data];
        }*/
        
        //Add New Recruiter
        Recruiter *loggedInRecruiter = [theCoreDataController insertNewEntityWithName:Recruiter_Entity];
        loggedInRecruiter.recruiterName = @"Test Account";
        loggedInRecruiter.recruiterID = @1;
        loggedInRecruiter.recruiterToken = @"recruiter";
        [theCoreDataController saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoggingIn" object:@FALSE];
    }
    
    self.currentRequest = nil;
}

#pragma mark - Request Methods

-(void)getTeams
{
    //Set Request Type
    self.currentRequest = REQUEST_TYPE_GET_TEAM;
    
    //Build Request URL
    Recruiter *loggedInRecruiter = [[theCoreDataController fetchAllObjectsWithEntityName:Recruiter_Entity andSortDescriptors:nil] lastObject];
    
    NSString *urlString = [NSString stringWithFormat:@"%@team/?id=%d&token=%@", API_URL, loggedInRecruiter.recruiterID.integerValue, loggedInRecruiter.recruiterToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;

    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
  
    //Fire Off Request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)updatePlayers:(NSMutableSet *)players
{
    //Set Request Type
    self.currentRequest = REQUEST_TYPE_SYNC_PLAYERS;
    
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@player/",API_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"PUT"];
    NSMutableArray *playersArray = [[NSMutableArray alloc] init];
    
    //Build Request Dictionary
    for(Player *player in players)
    {
        [playersArray addObject:[player parseObjectToJSON]];
    }
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setObject:playersArray forKey:@"players"];
    
    Recruiter *loggedInRecruiter = [[theCoreDataController fetchAllObjectsWithEntityName:Recruiter_Entity andSortDescriptors:nil] lastObject];

    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:loggedInRecruiter.recruiterID.stringValue, loggedInRecruiter.recruiterToken, nil] forKeys:[NSArray arrayWithObjects:@"id", @"token",nil]];
    [dataDictionary setObject:userDictionary forKey:@"user"];
    
    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:nil];
    [request setHTTPBody:requestData];
    
    request.timeoutInterval = 10;
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    //Fire Off Request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    //Set Request Type
    self.currentRequest = REQUEST_TYPE_LOGIN;
    
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@authentication/",API_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"POST"];
    NSMutableDictionary *authenticationData = [[NSMutableDictionary alloc] init];
    [authenticationData setValue:username forKey:@"email"];
    [authenticationData setValue:password forKey:@"password"];
    
    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:authenticationData options:0 error:nil];
    [request setHTTPBody:requestData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    request.timeoutInterval = 10;
 
    //Fire Off Request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
