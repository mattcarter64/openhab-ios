//
//  LIFEPLAYER_DLPlayerTypes.h
//  LifePlayer
//
//  Created by Mark Wolfskehl on 5/4/16.
//  Copyright © 2016 AT&T Digital Life. All rights reserved.
//

#ifndef LIFEPLAYER_DLPlayerTypes_h
#define LIFEPLAYER_DLPlayerTypes_h

/**
 ** These types parallel the typedef's in the app in PlayerLibrary/DLVideoPlayer.h
 ** They are and always must stay defined identically
 **
 ** These definitions are used for implementation of proactive precharge
 ** 
 ** NOTE: If the definitions do get out of sync the app will not build
 **/

typedef void (*LIFEPLAYER_URLFetchCompletionFn)(void *,bool,bool,NSString*);
typedef void (^LIFEPLAYER_URLFetchBlock)(void *,NSString *, LIFEPLAYER_URLFetchCompletionFn);

#endif /* LIFEPLAYER_DLPlayerTypes_h */
