//
//  OfficalViewControllerOC.m
//  Live2DDemo
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OfficalViewControllerOC.h"
#include "LAppLive2DManager.h"

@implementation OfficalViewControllerOC {
    LAppLive2DManager *live2DMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    live2DMgr = new LAppLive2DManager();
    CGRect screen = [UIScreen mainScreen].bounds;
    LAppView *view = live2DMgr->createView(screen);
    
    switch (self.type) {
        case OfficalTypeHaru:
            live2DMgr->loadModel("HaruFullPack/haru.model.json");
            break;
            
        case OfficalTypeHaru01:
            live2DMgr->loadModel("HaruFullPack/haru_01.model.json");
            break;
            
        case OfficalTypeHaru02:
            live2DMgr->loadModel("HaruFullPack/haru_02.model.json");
            break;
            
        case OfficalTypeWanko:
            live2DMgr->loadModel("WankoFullPack/wanko.model.json");
            break;
            
        case OfficalTypeShizuku:
            live2DMgr->loadModel("ShizukuFullPack/shizuku.model.json");
            break;
    }
    [self.view addSubview:view];
}

- (void)dealloc {
    delete live2DMgr;
    live2DMgr = nil;
}

@end
