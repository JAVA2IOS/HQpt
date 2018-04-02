//
//  PercentageHistogramView.m
//  BankBigHouseKeeper
//
//  Created by Primb_yqx on 16/12/23.
//  Copyright © 2016年 primb. All rights reserved.
//

#import "PercentageHistogramView.h"

#define selfW self.frame.size.width
#define selfH self.frame.size.height

@interface PercentageHistogramView() {
    UIView *legendView;
    UIView *barView;
    UILabel *leftValue;
    UILabel *rightValue;
    UIView *leftBar;
    UIView *rightBar;
    float leftVals;
    float rightVals;
    float leftRate;
    float rightRate;
}
@end

@implementation PercentageHistogramView
-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    _legendFont = [AppPublic publicFont:NO size:12];
    _textFont = [AppPublic publicFont:NO size:12];
    _legenColor = UIColorFromRGB(0x666666);
    _textColor = UIColorFromRGB(0x333333);
    _barXOffset = 20;
    _labelHeight = 20;
    _legendGap = 10;
    _legendGapToText = 10;
    _legendXOffset = _barXOffset + 20;
    _legendYOffset = 30;
    _legendHeight = 20;
    _legendEnabled = YES;
    _barHeight = 20;
    _lineColor = [UIColor blackColor];
    _lineWidth = 1.0f;
    _leftLineHeight = self.frame.size.height / 3;
    _rightLineHeight = self.frame.size.height / 3;
    _barAnimtedTime = 0.3f;
    _labelAnimatedTime = 0.3f;
    _delayAnimatedTime = 0.0f;
    _circleSize = 4.0f;
    leftVals = 0;
    rightVals = 0;
    return self;
}

-(void) drawRect:(CGRect)rect {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [obj removeFromSuperview];
    }];
    
    [self initBarView];
    [self animatedBarView];
}

//绘制视图
- (void)initBarView {
    [self getValues];
    [self drawLegendContentView];
    [self drawBarContentView];
}

//计算值
- (void)getValues {
    leftVals = [[_dataArray objectAtIndex:0] floatValue];
    rightVals = [[_dataArray objectAtIndex:1] floatValue];
    leftRate = leftVals / (leftVals + rightVals) * 100;
    rightRate = rightVals / (leftVals + rightVals) * 100;
}

//标签视图
- (void)drawLegendContentView {
    legendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfW, selfH / 3)];
    [self addSubview:legendView];
    if (_legendEnabled) {
        [self drawLegendLists];
    }
}

//柱状图
- (void)drawBarContentView {
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, legendView.frame.origin.y + legendView.frame.size.height, selfW, selfH / 3 * 2)];
    [self addSubview:barView];
    [self drawBarListsView];
    [self drawValueLabel];
}

/**
 柱状图动画显示
 */
- (void)animatedBarView {
    float totalW = barView.frame.size.width - _barXOffset * 2 - 5;
    float leftW = totalW * (leftRate / 100);
    float rightW = totalW * (rightRate / 100);
    
    [UIView animateWithDuration:_barAnimtedTime
                          delay:_delayAnimatedTime
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         float leftX = leftBar.frame.origin.x;
                         float leftY = leftBar.frame.origin.y;
                         float leftH = leftBar.frame.size.height;
                         leftBar.frame = CGRectMake(leftX, leftY, leftW, leftH);
                     } completion:^(BOOL finished) {
                         [self animtedLeftConnectingLine];
                     }];
    
    [UIView animateWithDuration:_barAnimtedTime
                          delay:_delayAnimatedTime
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         float rightX = rightBar.frame.origin.x - rightW;
                         float rightY = rightBar.frame.origin.y;
                         float rightH = rightBar.frame.size.height;
                         rightBar.frame = CGRectMake(rightX, rightY, rightW, rightH);
                     } completion:^(BOOL finished) {
                         [self animatedRightConnectingLine];
                     }];
}

/**
 左边连线动画显示
 */
