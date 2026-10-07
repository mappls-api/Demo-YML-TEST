//
//  CustomPointAnnotation.h

//
//  Created by apple on 18/12/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

@import MapplsMap;

// MGLAnnotation protocol reimplementation
@interface CustomAnnotation : NSObject <MGLAnnotation>

// As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

// Custom properties that we will use to customize the annotation's image.
@property (nonatomic, copy, nonnull) UIImage *image;
@property (nonatomic, copy, nonnull) NSString *reuseIdentifier;

@end
@implementation CustomAnnotation
@synthesize mapplsPin;

- (void)updateMapplsPin:(nonnull NSString *)atMapplsPin completionHandler:(nullable void (^)(BOOL, NSString * _Nullable))completion {
    
}

@end

