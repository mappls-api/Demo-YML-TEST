////
////  CovidLayersExample.m
//
////
////  Created by apple on 04/06/20.
////  Copyright © 2022 Mappls. All rights reserved.
////
//
//#import "CovidLayersExample.h"
//#import "DemoInteractiveLayersTableViewController.h"
//
//@interface CovidLayersExample () <MapplsMapViewDelegate, DemoInteractiveLayersTableViewControllerDelegate>
//
//@property (nonatomic) IBOutlet MapplsMapView *mapView;
//
//@property (weak, nonatomic) IBOutlet UIButton *covidMarkerToggleButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *covid19Button;
//
//@property (weak, nonatomic) IBOutlet UILabel *covidInfoLabel;
//
//
//@end
//
//@implementation CovidLayersExample
//
//- (IBAction)covidMarkerToggleButtonPressed:(UIButton *)sender {
//    BOOL newState = !_covidMarkerToggleButton.isSelected;
//    [_covidMarkerToggleButton setSelected:newState];
//    [_mapView setShouldShowPopupForInteractiveLayer:newState];
//}
//
//- (IBAction)covid19ButtonPressed:(UIButton *)sender {
//    DemoInteractiveLayersTableViewController * interactiveLayersController = [[DemoInteractiveLayersTableViewController alloc] initWithNibName:nil bundle:nil];
//    interactiveLayersController.interactiveLayers = self.mapView.interactiveLayers;
//    interactiveLayersController.selectedInteractiveLayers = self.mapView.visibleInteractiveLayers;
//    interactiveLayersController.delegate = self;
//    UINavigationController *wrapper = [[UINavigationController alloc] initWithRootViewController:interactiveLayersController];
//    wrapper.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
//    [self.navigationController presentViewController:wrapper animated:YES completion:nil];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _mapView.delegate = self;
//    
//    _covidInfoLabel.text = @"";
//    _covidInfoLabel.backgroundColor = [UIColor whiteColor];
//    _covidInfoLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [_covidMarkerToggleButton setSelected:self.mapView.shouldShowPopupForInteractiveLayer];
//    [_covid19Button setHidden:YES];
//}
//
//
//- (void)mapView:(MapplsMapView *)mapView authorizationCompleted:(BOOL)isSuccess
//{
//    if(isSuccess) {
//        [self.mapView getCovidLayers];
//    }
//}
//
//- (void)mapViewInteractiveLayersReady:(MapplsMapView *)mapView
//{
//    if (self.mapView.interactiveLayers && self.mapView.interactiveLayers.count > 0) {
//        [_covid19Button setHidden:NO];
//    }
//}
//
//- (void)layersSelected:(NSArray<MapplsInteractiveLayer *> *)selectedInteractiveLayers
//{
//    for (MapplsInteractiveLayer *layer in self.mapView.interactiveLayers) {
//        BOOL isSelected = NO;
//        for (MapplsInteractiveLayer *selectedLayer in selectedInteractiveLayers) {
//            if (selectedLayer.layerId == layer.layerId) {
//                isSelected = YES;
//            }
//        }
//        
//        if (isSelected) {
//            [self.mapView showInteractiveLayerOnMapForLayerId:layer.layerId];
//        } else {
//            [self.mapView hideInteractiveLayerFromMapForLayerId:layer.layerId];
//        }
//    }
//}
//
//- (void)didDetectCovidInfo:(MapplsCovidInfo *)covidInfo
//{
//    if (covidInfo) {
//        NSMutableArray<NSString *> * covidInfoText = [[NSMutableArray alloc] init];
//        
//        if (covidInfo.total) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"Total: %@", covidInfo.total]];
//        }
//        if (covidInfo.cured) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"Cured: %@", covidInfo.cured]];
//        }
//        if (covidInfo.death) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"Death: %@", covidInfo.death]];
//        }
//        if (covidInfo.confInd) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"ConfInd: %@", covidInfo.confInd]];
//        }
//        if (covidInfo.areaZone) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"Zone: %@", covidInfo.areaZone]];
//        }
//        if (covidInfo.districtName) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"District: %@", covidInfo.districtName]];
//        }
//        if (covidInfo.stateName) {
//            [covidInfoText addObject: [NSString stringWithFormat:@"State: %@", covidInfo.stateName]];
//        }
//        
//        _covidInfoLabel.text =  [covidInfoText componentsJoinedByString:@"\n"];
//    } else {
//        _covidInfoLabel.text =  @"";
//    }
//}
//
//@end
