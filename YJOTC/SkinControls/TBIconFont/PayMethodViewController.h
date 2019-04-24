//
//  PayMethodViewController.h
//  TestDemo
//
//  Created by mac on 2017/3/17.
//  Copyright © 2017年 shigu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayMethodSelectionViewControllerDelegate <NSObject>

- (void)PayMethodSelectionViewControllerBackWithpayName:(NSString *)payname;

@end

@interface PayMethodViewController : UIViewController

@property(nonatomic)NSString *hasSelectPay;

@property(nonatomic, weak)id<PayMethodSelectionViewControllerDelegate>delegate;

@end
