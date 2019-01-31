//
//  VideoUITableViewCell.h
//  openHAB
//
//  Created by Victor Belov on 18/04/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "GenericUITableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

#import "openHAB-Swift.h"

@interface VideoUITableViewCell : GenericUITableViewCell

@property (nonatomic, retain) MPMoviePlayerController *videoPlayer;
@property (nonatomic, retain) VideoPlayerController *videoController;
@property (nonatomic, retain) VideoPlayer* dlVideoPlayer;
@property (nonatomic, retain) NSString* RTSPHost;

- (NSURL *)parseURL:(NSString *)url;

@end