- (void)animtedLeftConnectingLine {
    //左边连接线
    CABasicAnimation *leftLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftLineAnimation.duration = _labelAnimatedTime;
    leftLineAnimation.fromValue = @0;
    leftLineAnimation.toValue = @1;
    
    UIBezierPath *line = [[UIBezierPath alloc] init];
    CGPoint orginP;
    CGPoint turnP;
    CGPoint endP;
    
    //不超过4分之一时，绘制折线
    if (leftRate < 25.00f) {
        orginP = CGPointMake(leftBar.frame.size.width / 3 * 2 + leftBar.frame.origin.x, leftBar.frame.origin.y - 2);
        turnP = CGPointMake(orginP.x + _leftLineHeight / 3, orginP.y - _leftLineHeight / 3);
        endP = CGPointMake(turnP.x, orginP.y - _leftLineHeight);
        line = [self drawConnectingBrokenLineWidthOrginPoint:orginP
                                             andTurningPoint:turnP
                                                 andEndPoint:endP];
    }else {
        if(leftRate >= 25.00f && leftRate <= 50.00f){
            orginP = CGPointMake(leftBar.frame.size.width / 3 * 2 + leftBar.frame.origin.x, leftBar.frame.origin.y - 2);
            endP = CGPointMake(orginP.x, orginP.y - _leftLineHeight);
        }else {
            orginP = CGPointMake(leftBar.frame.size.width / 2 + leftBar.frame.origin.x, leftBar.frame.origin.y - 2);
            endP = CGPointMake(orginP.x, orginP.y - _leftLineHeight);
        }
        //否则绘制直线
        line = [self drawConnectingStraightLineWithOrginPoint:orginP
                                                  andEndPoint:endP];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = line.CGPath;
    layer.strokeColor = _lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = _lineWidth;
    [layer addAnimation:leftLineAnimation forKey:@"strokeEnd"];
    [barView.layer addSublayer:layer];
    
    UILabel *circle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _circleSize, _circleSize)];
    [barView addSubview:circle];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = circle.frame.size.height / 2;
    circle.backgroundColor = _lineColor;
    circle.alpha = 0;
    circle.center = endP;
    
    //判断文本是否在可视范围内
    if (leftValue.frame.size.width / 2 > endP.x) {
        leftValue.frame = CGRectMake(_barXOffset, endP.y - leftValue.frame.size.height, leftValue.frame.size.width, leftValue.frame.size.height);
    }else{
        leftValue.center = CGPointMake(endP.x, endP.y - leftValue.frame.size.height / 2);
    }
    
    [UIView animateWithDuration:0.1
                          delay:_labelAnimatedTime
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         circle.alpha = 1;
                     }completion:^(BOOL finished) {
                         leftValue.hidden = NO;
                     }];
}

/**
 右边连线动画显示
 */
- (void)animatedRightConnectingLine {
    //右边连接线
    CABasicAnimation *rightLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightLineAnimation.duration = _labelAnimatedTime;
    rightLineAnimation.fromValue = @0;
    rightLineAnimation.toValue = @1;
    
    UIBezierPath *line = [[UIBezierPath alloc] init];
    CGPoint orginP;
    CGPoint turnP;
    CGPoint endP;
    
    //不超过4分之一时，绘制折线
    if (rightRate < 25.00f) {
        orginP = CGPointMake(rightBar.frame.size.width / 3 + rightBar.frame.origin.x, rightBar.frame.origin.y - 2);
        turnP = CGPointMake(orginP.x - _rightLineHeight / 3, orginP.y - _rightLineHeight / 3);
        endP = CGPointMake(turnP.x, orginP.y - _rightLineHeight);
        line = [self drawConnectingBrokenLineWidthOrginPoint:orginP
                                             andTurningPoint:turnP
                                                 andEndPoint:endP];
    }else {
        if(rightRate >= 25.00f && rightRate <= 50.00f){
            orginP = CGPointMake(rightBar.frame.size.width / 3 + rightBar.frame.origin.x, rightBar.frame.origin.y - 2);
            endP = CGPointMake(orginP.x, orginP.y - _rightLineHeight);
        }else {
            orginP = CGPointMake(rightBar.frame.size.width / 2 + rightBar.frame.origin.x, rightBar.frame.origin.y - 2);
            endP = CGPointMake(orginP.x, orginP.y - _rightLineHeight);
        }
        //否则绘制直线
        line = [self drawConnectingStraightLineWithOrginPoint:orginP
                                                  andEndPoint:endP];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = line.CGPath;
    layer.strokeColor = _lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = _lineWidth;
    [layer addAnimation:rightLineAnimation forKey:@"strokeEnd"];
    [barView.layer addSublayer:layer];
    
    UILabel *circle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _circleSize, _circleSize)];
    [barView addSubview:circle];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = circle.frame.size.height / 2;
    circle.backgroundColor = _lineColor;
    circle.alpha = 0;
    circle.center = endP;
    
    //判断文本是否在可视范围内
    if ((rightValue.frame.size.width / 2 + endP.x) >= barView.frame.size.width) {
        rightValue.frame = CGRectMake(barView.frame.size.width - _barXOffset - rightValue.frame.size.width, endP.y - rightValue.frame.size.height, rightValue.frame.size.width, rightValue.frame.size.height);
    }else {
        rightValue.center = CGPointMake(endP.x, endP.y - rightValue.frame.size.height / 2);
    }
    
    [UIView animateWithDuration:0.1
                          delay:_labelAnimatedTime
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         circle.alpha = 1;
                     }completion:^(BOOL finished) {
                         rightValue.hidden = NO;
                     }];
}


