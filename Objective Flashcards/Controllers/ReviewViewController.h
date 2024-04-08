//
//  ReviewViewController.h
//  Objective Flashcards
//
//  Created by Arash on 5/4/24.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewViewController : UIViewController

@property (weak, nonatomic) NSManagedObjectID *selectedDeckID;

@property (weak, nonatomic) IBOutlet UILabel *labelCardText;
@property (weak, nonatomic) IBOutlet UILabel *labelCorrect;
@property (weak, nonatomic) IBOutlet UILabel *labelWrong;
@property (weak, nonatomic) IBOutlet UIControl *viewCard;

@end

NS_ASSUME_NONNULL_END
