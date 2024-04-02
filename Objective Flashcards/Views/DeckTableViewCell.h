//
//  DeckTableViewCell.h
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewDeck;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@end

NS_ASSUME_NONNULL_END
