//
//  ReviewViewController.m
//  Objective Flashcards
//
//  Created by Arash on 5/4/24.
//

#import "ReviewViewController.h"
#import "../AppDelegate.h"
#import "../Data/CoreDataManager.h"
#import "Deck+CoreDataClass.h"
#import "Card+CoreDataClass.h"

@interface ReviewViewController ()

@property NSManagedObjectContext *context;
@property CoreDataManager *manager;
@property Deck *selectedDeck;
@property NSMutableArray *cards;
@property Card *selectedCard;
@property bool isCardFlipped;
@property NSInteger correct;
@property NSInteger wrong;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    _manager = [[CoreDataManager alloc] initWithContext:_context];
    
    _selectedDeck = [_manager getDeckByID:_selectedDeckID];
    _cards = [_manager getCardsForDeckWithID:_selectedDeckID];
    
    _correct = 0;
    _wrong = 0;
    
    [self showNextCard];
}

#pragma mark - Methods

- (void)showNextCard {
    if (_selectedCard) {
        [_cards removeObject:_selectedCard];
    }
    
    if (_cards.count == 0) {
        NSLog(@"User has completed deck review. Proceeding back to home screen.");
        
        // Navigates back to the top of the navigation view stack
        UINavigationController *controller = self.navigationController;
        if (controller != nil && controller.viewControllers.count > 0) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Congratulations!"
                                        message:[NSString stringWithFormat:@"You've completed your review for now. So far, you've gotten %ld correct %s and %ld wrong %s.", _correct, _correct == 1 ? "guess" : "guesses", _wrong, _wrong == 1 ? "guess": "guesses"]
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
                [controller popToRootViewControllerAnimated:YES];
            }];
            
            [alert addAction:actionOk];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        _selectedCard = _cards[arc4random_uniform((unsigned int)_cards.count - 1)];
        _labelCardText.text = _selectedCard.frontText;
        _isCardFlipped = NO;
    }
}

#pragma mark - Interaction methods

- (IBAction)cardDidTap:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger xFactor = self->_isCardFlipped ? 1 : 1;
        NSInteger yFactor = self->_isCardFlipped ? 1 : -1;
        self->_viewCard.transform = CGAffineTransformMakeScale(xFactor, yFactor);
        self->_labelCardText.transform = CGAffineTransformMakeScale(xFactor, yFactor);
        
        if (self->_isCardFlipped) {
            self->_labelCardText.text = self->_selectedCard.frontText;
        } else {
            self->_labelCardText.text = self->_selectedCard.backText;
        }
    }];
    
    _isCardFlipped = !_isCardFlipped;
}

- (IBAction)yesButtonDidTap:(id)sender {
    _correct++;
    _labelCorrect.text = [NSString stringWithFormat:@"%ld", (long)_correct];
    
    [self showNextCard];
}

- (IBAction)noButtonDidTap:(id)sender {
    _wrong++;
    _labelWrong.text = [NSString stringWithFormat:@"%ld", (long)_wrong];
    
    [self showNextCard];
}

@end
