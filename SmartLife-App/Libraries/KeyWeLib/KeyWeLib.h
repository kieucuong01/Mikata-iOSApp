//
//  KeyWeLib.h
//  KeyWeLib
//
//  Created by 가드텍맥북 on 2018. 2. 13..
//  Copyright © 2018년 GuardTec. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KeyWeDoorLocks;
#import "KeyWeDelegate.h"
@interface KeyWeLib : NSObject{
    KeyWeDoorLocks* _KeyWeDoorLocks;
}
@property (nonatomic, assign) id <KeyWeDelegate> delegate;
-(NSString*)getVersion;
-(void)setDelegate:(id<KeyWeDelegate>)delegate;
-(void)DoorInfoSetting:(Byte*)eKey macAddr:(NSString*)macAddr moduleDesc:(int)moduleDesc;
-(void)DisPose;
-(void)Connect;
-(void)DisConnect;
-(void)GetDoorStatus;
-(void)UnLock;
-(void)Lock;
@end

//typedef enum{
//    SUCCESS,
//    ERROR_CONNECTION_FAIL,
//    ERROR_REGISTRATION_MODE,
//    ERROR_EKEY
//}ConnectionResult;