#pragma mark - 标签页
- (void)drawLegendLists {
    float rectX = _legendXOffset;
    float rectH = _legendHeight;
    float rectY = _legendYOffset;
    float gap = _legendGap;
    float topGap = rectH / 2;
    for (int i = 0; i < [_titleArray count]; i ++) {
        float textWidth = [self getStringWidth:[_titleArray objectAtIndex:i]
                                   andFont:_legendFont
                                 andOffset:5];
        float rectW = textWidth + rectH + _legendGapToText;
        if (rectX + rectW > legendView.frame.size.width) {
            rectY += rectH + topGap;
            rectX = _legendXOffset;
        }
        UIView *legend = [self drawLegendView:CGRectMake(rectX, rectY, rectW, rectH)
                                        color:[_colorArray objectAtIndex:i]
                                        title:[_titleArray objectAtIndex:i]];
        [legendView addSubview:legend];
        //重新计算坐标
        rectX = legend.frame.origin.x + legend.frame.size.width + gap;
    }
    
    float unitW = [self getStringWidth:[NSString stringWithFormat:@"单位：%@",_unit]
                               andFont:_legendFont
                             andOffset:10];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(legendView.frame.size.width - _legendXOffset - unitW, rectY + rectH, unitW, rectH)];
    if ([AppPublic JudgeEmptyOrNullOrNil:_unit]) {
        unitLabel.text = [NSString stringWithFormat:@"单位：%@",_unit];
    }
    unitLabel.font = _legendFont;
    unitLabel.textColor = _legenColor;
    [legendView addSubview:unitLabel];
}

//色块 + 文本
- (UIView *)drawLegendView:(CGRect)frame color:(UIColor *)color title:(NSString *)title {
    UIView *bg = [[UIView alloc] initWithFrame:frame];
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
    colorLabel.backgroundColor = color;
    [bg addSubview:colorLabel];
    
    float titleX = colorLabel.frame.origin.x + colorLabel.frame.size.width + _legendGapToText;
    float titleW = frame.size.width - titleX;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, titleW, frame.size.height)];
    titleLabel.text = title;
    titleLabel.font = _legendFont;
    titleLabel.textColor = _legenColor;
    [bg addSubview:titleLabel];
    
    return bg;
}


#pragma mark - 柱状图
- (void)drawBarListsView {
    float gap = _barXOffset;
    float barY = barView.frame.size.height / 3 * 2;
    float barH = _barHeight;
    leftBar = [[UIView alloc] initWithFrame:CGRectMake(gap, barY, 10, barH)];
    [barView addSubview:leftBar];
    leftBar.backgroundColor = [_colorArray objectAtIndex:0];
    
    float rightX = barView.frame.size.width - gap;
    rightBar = [[UIView alloc] initWithFrame:CGRectMake(rightX, barY, 10, barH)];
    [barView addSubview:rightBar];
    rightBar.backgroundColor = [_colorArray objectAtIndex:1];
}


#pragma mark - 值标签
- (void)drawValueLabel {
    NSString *leftStr = [NSString stringWithFormat:@"%@(%.2f%%)",
                         [[NSString stringWithFormat:@"%.2f",leftVals] toFormatNumberString],
                         leftRate];
    NSString *rightStr = [NSString stringWithFormat:@"%@(%.2f%%)",
                         [[NSString stringWithFormat:@"%.2f",rightVals] toFormatNumberString],
                         rightRate];
    float leftW = [self getStringWidth:leftStr andFont:_textFont andOffset:5];
    float rightW = [self getStringWidth:rightStr andFont:_textFont andOffset:5];
    
    leftValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftW, _labelHeight)];
    leftValue.text = leftStr;
    leftValue.font = _textFont;
    leftValue.textAlignment = NSTextAlignmentCenter;
    leftValue.textColor = _textColor;
    [barView addSubview:leftValue];
    leftValue.hidden = YES;
    
    rightValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightW, _labelHeight)];
    rightValue.text = rightStr;
    rightValue.font = _textFont;
    rightValue.textAlignment = NSTextAlignmentCenter;
    rightValue.textColor = _textColor;
    [barView addSubview:rightValue];
    rightValue.hidden = YES;
}

