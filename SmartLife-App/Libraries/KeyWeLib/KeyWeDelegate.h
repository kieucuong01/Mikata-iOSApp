//
//  KeyWeDelegate.h
//  KeyWeLib
//
//  Created by 가드텍맥북 on 2018. 2. 19..
//  Copyright © 2018년 GuardTec. All rights reserved.
//

#ifndef KeyWeDelegate_h
#define KeyWeDelegate_h

@protocol KeyWeDelegate <NSObject>

@required

-(void)onConnected:(NSString*)macAddr connectionResult:(int)connectionResult;
-(void)onDisconnected:(NSString*)macAddr;
-(void)onGetDoorStatus:(NSString*)macAddr doorStatus:(NSMutableDictionary*)doorStatus;
-(void)onCommandReceived:(NSString*)macAddr cmdType:(NSString*)cmdType cmdResult:(NSString*)cmdResult;
// 제어


@optional

// 셋팅



@end


#endif /* KeyWeDelegate_h */
