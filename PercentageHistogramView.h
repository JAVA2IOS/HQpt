//
//  PercentageHistogramView.h
//  BankBigHouseKeeper
//
//  Created by Primb_yqx on 16/12/23.
//  Copyright © 2016年 primb. All rights reserved.
//

#import <UIKit/UIKit.h>
//水平百分占比柱状图
@interface PercentageHistogramView : UIView
/**
 柱子值数据
 */
@property (nonatomic, retain) NSArray *dataArray;
/**
 柱子背景颜色数据
 */
@property (nonatomic, retain) NSArray *colorArray;
/**
 值含义描述数据
 */
@property (nonatomic, retain) NSArray *titleArray;
/**
 单位
 */
@property (nonatomic, copy) NSString *unit;
/**
 标注视图字体
 */
@property (nonatomic, copy) UIFont *legendFont;
/**
 文本字体
 */
@property (nonatomic, copy) UIFont *textFont;
/**
 标注视图文本颜色
 */
@property (nonatomic, copy) UIColor *legenColor;
/**
 文本颜色
 */
@property (nonatomic, copy) UIColor *textColor;
/**
 连接线颜色
 */
@property (nonatomic, copy) UIColor *lineColor;
/**
 标注视图高度
 */
@property (nonatomic, assign) float legendHeight;
/**
 文本高度
 */
@property (nonatomic, assign) float labelHeight;
/**
 起始x偏移量
 */
@property (nonatomic, assign) float legendXOffset;
/**
 起始Y偏移量
 */
@property (nonatomic, assign) float legendYOffset;
/**
 标签视图间距
 */
@property (nonatomic, assign) float legendGap;
/**
 色块与文本之间间距
 */
@property (nonatomic, assign) float legendGapToText;
/**
 是否绘制标注视图，默认YES
 */
@property (nonatomic, assign) BOOL legendEnabled;
/**
 水平值柱子高度
 */
@property (nonatomic, assign) float barHeight;
/**
 动画执行时间长
 */
@property (nonatomic, assign) float barAnimtedTime;
/**
 文本绘制动画时间
 */
@property (nonatomic, assign) float labelAnimatedTime;
/**
 动画延迟时间
 */
@property (nonatomic, assign) float delayAnimatedTime;
/**
 柱子距离边界x偏移量
 */
@property (nonatomic, assign) float barXOffset;
/**
 线宽度
 */
@property (nonatomic, assign) float lineWidth;
/**
 左侧文本与柱子Y之间的间距
 */
@property (nonatomic, assign) float leftLineHeight;
/**
 右侧文本与柱子Y之间的间距
 */
@property (nonatomic, assign) float rightLineHeight;
/**
 连接线重点圆点的半径
 */
@property (nonatomic, assign) float circleSize;

@end