/**
 直线路径

 @param orginP 起点坐标
 @param endP 终点坐标
 @return 直线路径
 */
- (UIBezierPath *)drawConnectingStraightLineWithOrginPoint:(CGPoint)orginP
                                               andEndPoint:(CGPoint)endP
{
    return [self drawConnectingBrokenLineWidthOrginPoint:orginP andTurningPoint:endP andEndPoint:endP];
}

/**
 曲线路径

 @param orginP 起点坐标
 @param turnP 转折点坐标
 @param endP 终点坐标
 @return 曲线路径
 */
- (UIBezierPath *)drawConnectingBrokenLineWidthOrginPoint:(CGPoint)orginP
                                          andTurningPoint:(CGPoint)turnP
                                              andEndPoint:(CGPoint)endP
{
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [linePath moveToPoint:orginP];
    [linePath addLineToPoint:turnP];
    [linePath addLineToPoint:endP];
    
    return linePath;
}

#pragma mark - 获取文字宽度
- (float)getStringWidth:(NSString *)string andFont:(UIFont*)font andOffset:(float)offset {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize stringSize = [string boundingRectWithSize:CGSizeMake(1207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return stringSize.width + offset;
}


#pragma mark - setters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self setNeedsDisplay];
}

- (void)setColorArray:(NSArray *)colorArray {
    _colorArray = colorArray;
    [self setNeedsDisplay];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self setNeedsDisplay];
}

- (void)setUnit:(NSString *)unit {
    _unit = unit;
    [self setNeedsDisplay];
}

- (void)setDelayAnimatedTime:(float)delayAnimatedTime {
    _delayAnimatedTime = delayAnimatedTime;
    [self setNeedsDisplay];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void)setBarHeight:(float)barHeight {
    _barHeight = barHeight;
    [self setNeedsDisplay];
}

- (void)setBarXOffset:(float)barXOffset {
    _barXOffset = barXOffset;
    [self setNeedsDisplay];
}

- (void)setLegendXOffset:(float)legendXOffset {
    _legendXOffset = legendXOffset;
    [self setNeedsDisplay];
}

- (void)setLegendYOffset:(float)legendYOffset {
    _legendYOffset = legendYOffset;
    [self setNeedsDisplay];
}

- (void)setLegendGap:(float)legendGap {
    _legendGap = legendGap;
    [self setNeedsDisplay];
}

- (void)setLegenColor:(UIColor *)legenColor {
    _legenColor = legenColor;
    [self setNeedsDisplay];
}

- (void)setLegendFont:(UIFont *)legendFont {
    _legendFont = legendFont;
    [self setNeedsDisplay];
}

- (void)setLegendGapToText:(float)legendGapToText {
    _legendGapToText = legendGapToText;
    [self setNeedsDisplay];
}

- (void)setLegendHeight:(float)legendHeight {
    _legendHeight = legendHeight;
    [self setNeedsDisplay];
}

- (void)setLegendEnabled:(BOOL)legendEnabled {
    _legendEnabled = legendEnabled;
    [self setNeedsDisplay];
}

- (void)setLabelHeight:(float)labelHeight {
    _labelHeight = labelHeight;
    [self setNeedsDisplay];
}

- (void)setBarAnimtedTime:(float)barAnimtedTime {
    _barAnimtedTime = barAnimtedTime;
    [self setNeedsDisplay];
}

- (void)setLabelAnimatedTime:(float)labelAnimatedTime {
    _labelAnimatedTime = labelAnimatedTime;
    [self setNeedsDisplay];
}

- (void)setLeftLineHeight:(float)leftLineHeight {
    _leftLineHeight = leftLineHeight;
    [self setNeedsDisplay];
}

- (void)setRightLineHeight:(float)rightLineHeight {
    _rightLineHeight = rightLineHeight;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(float)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setCircleSize:(float)circleSize {
    _circleSize = circleSize;
    [self setNeedsDisplay];
}

@end
