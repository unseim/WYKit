//
//  UIImageView+FaceAwareFill.h
//  WYKit
//
//  Created by 汪年成 on 16/12/23.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FaceAwareFill)
/**
 *  图片当人脸被检测到时，它会就以脸部中心替代图片的集合中心
 */
- (void)faceAwareFill;

@end
