//
//  GameCenter.h
//  v.1.5
//
//  Created by Sergey Vanichkin on 02.10.13.
//  Copyright © 2013 👽 Technology. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenter : NSObject

typedef void(^Completion)(NSError *error);

+(NSString *)alias;
+(NSString *)displayName;

+(UIImage *)avatar;

+(void)             setScores:(NSNumber *)scores
withWithLeaderboardIdentifier:(NSString *)identifier
                   completion:(Completion)completion;

+(void)showScoresWithController:(UIViewController *)controller
                     completion:(Completion        )completion;

@end
