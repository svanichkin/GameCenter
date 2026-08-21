//
//  GameCenter.m
//  v.1.5
//
//  Created by Sergey Vanichkin on 02.10.13.
//  Copyright © 2013 👽 Technology. All rights reserved.
//
//

#import "GameCenter.h"

@interface GameCenter () <GKGameCenterControllerDelegate>

@property (strong, nonatomic) NSString *alias;
@property (strong, nonatomic) NSString *displayName;

@property (strong, nonatomic) UIImage  *avatar;

@end

@implementation GameCenter

+(GameCenter *)current
{
	static dispatch_once_t pred;
	static GameCenter *shared = nil;

	dispatch_once(&pred, ^
    {
        shared = self.new;
    });

    return shared;
}

+(NSString *)alias
{
    return
    GameCenter.current.alias;
}

+(NSString *)displayName
{
    return
    GameCenter.current.displayName;
}

+(UIImage *)avatar
{
    return
    GameCenter.current.avatar;
}

-(void)refreshWithCompletion:(Completion)completion
{
    [self
     refreshWithPresentingController:nil
     completion:completion];
}

-(void)refreshWithPresentingController:(UIViewController *)presentingController
                             completion:(Completion)completion
{
    if (!self.isGameCenterAvailable)
    {
        if (completion)
            completion([NSError
                        errorWithDomain:@"GameCenter"
                        code:-1
                        userInfo:@{NSLocalizedDescriptionKey:@"Game center not available."}]);

        return;
    }

    [self
     authenticateLocalUserWithPresentingController:presentingController
     completion:^(NSError *error)
    {
        GKLocalPlayer *player =
        GKLocalPlayer.localPlayer;

        if (player.isAuthenticated)
        {
            NSLog(@"Authentication changed: player authenticated.");

            self.alias       = player.alias;
            self.displayName = player.displayName;

            [player
             loadPhotoForSize:GKPhotoSizeNormal
             withCompletionHandler:^(UIImage *photo,
                                     NSError *error)
             {
                if (error == nil)
                    self.avatar = photo;

                if (completion)
                    completion(error);

                GKLocalPlayer.localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                                                  NSError          *error)
                {
                };
            }];

            return;
        }

        else if (!player.isAuthenticated)
            NSLog(@"Authentication changed: player not authenticated");

        if (completion)
            completion(error);

        GKLocalPlayer.localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                                          NSError          *error)
        {
        };

    }];
}

-(BOOL)isGameCenterAvailable
{
    return
    NSClassFromString(@"GKLocalPlayer") != nil;
}

-(void)authenticateLocalUserWithPresentingController:(UIViewController *)presentingController
                                            completion:(Completion)completion
{
    if (!self.isGameCenterAvailable)
    {
        if (completion)
            completion([NSError
                        errorWithDomain:@"GameCenter"
                        code:-1
                        userInfo:@{NSLocalizedDescriptionKey:@"Game center not available."}]);

        return;
    }

    NSLog(@"Authenticating local user...");

    if (GKLocalPlayer.localPlayer.isAuthenticated == NO)
    {
        GKLocalPlayer.localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                                          NSError          *error)
        {
            if (viewController != nil && presentingController != nil)
            {
                [presentingController
                 presentViewController:viewController
                 animated:YES
                 completion:nil];

                return;
            }

            if (completion)
                completion(error);
        };

        return;
    }

    else
        NSLog(@"Already authenticated!");

    if (completion)
        completion (nil);
}

+(void)             setScores:(NSNumber *)scores
withWithLeaderboardIdentifier:(NSString *)identifier
                   completion:(Completion)completion
{
    [GameCenter.current
     refreshWithCompletion:^(NSError *error)
    {
        GKScore *score =
        [GKScore.alloc
         initWithLeaderboardIdentifier:identifier];

        score.value = scores.integerValue;

        [GKScore
         reportScores:@[score]
         withCompletionHandler:^(NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                if (completion)
                    completion(error);
            });
        }];
    }];
}

+(void)showScoresWithController:(UIViewController *)controller
                     completion:(Completion        )completion
{
    [GameCenter.current
     refreshWithPresentingController:controller
     completion:^(NSError *error)
    {
        [GameCenter.current
         showScoresWithController:controller
         completion:completion];
    }];
}

-(void)showScoresWithController:(UIViewController *)controller
                     completion:(Completion        )completion
{
    GKGameCenterViewController *gameCenterViewController = GKGameCenterViewController.new;

    if (gameCenterViewController != nil)
    {
        gameCenterViewController.gameCenterDelegate = self;

        [controller
         presentViewController:gameCenterViewController
         animated:YES
         completion:^
        {
            if (completion)
                completion(nil);
        }];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController
     dismissViewControllerAnimated:YES
     completion:nil];
}

@end
