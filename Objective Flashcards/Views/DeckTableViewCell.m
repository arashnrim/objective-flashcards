//
//  DeckTableViewCell.m
//  Objective Flashcards
//
//  Created by Arash on 2/4/24.
//

#import "DeckTableViewCell.h"

@implementation DeckTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _viewDeck.layer.cornerRadius = 5.0;
//    _stackViewDeck.layoutMarginsRelativeArrangement = YES;
//    _stackViewDeck.layoutMargins = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
