//
//  TeamListTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2016/1/29.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface TeamListTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@end
