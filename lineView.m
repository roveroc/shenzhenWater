//
//  lineView.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "lineView.h"

#define PI 3.14159265358979323846

@implementation lineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self roverDraw];
}

#pragma mark - 按iPhone5来的宽来算，坐标轴总长300，以五分钟一个间隔，即：24*（60/5）= 288
- (void)roverDraw{
    NSMutableArray *_arr1 = [[NSMutableArray alloc] initWithArray:(NSArray *)[[RoverGlobal sharedInstance].lineArray lastObject]];
    NSMutableArray *_arr2 = [[NSMutableArray alloc] initWithArray:(NSArray *)[[RoverGlobal sharedInstance].lineArray lastObject]];
    [_arr1 replaceObjectAtIndex:0 withObject:@"00:00"];
    [_arr2 replaceObjectAtIndex:0 withObject:@"24:00"];
    [[RoverGlobal sharedInstance].lineArray insertObject:_arr1 atIndex:0];
    [[RoverGlobal sharedInstance].lineArray addObject:_arr2];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    for(int i=0;i<3;i++){
        //设置连接类型
        CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
        //设置线条宽度
        CGContextSetLineWidth(currentContext,1.0f);
        if(i == 0)
            CGContextSetRGBStrokeColor(currentContext, 1.0, 0.1, 0.1, 1.);
        else if (i == 1)
            CGContextSetRGBStrokeColor(currentContext, 0.1, 1.0, 0.1, 1.);
        else if (i == 2)
            CGContextSetRGBStrokeColor(currentContext, 0.1, 0.1, 1.0, 1.);
        else if (i == 3)
            CGContextSetRGBStrokeColor(currentContext, 1.0, 1.0, 1.0, 1.);
        for(int j = 0;j<[RoverGlobal sharedInstance].lineArray.count;j++){
            NSMutableArray *tempArr = [[RoverGlobal sharedInstance].lineArray objectAtIndex:j];
            NSString *timeStr = [tempArr objectAtIndex:0];
            int time = [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue]*(60/5) +
                       [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:1] intValue]/5;
            int x = (int)((300*time)/288.);
            int y = 95 - [[tempArr objectAtIndex:i+1] intValue]*90/100.;
            //设置开始点位置
            if(j == 0)
                CGContextMoveToPoint(currentContext,x,y);
            //设置另一个终点
            else
                CGContextAddLineToPoint(currentContext,x,y);
        }
        //画线
        CGContextStrokePath(currentContext);
        for(int j = 1;j<[RoverGlobal sharedInstance].lineArray.count-1;j++){
            NSMutableArray *tempArr = [[RoverGlobal sharedInstance].lineArray objectAtIndex:j];
            NSString *timeStr = [tempArr objectAtIndex:0];
            int time = [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:0] intValue]*(60/5) +
                       [[[timeStr componentsSeparatedByString:@":"] objectAtIndex:1] intValue]/5;
            int x = (int)((300*time)/288.);
            int y = 95 - [[tempArr objectAtIndex:i+1] intValue]*90/100.;
            [self drawCrile:x y:y context:currentContext];
        }
    }
    [[RoverGlobal sharedInstance].lineArray removeObjectAtIndex:0];
    [[RoverGlobal sharedInstance].lineArray removeLastObject];
}


- (void)drawCrile:(int)x y:(int)y context:(CGContextRef)ref{
    //填充圆，无边框
    CGContextAddArc(ref, x, y, 4, 0, 2*PI, 0); //添加一个圆
    UIColor*aColor = [UIColor colorWithRed:0. green:1.0 blue:0.1 alpha:1];
    CGContextSetFillColorWithColor(ref, aColor.CGColor);//填充颜色
    CGContextDrawPath(ref, kCGPathFill);//绘制填充
}

@end
