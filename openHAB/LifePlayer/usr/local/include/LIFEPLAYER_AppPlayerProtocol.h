//
//  LIFEPLAYER_AppPlayerProtocol.h
//  LifePlayer
//
//  Created by Mark Wolfskehl on 5/4/16.
//  Copyright © 2016 AT&T Digital Life. All rights reserved.
//

#ifndef LIFEPLAYER_AppPlayerProtocol_h
#define LIFEPLAYER_AppPlayerProtocol_h

#import <UIKit/UIKit.h>

/**
 ** Protocol to provide calling back into the app's LifePlayer class
 **/


@protocol LIFEPLAYER_AppPlayerProtocol <NSObject>

/**
 ** Add / remove app notification listeners than can trigger stop
 **/
-(void)addStartNotifications;
-(void)removeStartNotifications;


/**
 ** Delegate methods to reporting player state back to app
 **/
-(void)setPlayerStatePlaying;
-(void)setPlayerStateBufferring;
-(void)setPlayerStateError:(NSString *)err;
-(void)setPlayerStateOpen;
-(void)setPlayerStateStopped;

/**
 ** Provide access to DLVidePlayer superclass method calls needed
 ** for implementing start/restart/stop
 **
 ** Device object for camera is referred to by the GUID string
 ** and mapped by the integration class
 **/
-(void)super_start:(NSURL*)URL onView:(UIView*) view withCamera:(NSString*) cameraGuid andFeedVC:(UIViewController*) feedVC;
-(void)super_stop;

/**
 ** Setters / getters to provide access to player superclass 
 ** state tracking properties
 **/
//-(void)setViewContentMode:(UIViewContentMode) viewContentMode;
-(void)setPlayerView:(UIView*)view;
//-(void)setCurrentVCPlaying:(UIViewController*)vc;
-(void)setCurrentCameraByGuid:(NSString*)cameraGuid;
-(NSString *)getCurrentCameraGuid;


/**
 ** Invalidate URL with DLC / IIWC
 **/
- (void)invalidateURL:(NSURL*)URL;

@optional
-(void)setViewContentMode:(UIViewContentMode) viewContentMode;
-(void)setCurrentVCPlaying:(UIViewController*)vc;

@end

#endif /* LIFEPLAYER_AppPlayerProtocol_h */
