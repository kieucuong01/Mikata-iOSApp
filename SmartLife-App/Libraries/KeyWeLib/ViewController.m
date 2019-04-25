//
//  ViewController.m
//  KeyWeLibTest
//
//  Created by 가드텍맥북 on 2018. 2. 21..
//  Copyright © 2018년 GuardTec. All rights reserved.
//

#import "ViewController.h"
#import "KeyWeLib.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize keywePlayer;

- (void)viewDidLoad {
    keywePlayer = [[KeyWeLib alloc]init];
}

-(void) unLockDoor : (NSString *)macAddr eKey:(NSString*)eKeyDoor isNewDoor:(int)isNewDoor {
    int i = 0, count = 0;
    uint8_t dataValue[6];
    if (eKeyDoor.length != 12)
    {
        NSLog(@"1stError");
    }
    for(i = 0; i < 12; i += 2)
    {
        NSString *hexChar=@"";
        if (i >=eKeyDoor.length) {
            hexChar =@"00";
        }else{
            hexChar = [eKeyDoor substringWithRange:NSMakeRange(i, 2)];
        }
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%X", &value);
        
        dataValue[i/2] = (uint8_t) value;
        count++;
    }
    if (eKeyDoor.length !=12) {
        //Error
    }else{
        [keywePlayer DoorInfoSetting:dataValue macAddr:macAddr moduleDesc:isNewDoor];
        [keywePlayer Connect];
    }
}
@end
