//
//  ViewController.m
//  Objective Flashcards
//
//  Created by Arash on 29/3/24.
//

#import "HomeViewController.h"
#import "../Views/DeckTableViewCell.h"
#import "../AppDelegate.h"
#import "Deck+CoreDataClass.h"
#import "DeckViewController.h"
#import "../Data/CoreDataManager.h"

@interface HomeViewController ()

@property (atomic) NSManagedObjectContext *context;
@property (atomic) CoreDataManager *manager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Encourages the app to have large titles where possible
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Defines the managed object context for interacting with the Core Data stack
    _context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    _manager = [[CoreDataManager alloc] initWithContext:_context];
    
    // Sets the delegate and data source of the table view to the VC
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Creates height spacing for each row
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Adds a button at the top right with an alert to create a deck
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"New Deck" style:UIBarButtonItemStylePlain target:self action:@selector(createDeck)];
    self.navigationItem.rightBarButtonItem = button;
}

// Configures the destination View Controller (DeckViewController) before the segue is performed
// Gives us an opportunity to pass any data we need to to the new VC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"segueEditDeck"]) {
        DeckViewController *vc = (DeckViewController *)segue.destinationViewController;
        vc.selectedDeckID = sender;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Methods

/// Displays an alert to capture information and save a flashcard deck.
- (void)createDeck {
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return;
    }
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"New Desk"
                                message:@"What would you like to call your desk, and what's it about?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Deck name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Deck description";
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionCreate = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Deck *newDeck = [[Deck alloc] initWithContext:self->_context];
        
        UITextField *textFieldDeckTitle = alert.textFields[0];
        UITextField *textFieldDescriptionTitle = alert.textFields[1];
        newDeck.deckTitle = textFieldDeckTitle.text;
        newDeck.deckDescription = textFieldDescriptionTitle.text;
        
        [self->_context save:nil];
        [self.tableView reloadData];
        NSLog(@"Created deck with title \"%@\" and description \"%@\".", textFieldDeckTitle.text, textFieldDescriptionTitle.text);
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionCreate];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view methods

// Determines the number of rows to fill in the table view. A required implementation under UITableViewDataSource.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_manager getDecks].count;
}

// Returns the table cell at the index specified. A required implementation under UITableView.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Deck *selectedDeck = (Deck *)[_manager getDecks][indexPath.row];
    
    cell.labelTitle.text = selectedDeck.deckTitle;
    cell.labelDescription.text = selectedDeck.deckDescription;
    
    NSMutableArray *selectedDeckCards = [_manager getCardsForDeckWithID:[selectedDeck objectID]];
    cell.labelCount.text = [NSString stringWithFormat:@"%lu card%s", (unsigned long)selectedDeckCards.count, selectedDeckCards.count == 1 ? "" : "s"];
    
    return cell;
}

// Handles the event when users tap the row at the index specified.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"What would you like to do with this deck?"
                                message:@"You can choose to edit the deck or review it now."
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionEdit = [UIAlertAction actionWithTitle:@"Edit this deck" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"segueEditDeck" sender:((Deck *)[self->_manager getDecks][indexPath.row]).objectID];
    }];
    UIAlertAction *actionReview = [UIAlertAction actionWithTitle:@"Review this deck" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: Handle this interaction
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:actionEdit];
    [alert addAction:actionReview];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (!_context) {
            NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
            return;
        }
        
        Deck *deck = [_manager getDecks][indexPath.row];
        NSMutableArray *itemsToDelete = [_manager getCardsForDeckWithID:[deck objectID]];
        [itemsToDelete addObject:deck];
        
        for (NSManagedObject *item in itemsToDelete) {
            [_context deleteObject:item];
            NSLog(@"Deleting %@...", item.description);
        }
        
        [_context save:nil];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
