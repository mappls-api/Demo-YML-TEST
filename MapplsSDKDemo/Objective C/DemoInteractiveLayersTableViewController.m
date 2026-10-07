//
//  DemoInteractiveLayersTableViewController.m

//
//  Created by apple on 04/06/20.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import "DemoInteractiveLayersTableViewController.h"

@interface DemoInteractiveLayersTableViewController ()

@end

@implementation DemoInteractiveLayersTableViewController

- (void)setDelegate:(id<DemoInteractiveLayersTableViewControllerDelegate>)delegate
{
    if (_delegate == delegate) return;
    
    _delegate = delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
        
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.tableView.allowsMultipleSelection = YES;
    
    [self.tableView reloadData];
}

- (IBAction)donePressed:(id)sender
{
    NSMutableArray<MapplsInteractiveLayer *> * newSelectedLayers = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [newSelectedLayers addObject: _interactiveLayers[indexPath.row]];
    }
    
    if ([self.delegate respondsToSelector:@selector(layersSelected:)]) {
        [self.delegate layersSelected:newSelectedLayers];
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _interactiveLayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"LayerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    MapplsInteractiveLayer *layer = [_interactiveLayers objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:layer.layerName];
    
    for (MapplsInteractiveLayer * selectedLayer in _selectedInteractiveLayers) {
        if (selectedLayer.layerId == layer.layerId) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}


@end
