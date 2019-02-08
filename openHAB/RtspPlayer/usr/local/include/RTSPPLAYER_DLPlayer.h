//
//  RTSPPLAYER_DLPlayer.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RTSPPLAYER_DLPlayerTypes.h"
#import "RTSPPLAYER_AppPlayerProtocol.h"

@interface RTSPPLAYER_DLPlayer : NSObject

/**
 ** Parallels for DLVideoPlayer interface
 ** Device* is replaced by the camera guid
 ** since Device is an app specific type we cannot access
 **/

/**
 ** Global timeout in seconds to keep players "charged"
 ** in CONNECTED state before automatically disconnecting
 **/
-(void)setKeepChargedTimeout:(int)val;
-(int)keepChargedTimeout;

/**
 ** Initialize with reference to integration class as a protocol for callbacks
 ** We hold appPlayer as a weak reference
 **
 ** - appPlayer: the callback integration class object
 ** - restartTimeout: timeout interval for restart in seconds
 ** - startTimeout: timeout interval for start in seconds
 **/
- (RTSPPLAYER_DLPlayer*)initWithAppPlayer:(NSObject<RTSPPLAYER_AppPlayerProtocol>*)appPlayer
                           restartTimeout:(NSTimeInterval)restartTimeoutInterval
                             startTimeout:(NSTimeInterval)startTimeoutInterval;

/**
 ** Pass on DLVideoPlayer urlFetchBlock callback
 **/
- (void)setUrlFetchCallback:(LIFEPLAYER_URLFetchBlock)urlFetchBlock;


/**
 ** Initiate precharge for all cameras that the app wants to precharge
 **/
-(void)precharge:(NSArray<NSString*> *)cameraIds;

/**
 ** Pass on DLVideoPlayer start request
 ** Device object for camera is replaced with GUID string
 ** Integration class is responsible for creating and maintaining mapping GUID ==> Device
 **/
- (void)start:(NSURL*)URL onView:(UIView*) view withCamera:(NSString*) cameraGuid andFeedVC:(UIViewController*) feedVC;


/**
 ** Pass on DLVideoPlayer restart request
 ** Device object for camera is replaced with GUID string
 ** Integration class is responsible for creating and maintaining mapping GUID ==> Device
 **/
- (void)restart:(UIView *)view withCamera:(NSString *)cameraGuid andFeedVC:(UIViewController *)feedVC onfailure:(void (^)(void))failureblock;

/**
 ** Pass on DLVideoPlayer discharge request
 **/
- (void)discharge;

/**
 ** Pass on DLVideoPlayer stop request
 ** - disconnect: true to diconnect ; false to stay connected when stopped playing
 **/
- (void)stop:(bool)disconnect;

/**
 ** Pass on DLVideoPlayer changeView requests
 **/
- (void)changeView:(UIView*)view andPresentingVC: (UIViewController*)vc;


/**
 ** Pass on setZoomScale requests
 **/
-(void)setZoomScale:(float)scale;

/**
 ** Mute setting for current camera
 **/
-(void)mute:(bool)state;

@end
