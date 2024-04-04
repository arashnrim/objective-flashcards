//
//  DeckViewController.m
//  Objective Flashcards
//
//  Created by Arash on 3/4/24.
//

#import "DeckViewController.h"
#import "../AppDelegate.h"
#import "Deck+CoreDataClass.h"
#import "Card+CoreDataClass.h"
#import "../Data/CoreDataManager.h"

@interface DeckViewController ()

@property (atomic) NSManagedObjectContext *context;
@property (atomic) CoreDataManager *manager;
@property (atomic) Deck *selectedDeck;
@property (atomic) NSMutableArray *cards;

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    _manager = [[CoreDataManager alloc] initWithContext:_context];
    
    _selectedDeck = [_manager getDeckByID:_selectedDeckID];
    _cards = [_manager getCardsForDeckWithID:_selectedDeckID];
    
    // Sets the title of the navigation bar to match the deck's title
    self.navigationItem.title = _selectedDeck.deckTitle;
    
    // Adds a button at the top right with an alert to create a deck
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"New Card" style:UIBarButtonItemStyleDone target:self action:@selector(createCard)];
    self.navigationItem.rightBarButtonItem = button;
}

#pragma mark - Methods

/// Displays an alert to capture information and save a flashcard deck.
- (void)createCard {
    if (!_selectedDeck) {
        NSLog(@"_selectedDeck is null, meaning that the currently selected deck is abnormal. Evaluate immediately.");
        return;
    }
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return;
    }
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"New Card"
                                message:@"What would you like on the front (what's shown first) and back (the answer to be revealed later) of the card?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Text on front";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Text on back";
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionCreate = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Card *card = [[Card alloc] initWithContext:self->_context];
        
        card.frontText = alert.textFields[0].text;
        card.backText = alert.textFields[1].text;
        card.memberOf = self->_selectedDeck;
        [self->_selectedDeck addContainsObject:card];
        
        [self->_context save:nil];
        [self.tableView reloadData];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionCreate];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Card *card = _cards[indexPath.row];
    cell.textLabel.text = card.frontText;
    cell.detailTextLabel.text = card.backText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (!_context) {
            NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
            return;
        }
        
        Card *card = _cards[indexPath.row];
        [_context deleteObject:card];
        [_context save:nil];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
