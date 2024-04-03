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

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Deck *selectedDeck = [self getDeckByID:self.selectedDeckId];
    self.navigationItem.title = selectedDeck.deckTitle;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"New Card" style:UIBarButtonItemStyleDone target:self action:@selector(createCard)];
    self.navigationItem.rightBarButtonItem = button;
}

#pragma mark - Methods

- (Deck *)getDeckByID:(NSManagedObjectID *)deckID {
    Deck *deck;
    
    NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    deck = [context objectWithID:deckID];
    
    return deck;
}

- (NSMutableArray *)getCardsForDeckWithID: (NSManagedObjectID *)deckID {
    NSMutableArray *cards = [NSMutableArray new];
    
    NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    Deck *deck = [self getDeckByID:self.selectedDeckId];
    NSArray *cardIDs = [deck objectIDsForRelationshipNamed:@"contains"];
    
    for (int i = 0; i < cardIDs.count; i++) {
        [cards addObject:[context objectWithID:cardIDs[i]]];
    }
    
    return cards;
}

- (void)createCard {
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
        NSManagedObjectContext *context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
        Card *card = [[Card alloc] initWithContext:context];
        Deck *deck = [self getDeckByID:self.selectedDeckId];
        
        card.frontText = alert.textFields[0].text;
        card.backText = alert.textFields[1].text;
        card.memberOf = [self getDeckByID:self.selectedDeckId];
        [deck addContainsObject:card];
        
        [context save:nil];
        [self.tableView reloadData];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionCreate];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCardsForDeckWithID:self.selectedDeckId].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Card *card = [self getCardsForDeckWithID:self.selectedDeckId][indexPath.row];
    cell.textLabel.text = card.frontText;
    cell.detailTextLabel.text = card.backText;
    
    return cell;
}

@end
