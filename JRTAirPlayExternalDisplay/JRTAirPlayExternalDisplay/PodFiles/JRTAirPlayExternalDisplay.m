//Copyright (c) 2015 Juan Carlos Garcia Alfaro. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "JRTAirPlayExternalDisplay.h"

@interface JRTAirPlayExternalDisplay ()
@property (strong, nonatomic) UIWindow *secondWindow;
@property (nonatomic,copy)void (^screenDidConnectBlock)();
@property (nonatomic,copy)void (^screenDidDisconnectBlock)();
@end

@implementation JRTAirPlayExternalDisplay

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                      [sharedInstance setUpScreenConnectionNotificationHandlers];
                  });
    
    return sharedInstance;
}

#pragma mark - Helper

- (void)setUpSecondWindowsWithScreen:(UIScreen *)secondScreen {
    self.secondWindow = [[UIWindow alloc] initWithFrame:secondScreen.bounds];
    self.secondWindow.screen = secondScreen;
    self.secondWindow.rootViewController = self.viewController;
    self.secondWindow.hidden = NO;
}


#pragma mark - Public

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    if (self.secondWindow) {
        self.secondWindow.rootViewController = self.viewController;
    }
    else if (self.isAvailable) {
        UIScreen *secondScreen = [self airplayScreen];
        [self setUpSecondWindowsWithScreen:secondScreen];
        if (self.screenDidConnectBlock) {
            self.screenDidConnectBlock();
        }
    }
}

- (BOOL)isAvailable
{
    return ([[UIScreen screens] count]>1);
}

- (UIScreen *)airplayScreen {
    UIScreen *screen;
    if (self.isAvailable) {
        screen = [[UIScreen screens] lastObject];
    }
    return screen;
}

#pragma mark - Notifications

- (void)setUpScreenConnectionNotificationHandlers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification {
    UIScreen *newScreen = [aNotification object];
    if (!self.secondWindow && self.viewController) {
        [self setUpSecondWindowsWithScreen:newScreen];
        if (self.screenDidConnectBlock) {
            self.screenDidConnectBlock();
        }
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification {
    if (self.secondWindow) {
        // Hide and then delete the window.
        self.secondWindow.hidden = YES;
        self.secondWindow = nil;
        if (self.screenDidDisconnectBlock) {
            self.screenDidDisconnectBlock();
        }
    }
}

@end
