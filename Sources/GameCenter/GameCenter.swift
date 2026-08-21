//
//  GameCenter.swift
//  v.1.5
//
//  Created by Sergey Vanichkin on 02.10.13.
//  Copyright © 2013 👽 Technology. All rights reserved.
//
//

import GameCenterObjC
import UIKit

/// Swift-friendly wrapper around the Objective-C `GameCenter` core.
public enum GameCenter
{
    /// Local player's alias, available after a successful sign-in.
    public static var alias: String?
    {
        GameCenterObjC.GameCenter.alias()
    }

    /// Local player's display name, available after a successful sign-in.
    public static var displayName: String?
    {
        GameCenterObjC.GameCenter.displayName()
    }

    /// Local player's avatar, available after a successful sign-in.
    public static var avatar: UIImage?
    {
        GameCenterObjC.GameCenter.avatar()
    }

    /// Reports a score to the given leaderboard.
    public static func setScore(_ score: Int,
                                 leaderboardIdentifier identifier: String,
                                 completion: ((Error?) -> Void)? = nil)
    {
        GameCenterObjC.GameCenter.setScores(NSNumber(value: score),
                                             withWithLeaderboardIdentifier: identifier)
        { error in

            completion?(error)
        }
    }

    /// Authenticates the local player if needed and presents the Game Center leaderboard.
    public static func showScores(controller: UIViewController,
                                   completion: ((Error?) -> Void)? = nil)
    {
        GameCenterObjC.GameCenter.showScores(with: controller)
        { error in

            completion?(error)
        }
    }
}
