//
//  DynamicReceipt.m
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "DynamicReceipt.h"

@interface DynamicReceipt ()
{
    __weak IBOutlet UITableView *receiptTable;
    
    __weak IBOutlet UIButton* printBtn;
    __weak IBOutlet UIButton* closeBtn;
    
}

@end

@implementation DynamicReceipt


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    printBtn.layer.cornerRadius = 10;
    closeBtn.layer.cornerRadius = 10;
    
    [receiptTable registerClass:[ReceiptBasicInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptBasicInfoCell class])];
    [receiptTable registerClass:[ReceiptTicketInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptTicketInfoCell class])];
    [receiptTable registerClass:[ReceiptFeeInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptFeeInfoCell class])];
    [receiptTable registerClass:[ReceiptTotalInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptTotalInfoCell class])];
    [receiptTable registerClass:[ReceiptTaxInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptTaxInfoCell class])];
    [receiptTable registerClass:[ReceiptReservationCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptReservationCell class])];
    [receiptTable registerClass:[ReceiptServicesInfoCell class] forCellReuseIdentifier:NSStringFromClass([ReceiptServicesInfoCell class])];
    
    receiptTable.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = TRUE;
    [self addHomeButtonWithTitle:@"Home"];
    
}

/**
 *  @brief set back button with title to lef bar button
 */
- (void)addHomeButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(homeButtonPressed)];
    self.navigationItem.leftBarButtonItem = homeButton;
}

- (void)homeButtonPressed
{
    // write your code to prepare popview
    [self.navigationController popViewControllerAnimated:YES];
    
//    NSArray *viewControllers = [[self navigationController] viewControllers];
//    for( int i=0;i<[viewControllers count];i++){
//        id obj=[viewControllers objectAtIndex:i];
//        if([obj isKindOfClass:[HomeViewController class]]){
//            [[self navigationController] popToViewController:obj animated:YES];
//            return;
//        }
//    }
    
}

- (void)popingViewController
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [self getReceiptBasicInfoCell : indexPath];
            break;
            
        case 1:
            return [self getReceiptTicketInfoCell: indexPath];
            break;
            
        case 2:
            return [self getReceiptReservationInfoCell: indexPath];
            break;
            
        case 3:

            return [self getReceiptFeeInfoCell: indexPath];
            break;
            
        case 4:

            return [self getReceiptServiceInfoCell: indexPath];
            break;
            
        case 5:

            return [self getReceiptTaxInfoCell: indexPath];
            break;
       
        case 6:
            return [self getReceiptTotalInfoCell: indexPath];
            break;
            
        default:
      
            break;
    }
    
    return nil;
}

-(UITableViewCell*) getReceiptReservationInfoCell :(NSIndexPath*) path;
{
    ReceiptReservationCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptReservationCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}


