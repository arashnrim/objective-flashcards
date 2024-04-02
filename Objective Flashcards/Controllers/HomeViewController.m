//
//  ViewController.m
//  Objective Flashcards
//
//  Created by Arash on 29/3/24.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Encourages the app to have large titles where possible
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Sets the delegate and data source of the table view to the VC
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

// Determines the number of rows to fill in the table view. A required implementation under UITableViewDataSource.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

// Returns the table cell at the index specified. A required implementation under UITableView.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];
    
    return cell;
}

// Handles the event when users tap the row at the index specified.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController 
                                alertControllerWithTitle:@"YIPPEE"
                                message:[NSString stringWithFormat:@"The cell at the index %ld was selected.", (long)indexPath.row]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDismiss = [UIAlertAction 
                                    actionWithTitle:@"YIPPEE"
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
    
    [alert addAction:actionDismiss];
    
    [self presentViewController:alert animated:YES completion: nil];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 126.0;
//}


@end
