//
//  StandingWithTeammateTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2016/1/15.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

#import "StandingWithTeammateTableViewController.h"
#import "StandingWithTeammateTableViewCell.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>


@interface StandingWithTeammateTableViewController ()


@end

@implementation StandingWithTeammateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    self.title = self.currentPlayerForStats[@"userName"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.gameType isEqualToString:@"Double"]) {
        return self.playerStatsWithDoubleGameArray.count;
    }else{
        return self.playerStatsWithMixGameArray.count;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    //    //headerView.backgroundColor = [UIColor greenColor];
    //    //tableView.sectionHeaderHeight = 44;
    //
    //    UILabel *winslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 125, 0, 30, 30)];
    //    winslabel.text = @"勝";
    //    winslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    //    winslabel.backgroundColor = [UIColor clearColor];
    //    winslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    //
    //    UILabel *loseslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 0, 30, 30)];
    //    loseslabel.text = @"敗";
    //    loseslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    //    loseslabel.backgroundColor = [UIColor clearColor];
    //    loseslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    //
    //    UILabel *winsRatelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55, 0, 45, 30)];
    //    winsRatelabel.text = @"勝率";
    //    winsRatelabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    //    winsRatelabel.backgroundColor = [UIColor clearColor];
    //    winsRatelabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    //
    //    [headerView addSubview:winslabel];
    //    [headerView addSubview:loseslabel];
    //    [headerView addSubview:winsRatelabel];
    //
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StandingWithTeammateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandingWithTeammateTableViewCell" forIndexPath:indexPath];
    NSURL * imageUrl;
    if ([self.gameType isEqualToString:@"Double"]) {
        cell.teammateNameLabel.text = self.playerStatsWithDoubleGameArray[indexPath.row][@"player"][@"userName"];
        
        imageUrl = [NSURL URLWithString:self.playerStatsWithDoubleGameArray[indexPath.row][@"player"][@"pictureUrl"]];
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.playerStatsWithDoubleGameArray[indexPath.row][@"wins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.playerStatsWithDoubleGameArray[indexPath.row][@"loses"]];
    }else{
        cell.teammateNameLabel.text = self.playerStatsWithMixGameArray[indexPath.row][@"player"][@"userName"];
        imageUrl = [NSURL URLWithString:self.playerStatsWithMixGameArray[indexPath.row][@"player"][@"pictureUrl"]];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.playerStatsWithMixGameArray[indexPath.row][@"wins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.playerStatsWithMixGameArray[indexPath.row][@"loses"]];
    }

    cell.playerImageView.layer.cornerRadius = 18.0f;
    cell.playerImageView.clipsToBounds = YES;
    [cell.playerImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}


@end
