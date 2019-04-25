
//  ViewController.h
//  KeyWeLibTest
//
//  Created by 가드텍맥북 on 2018. 2. 21..
//  Copyright © 2018년 GuardTec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyWeLib.h"
#import "KeyWeDelegate.h"
@interface ViewController : UIViewController{
    
}

@property (nonatomic,strong)KeyWeLib* keywePlayer;
-(void) unLockDoor : (NSString *)macAddr eKey:(NSString*)eKeyDoor isNewDoor:(int)isNewDoor;

@end

