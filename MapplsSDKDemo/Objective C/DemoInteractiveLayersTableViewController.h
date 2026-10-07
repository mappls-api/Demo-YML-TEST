//
//  DemoInteractiveLayersTableViewController.h

//
//  Created by apple on 04/06/20.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapplsAPIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol DemoInteractiveLayersTableViewControllerDelegate<NSObject>

- (void)layersSelected:(NSArray<MapplsInteractiveLayer *> *) selectedInteractiveLayers;

@end

@interface DemoInteractiveLayersTableViewController : UITableViewController

@property(nonatomic, weak, nullable) id<DemoInteractiveLayersTableViewControllerDelegate> delegate;

@property (nonatomic, readwrite, nullable) NSArray<MapplsInteractiveLayer *> *interactiveLayers;
@property (nonatomic, readwrite, nullable) NSArray<MapplsInteractiveLayer *> *selectedInteractiveLayers;

@end

NS_ASSUME_NONNULL_END
