//
//  ViewController.m
//  DragNDropTest
//
//  Created by Сергей Лепинин on 14/03/2019.
//  Copyright © 2019 Сергей Лепинин. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint touchDeltaPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view];
    
    //self.testView = view;
    
    //self.view.multipleTouchEnabled = true;
    
}

- (void) logTouches:(NSSet*)touches withMethod:(NSString*) methodName {
    
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    
    NSLog(@"%@", string);
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouches:touches withMethod:@"touchesBegan"];
    
    UITouch* touch = [touches anyObject];
    
    CGPoint pointOnMainView = [touch locationInView:self.view];
    
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    if (![view isEqual:self.view]) {
        
        self.draggingView = view;
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        
        self.touchDeltaPoint = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                           CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
        [self.draggingView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                             self.draggingView.alpha = 0.3f;
                         }];
        
    } else {
        self.draggingView = nil;
    }
    
    //CGPoint point = [touch locationInView:self.testView];
    
    //NSLog(@"inside = %d", [self.testView pointInside:point withEvent:event]);
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouches:touches withMethod:@"touchesMoved"];
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self.view];
        
        CGPoint correction = CGPointMake(point.x + self.touchDeltaPoint.x, point.y + self.touchDeltaPoint.y);
        
        self.draggingView.center = correction;
        
    }
    
}

- (void) onTouchesEnded {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.0f;
                     }];
    
    self.draggingView = nil;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    [self logTouches:touches withMethod:@"touchesEnded"];
    
    [self onTouchesEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    [self logTouches:touches withMethod:@"touchesCancelled"];
    
    [self onTouchesEnded];

}

@end
