//
//  main.m
//  Copyright © 2024 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "K2Settings.h"

@interface Settings : K2Settings
@property (nonatomic) NSString *name;
@property (nonatomic) int num;
@property (nonatomic) BOOL flag;
@end

@implementation Settings

@dynamic name, num, flag;

- (void)setDefaultValues
{
    self.name = @"a test name";
    self.num = 42;
    self.flag = YES;
}

@end

int main(int argc, const char * argv[])
{
    NSLog(@"running…");

    Settings *settings1 = [[Settings alloc] init];
    [settings1 resetDefaultValues];
    
    NSLog(@"settings1.name: %@", settings1.name);
    NSLog(@"settings1.num: %d", settings1.num);
    NSLog(@"settings1.flag: %@", settings1.flag ? @"Y" : @"N");

    Settings *settings2 = [[Settings alloc] init];
    NSLog(@"settings2.name before: %@", settings2.name);
    NSLog(@"settings2.num before: %d", settings2.num);
    NSLog(@"settings2.flag before: %@", settings2.flag ? @"Y" : @"N");

    settings2.name = @"a new name";
    settings2.num = 999;
    settings2.flag = NO;

    NSLog(@"settings2.name after: %@", settings2.name);
    NSLog(@"settings2.num after: %d", settings2.num);
    NSLog(@"settings2.flag after: %@", settings2.flag ? @"Y" : @"N");

    Settings *settings3 = [[Settings alloc] init];
    NSLog(@"settings3.name: %@", settings3.name);
    NSLog(@"settings3.num: %d", settings3.num);
    NSLog(@"settings3.flag: %@", settings3.flag ? @"Y" : @"N");

    return 0;
}
