//
//  VideoUITableViewCell.m
//  openHAB
//
//  Created by Victor Belov on 18/04/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "VideoUITableViewCell.h"

@implementation VideoUITableViewCell
@synthesize videoPlayer;
@synthesize dlVideoPlayer;
@synthesize videoController;

//- (void)displayWidget
//{
//    NSLog(@"Video url = %@", widget.url);
//    //    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:widget.url]];
//    //    videoPlayer.view.frame = self.contentView.bounds;
//    //    [self.contentView addSubview:videoPlayer.view];
//    //    [videoPlayer prepareToPlay];
//    //    [videoPlayer play];
//}

- (void)displayWidget
{
    OpenHABItem *item = widget.item;
    NSString *encoding = widget.encoding;
    
    if( item != nil && item.state != nil) {
        NSLog(@"VideoUITableViewCell: Video url = %@, encoding = %@", item.state, encoding );
        
        NSURL* url = [self parseURL:item.state];
        
        if([encoding isEqualToString:@"hlsxx"]) {
            videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            videoPlayer.view.frame = self.contentView.bounds;
            
            [self.contentView addSubview:videoPlayer.view];
            
            [videoPlayer prepareToPlay];
            
            [videoPlayer play];
        }
        else if([encoding isEqualToString:@"hls"]) {
            videoController = [VideoPlayerController alloc];
            
            videoController.view.frame = self.contentView.bounds;
            
            [self.contentView addSubview:videoController.view];
            
            dlVideoPlayer = [HLSMoviePlayer sharedVideoPlayer];
            
            videoController.player = dlVideoPlayer;
            
            [dlVideoPlayer start:url onView:self withCamera:item.name andFeedVC:videoController];
        }
        else if([encoding isEqualToString:@"rtsp"]) {
            videoController = [VideoPlayerController alloc];
            
            videoController.view.frame = self.contentView.bounds;
            
            [self.contentView addSubview:videoController.view];
            
            dlVideoPlayer = [RtspPlayer sharedVideoPlayer];
            
            videoController.player = dlVideoPlayer;
            
            [dlVideoPlayer start:url onView:self withCamera:item.name andFeedVC:videoController];
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if( videoPlayer != nil ) {
        [videoPlayer.view setFrame:frame];
    }
    else if( videoController != nil ) {
        [videoController.view setFrame:frame];
    }
}

//
// i did some funky stuff for video door bell. Passed in audio URL as a query
// parameter on the proxy URL value. Therefore, i need to remove it from the
// URL before calling the proxy. As of now, this "hack" is only used
// on VDB RTSP proxy URL values
//
// example URL:
// rtsp://openhabianpi/Video-0?session=10.87.1.77&cameraip=10.87.1.77&http://openhabian:pass@10.87.1.77/cgi-bin/audio.cgi
//
// parsed URL:
// rtsp://openhabianpi/Video-0?session=10.87.1.77&cameraip=10.87.1.77
//

-(NSURL *) parseURL:(NSString*)url
{
    NSURL *tempURL = [NSURL URLWithString:url];
    
    NSLog(@"parseURL: host = %@", tempURL.host);
    NSLog(@"parseURL: path = %@", tempURL.path);
    NSLog(@"parseURL: queryString = %@", tempURL.query);
    NSLog(@"parseURL: RTSPHost = %@", self.RTSPHost);
    
    NSString *host = tempURL.host;
    
    if( self.RTSPHost != nil ) {
        host = self.RTSPHost;
    }
    
    NSString *newUrlString = [@"rtsp://" stringByAppendingString:host];
    
    newUrlString = [newUrlString stringByAppendingString:tempURL.path];
    
    NSArray *listItems = [tempURL.query componentsSeparatedByString:@"&"];
    
    bool first = false;
    
    NSString *sep = @"?";
   
    id object;
    for (object in listItems) {
        NSLog(@"parseURL: query part = %@", object);
        
        if ([object rangeOfString:@"audio.cgi"].location != NSNotFound) {
            continue;
        }
        
        newUrlString = [newUrlString stringByAppendingString:sep];
        newUrlString = [newUrlString stringByAppendingString:object];

        if( ! first ) {
            sep = @"&";
            
            first = true;
        }
    }
    
    NSLog(@"parseURL: newUrlString = %@", newUrlString);

    NSURL *newURL = [NSURL URLWithString:newUrlString];

    return newURL;
}

@end
