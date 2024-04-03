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

@interface HomeViewController ()

@property (atomic, weak) NSManagedObjectContext *context;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Encourages the app to have large titles where possible
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Defines the managed object context for interacting with the Core Data stack
    _context = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    
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

#pragma mark - Methods

/// Retrieves the flashcard decks saved on the user's device through persistence.
///
/// - Returns: An `NSMutableArray` of `Deck`s representing the flashcard decks that the user has saved.
-(NSMutableArray *)getDecks {
    NSMutableArray *decks = [NSMutableArray new];
    
    if (!_context) {
        NSLog(@"_context is null, meaning that the Core Data stack is misconfigured. Evaluate immediately.");
        return decks;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
    NSError *error;
    decks = [[_context executeFetchRequest:request error:&error] mutableCopy];
    
    if (error) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Something went wrong."
                                    message:[NSString stringWithFormat:@"%@. %@", error.localizedDescription, error.localizedFailureReason ? error.localizedFailureReason : @"Please try again."]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return decks;
}

/// Displays an alert to capture information and save a flashcard deck.
-(void)createDeck {
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
    return [self getDecks].count;
}

// Returns the table cell at the index specified. A required implementation under UITableView.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.labelTitle.text = ((Deck *)[self getDecks][indexPath.row]).deckTitle;
    cell.labelDescription.text = ((Deck *)[self getDecks][indexPath.row]).deckDescription;
    
    return cell;
}

// Handles the event when users tap the row at the index specified.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"What would you like to do with this deck?"
                                message:@"You can choose to edit the deck or review it now."
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionEdit = [UIAlertAction actionWithTitle:@"Edit this deck" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"segueEditDeck" sender:((Deck *)[self getDecks][indexPath.row]).objectID];
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

@end
