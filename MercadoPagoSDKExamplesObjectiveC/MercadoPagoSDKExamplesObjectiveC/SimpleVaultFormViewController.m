//
//  SimpleVaultFormViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 4/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "SimpleVaultFormViewController.h"
#import "InstallmentsTableViewController.h"
#import "ExampleUtils.h"

@implementation SimpleVaultFormViewController 

@synthesize paymentMethod;
@synthesize customerCard;
@synthesize allowInstallmentsSelection;
@synthesize amount;
@synthesize selectedPayerCost;
UIImageView *cardIcon;
UITextView *cardNumber;
UITextView *securityCode;
UITextView *cardholderName;
UITextView *identificationNumber;
UILabel *installmentsTitle;



- (IBAction)payButtonAction:(id)sender {
    [self clearFields];
    bool errorOcurred = NO;
    CardToken *cardToken;
    
    if (customerCard == nil) {
        cardToken = [[CardToken alloc] initWithCardNumber:cardNumber.text expirationMonth:11 expirationYear:22 securityCode:securityCode.text cardholderName:cardholderName.text docType:@"" docNumber:identificationNumber.text];
        if ([cardToken validateCardNumber] != nil) {
            cardNumber.backgroundColor = [UIColor redColor];
            errorOcurred = YES;
        } else if ([cardToken validateSecurityCode] != nil) {
            securityCode.backgroundColor = [UIColor redColor];
            errorOcurred = YES;
        } else if ([cardToken validateCardholderName] != nil){
            cardholderName.backgroundColor = [UIColor redColor];
            errorOcurred = YES;
        } else if ([cardToken validateIdentification] != nil){
            identificationNumber.backgroundColor = [UIColor redColor];
            errorOcurred = YES;
        }
    } else {
        NSLog(@"%@ %ld", customerCard.paymentMethod._id, customerCard.paymentMethod.secCodeLenght);
    /*    if (securityCode.text.length == 0 || customerCard.paymentMethod.secCodeLenght != securityCode.text.length) {
            securityCode.backgroundColor = [UIColor redColor];
            errorOcurred = YES;
        }*/
    }
    
    if (allowInstallmentsSelection && selectedPayerCost == nil) {
        installmentsTitle.textColor = [UIColor redColor];
        errorOcurred = YES;
    }
    
    if (!errorOcurred) {
        [MercadoPagoContext setPublicKey:MERCHANT_PUBLIC_KEY];
        [MercadoPagoContext setBaseURL:MERCHANT_MOCK_BASE_URL];
        [MercadoPagoContext setPaymentURI:MERCHANT_MOCK_CREATE_PAYMENT_URI];
        NSInteger installments = (selectedPayerCost == nil) ? 1 : selectedPayerCost.installments;
        
        if (customerCard == nil) {
            [MPServicesBuilder createNewCardToken:cardToken success:^(Token *token) {
                Item *item = [[Item alloc] initWith_id:@"1" title:@"item title" quantity:1 unitPrice:amount];
                MerchantPayment *merchantPayment = [[MerchantPayment alloc] initWithItems:[NSArray arrayWithObject:item] installments:installments cardIssuer:nil tokenId:token._id paymentMethod:paymentMethod campaignId:0];
                [MerchantServer createPayment:merchantPayment success:^(Payment *payment) {
                    UIViewController *congrats = [MPStepBuilder startPaymentCongratsStep:payment paymentMethod:paymentMethod callback:^(Payment *payment, NSString *congratsStatus) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [self.navigationController pushViewController:congrats animated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"Error ocurred : %@", error.description);
                }];
            } failure:^(NSError *error) {
                NSLog(@"Error ocurred : %@", error.description);
            }];
        
        } else {
            SavedCardToken *savedCardtoken = [[SavedCardToken alloc] initWithCard:customerCard securityCode:securityCode.text securityCodeRequired: [customerCard.paymentMethod isSecurityCodeRequired:customerCard.firstSixDigits]];
            
            [MPServicesBuilder createToken:savedCardtoken success:^(Token *token) {
                Item *item = [[Item alloc] initWith_id:@"1" title:@"item title" quantity:1 unitPrice:amount];
                MerchantPayment *merchantPayment = [[MerchantPayment alloc] initWithItems:[NSArray arrayWithObject:item] installments:installments cardIssuer:nil tokenId:token._id paymentMethod:customerCard.paymentMethod campaignId:0];
                [MerchantServer createPayment:merchantPayment success:^(Payment *payment) {
                    UIViewController *congrats = [MPStepBuilder startPaymentCongratsStep:payment paymentMethod:customerCard.paymentMethod callback:^(Payment *payment, NSString *congratsStatus) {
                        [[self navigationController] popViewControllerAnimated:YES];
                    }];
                    [self.navigationController pushViewController:congrats animated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"Error ocurred : %@", error.description);
                }];
            } failure:^(NSError *error) {
               NSLog(@"Error ocurred : %@", error.description);
            }];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = (allowInstallmentsSelection) ? 1 : 0;
    if (self.customerCard != nil) {
        return rows + 2;
    }
    return rows + 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            if (self.customerCard == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCardNumber"];
                cardIcon = [cell viewWithTag:1];
                cardNumber = [cell viewWithTag:2];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCustomerCard"];
            return cell;
            }
            break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPSecurityCode"];
            securityCode = [cell viewWithTag:1];
            return cell;
        }
            break;
        case 2:{
            if (self.customerCard == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPExpirationDate"];
                return cell;
            } else if (self.selectedPayerCost == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallmentsSelection"];
                installmentsTitle = [cell viewWithTag:1];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallment"];
            cell.textLabel.text = self.selectedPayerCost.recommendedMessage;
            return cell;

        }
            break;
        case 3:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPCardholderName"];
            cardholderName = [cell viewWithTag:1];
            return cell;
        }
            break;
        case 4:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPIdentification"];
            identificationNumber = [cell viewWithTag:2];
            return cell;
        }
            break;
        case 5:{
            if (self.selectedPayerCost == nil) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallmentsSelection"];
                installmentsTitle = [cell viewWithTag:1];
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPInstallment"];
            cell.textLabel.text = self.selectedPayerCost.recommendedMessage;
            return cell;
            
        }
        break;
        default:
            break;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self clearFields];

}

-(void) clearFields{
    cardNumber.backgroundColor = [UIColor whiteColor];
    securityCode.backgroundColor = [UIColor whiteColor];
    cardholderName.backgroundColor = [UIColor whiteColor];
    identificationNumber.backgroundColor = [UIColor whiteColor];
    installmentsTitle.textColor = [UIColor darkGrayColor];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"displayInstallmentsSegue"]) {
        InstallmentsTableViewController *installmentsVC = [segue destinationViewController];
        installmentsVC.card = customerCard;
        installmentsVC.amount = self.amount;
    }
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    InstallmentsTableViewController *installmentsVC = [segue sourceViewController];
    self.selectedPayerCost = installmentsVC.selectedPayerCost;
    [[self tableView] reloadData];
    
}


@end