-(UITableViewCell*) getReceiptServiceInfoCell :(NSIndexPath*) path;
{
    ReceiptServicesInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptServicesInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(UITableViewCell*) getReceiptTaxInfoCell :(NSIndexPath*) path;
{
    ReceiptTaxInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptTaxInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(UITableViewCell*) getReceiptTotalInfoCell :(NSIndexPath*) path;
{
    ReceiptTotalInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptTotalInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(UITableViewCell*) getReceiptFeeInfoCell :(NSIndexPath*) path;
{
    ReceiptFeeInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptFeeInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(UITableViewCell*) getReceiptBasicInfoCell :(NSIndexPath*) path;
{
    ReceiptBasicInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptBasicInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(UITableViewCell*) getReceiptTicketInfoCell :(NSIndexPath*) path;
{
    ReceiptTicketInfoCell* cell = [receiptTable dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiptTicketInfoCell class]) forIndexPath:path];
    
    [cell fillData:self.receiptData];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
             return [ReceiptBasicInfoCell getHeight];
        
        case 1 :
            return  [ReceiptTicketInfoCell getHeight];

        case 2 :
        {
            NSDictionary* dic = [[self.receiptData objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
            NSArray* resArr = [[[dic objectForKey:@"a:ticketInfo"] objectForKey:@"a:SelectedReservationInTicket"] objectForKey:@"a:Reservations"];
            
            if([resArr isKindOfClass:[NSDictionary class]])
            {
                //only one discount
                //need to create array containing this one reservation
                
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                
                [arr addObject:resArr];
                
                resArr = arr;
            }
            
            return  [ReceiptReservationCell getHeight: (int)resArr.count ];
        }
            
        case 3 :
        {
            NSDictionary* dic = [[self.receiptData objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
            NSArray* discountArr = [[[dic objectForKey:@"a:ticketInfo"] objectForKey:@"a:Discounts"] objectForKey:@"a:DiscountInfo"];
            
            if([discountArr isKindOfClass:[NSDictionary class]])
            {
                //only one discount
                //need to create array containing this one discount
                
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                
                [arr addObject:discountArr];
                
                discountArr = arr;
            }

            return  [ReceiptFeeInfoCell getHeight: (int)discountArr.count ];
        }
        case 4:
        {
            NSDictionary* dic = [[self.receiptData objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
                NSArray* servicesArr = [[dic objectForKey:@"a:selectedServices"] objectForKey:@"a:AddService"];
            if([servicesArr isKindOfClass:[NSDictionary class]])
            {
                //only one services
                //need to create array containing this one servies
                
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                
                [arr addObject:servicesArr];
                
                servicesArr = arr;
            }
            
            return  [ReceiptServicesInfoCell getHeight: (int)servicesArr.count ];

        }
            
        case 5 :
        {
            NSDictionary* dic = [[self.receiptData objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
            
            NSDictionary* parkingInfo = [dic objectForKey:@"a:parkingCharges"];
            
            NSArray* taxArr  = [[parkingInfo objectForKey:@"a:TaxInfoList"] objectForKey:@"a:TaxInfo"];
            
            if([taxArr isKindOfClass:[NSDictionary class]])
            {
                //only one tax
                //need to create array containing this one tax
                
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                
                [arr addObject:taxArr];
                
                taxArr = arr;
            }
            
            return  [ReceiptTaxInfoCell getHeight: (int)taxArr.count ];

        }
            
        case 6:
            return [ReceiptTotalInfoCell getHeight];
            
        default:
            
            break;
    }
    
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  7;
}

- (void)setPortName:(NSString *)m_portName
{
//    [AppDelegate setPortName:m_portName];
}

- (void)setPortSettings:(NSString *)m_portSettings
{
//    [AppDelegate setPortSettings:m_portSettings];
}


- (void)setPortInfo
{
    // TODO: Add port field at top of VC.
    NSString *localPortName = @"BT:PRNT Star";
    [self setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [self setPortSettings:localPortSettings];
}

-(UIImage*) generateReceiptImage
{
    CGPoint offset = [receiptTable contentOffset];
    
    receiptTable.contentOffset = CGPointMake(0.0, 0.0);
    
    UIGraphicsBeginImageContextWithOptions(receiptTable.contentSize, false, 1);
    
    int totalHeight = receiptTable.contentSize.height;
    
    CGRect visibleRect = receiptTable.bounds;
    
      while (totalHeight > 0)
      {
        
        [receiptTable scrollRectToVisible:visibleRect animated:NO];
        
        [receiptTable.layer renderInContext:UIGraphicsGetCurrentContext()];
      
        visibleRect.size.height = MIN(visibleRect.size.height, receiptTable.contentSize.height - visibleRect.origin.y);
        visibleRect.origin.y += visibleRect.size.height;
        totalHeight -= visibleRect.size.height;
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    
    receiptTable.contentOffset = offset;
    /*
    //
    //save
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //crop
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(10, 0, image.size.width - 60, image.size.height));
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //save
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    //resize
    CGSize size = CGSizeMake(580, (580*image.size.height/image.size.width));
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //save
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    //
    */
    return image;
}

-(IBAction) onPrintTapped:(id)sender
{
//    UIImage* receiptImage = [self generateReceiptImage];
//    
//    [self setPortInfo];
//    
//    NSString *portName = [AppDelegate getPortName];
//    NSString *portSettings = [AppDelegate getPortSettings];
//    
//    NSError *error = nil;
//    BOOL success = [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
//                                                           portSettings:portSettings
//                                                              widthInch:3
//                                                              withImage:receiptImage
//                                                                  error:&error];
//    if (!success) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
//                                                        message:error.localizedFailureReason
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(IBAction) onCloseTapped:(id)sender
{
    if (self.delegate)
        [self.delegate closeTapped];
}
@end
