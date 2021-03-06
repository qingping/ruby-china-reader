//
//  RCRAppDelegate.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "RCRAppDelegate.h"
#import "RCRAppController.h"
#import "RCRUser.h"
#import "RCRTopic.h"

/*#ifdef DEBUG
    static NSString * API_ENDPOINT = @"http://localhost:3000";
#else*/
    static NSString * API_ENDPOINT = @"http://ruby-china.org";
//#endif

@interface RCRAppDelegate ()
- (void)mapObjects;
@end

@implementation RCRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [RKClient clientWithBaseURL:API_ENDPOINT];
    [self mapObjects];
    [[RCRAppController sharedPrefsWindowController] showWindow:nil];
}

- (void)mapObjects {
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:API_ENDPOINT];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[RCRUser class]];
    [userMapping mapAttributes:@"login", @"name", @"location", @"bio", @"tagline", @"website", nil];
    [userMapping mapKeyPathsToAttributes:@"github_url", @"githubUrl",
        @"gravatar_hash", @"gravatarHash",
        nil];
    [manager.mappingProvider addObjectMapping:userMapping];

    RKObjectMapping *topicMapping = [RKObjectMapping mappingForClass:[RCRTopic class]];
    [topicMapping mapKeyPathsToAttributes: @"title", @"title",
        @"replies_count", @"repliesCount",
        @"created_at", @"createdDate",
        @"updated_at", @"updatedDate",
        @"node_name", @"nodeName",
        nil];
    [topicMapping mapRelationship:@"user" withMapping:userMapping];
    
    [manager.mappingProvider addObjectMapping:topicMapping];
}

@end
