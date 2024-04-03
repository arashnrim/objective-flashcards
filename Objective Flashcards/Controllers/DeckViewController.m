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

@interface DeckViewController ()

@property (atomic, weak) NSManagedObjectContext *context;
@property (atomic, weak) Deck *selectedDeck;

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    _selectedDeck = [self getDeckByID:self.selectedDeckID];
    
    // Sets the title of the navigation bar to match the deck's title
    self.navigationItem.title = _selectedDeck.deckTitle;
    
    // Adds a button at the top right with an alert to create a deck
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"New Card" style:UIBarButtonItemStyleDone target:self action:@selector(createCard)];
    self.navigationItem.rightBarButtonItem = button;
}

#pragma mark - Methods

/// Retrieves the corresponding `Deck` associated with the specified `deckID`.
///
/// - Parameter deckID: An `NSManagedObjectID` representing the ID of the deck to be returned.
///
/// - Returns: Either the `Deck` in its entirety if it's known by the context, a fault that represents a `Deck` otherwise, or `nil` if there is an exception.
///
/// - SeeAlso: [objectWithID](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/1506197-objectwithid)
- (Deck *)getDeckByID:(NSManagedObjectID *)deckID {
    Deck *deck;
    
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return nil;
    }
    
    deck = [_context objectWithID:deckID];
    return deck;
}

/// Retrieves the `Card`s associated with the currently selected `Deck` through the `"contains"` relationship.
///
/// - Returns: An `NSMutableArray` containing either entire `Card`s if known by the context, faults that represent `Card`s otherwise, or `nil` if there is an exception.
///
/// - SeeAlso: [objectWithID](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/1506197-objectwithid)
- (NSMutableArray *)getDeckCards {
    NSMutableArray *cards = [NSMutableArray new];
    
    if (!_selectedDeck) {
        NSLog(@"_selectedDeck is null, meaning that the currently selected deck is abnormal. Evaluate immediately.");
        return cards;
    }
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return cards;
    }
    
    NSArray *cardIDs = [_selectedDeck objectIDsForRelationshipNamed:@"contains"];
    for (int i = 0; i < cardIDs.count; i++) {
        [cards addObject:[_context objectWithID:cardIDs[i]]];
    }
    
    return cards;
}

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
        card.memberOf = [self getDeckByID:self.selectedDeckID];
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
    return [self getDeckCards].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Card *card = [self getDeckCards][indexPath.row];
    cell.textLabel.text = card.frontText;
    cell.detailTextLabel.text = card.backText;
    
    return cell;
}

@end
