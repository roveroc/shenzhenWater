//
//  ManualController.h
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoverGlobal.h"
#import "MBProgressHUD.h"


@interface ManualController : UIViewController{
    NSMutableArray *dataArray;
    NSTimer        *sendTimer;
    MBProgressHUD  *hud;
}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSTimer        *sendTimer;
@property (nonatomic, retain) MBProgressHUD  *hud;

@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;



- (IBAction)sliderValueChange:(id)sender;




@end
