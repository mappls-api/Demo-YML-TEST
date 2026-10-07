//
//  DemoLocationPuckView.h

//
//  Created by apple on 19/08/19.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoLocationPuckView : UIView
- (void)updateWithLocation:(CLLocation*)location pitch:(CGFloat)pitch direction:(CLLocationDegrees)direction animated:(BOOL)animated tracksUserCourse:(BOOL)tracksUserCourse;
@end

NS_ASSUME_NONNULL_END
