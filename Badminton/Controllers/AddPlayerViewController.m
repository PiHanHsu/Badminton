//
//  AddPlayerViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/26.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "AddPlayerViewController.h"


@interface AddPlayerViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) Player * player;

@end

@implementation AddPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.searchResults count];
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    Player * player = [Player createPlayer];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        player = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        player = nil;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, (%@)",player[@"userName"], player[@"name"]];
    cell.textLabel.font =[UIFont systemFontOfSize:17];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.player = self.searchResults[indexPath.row];
    [self.teamObject addPlayer:self.player];
//    PFObject * teamObj = [PFObject objectWithClassName:@"Team"];
//    teamObj[@"players"] = @[self.player, self.player];
//    [teamObj saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}
  
#pragma mark -search filter
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"text: %@", searchText);
    
    if (searchText){
        self.searchResults = nil;
        PFQuery *queryWithuserName = [PFQuery queryWithClassName:@"Player"];
        [queryWithuserName whereKey:@"nameForSearch" containsString:[searchText lowercaseString]];
        
        PFQuery * queryWithName = [PFQuery queryWithClassName:@"Player"];
        [queryWithName whereKey:@"email" containsString:[searchText lowercaseString]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryWithuserName,queryWithName]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * results, NSError * error){
            if (results) {
                self.searchResults = results;
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            
            //NSLog(@"results count: %@", results.count);
            
            
        }];
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//        double yDiff = self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height - statusBarFrame.size.height;
//        self.navigationController.navigationBar.frame = CGRectMake(0, yDiff, 320, self.navigationController.navigationBar.frame.size.height);
//    }];
//    
//}


@end


