//
//  mapVCOC.h

//
//  Created by CE Info on 30/07/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapplsMap/MapplsMap.h>
#import <MapplsAPIKit/MapplsAPIKit.h>
@import MapplsUIWidgets;

@interface mapVCOC : UIViewController <MGLMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MapplsAutocompleteViewControllerDelegate>
@property(nonatomic) NSString *strType;
@end
