//
//  OfficalViewControllerOC.h
//  Live2DDemo
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OfficalType) {
    OfficalTypeHaru,
    OfficalTypeHaru01,
    OfficalTypeHaru02,
    OfficalTypeWanko,
    OfficalTypeShizuku
} ;

@interface OfficalViewControllerOC : UIViewController

@property (nonatomic, assign) OfficalType type;

@end
