//
//  ColorPickerViewController.h
//  openHAB
//
//  Created by Victor Belov on 16/04/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenHABWidget.h"
#import "NKOColorPickerView.h"

@interface ColorPickerViewController : UIViewController

@property (nonatomic, retain) OpenHABWidget *widget;
@property (nonatomic, retain) NKOColorPickerView *colorPickerView;

@end
