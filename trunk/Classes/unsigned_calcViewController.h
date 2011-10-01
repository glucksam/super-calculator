//
//  unsigned_calcViewController.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 22/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
	not_set,
	matrix,
	polynom,
	vector,
}calculator_state;

typedef enum
{
	plus,
	minus,
	multiply,
	divide,
}operation;

@interface unsigned_calcViewController : UIViewController {
	calculator_state m_state;
	IBOutlet UILabel *mlabel;
	IBOutlet UILabel *mlResult;
	IBOutlet UITextField *minput;
	IBOutlet UIButton* mbMore;
	IBOutlet UIButton* mbOtherObject;	
}
@property (nonatomic, retain) UILabel *mlabel;
@property (nonatomic, retain) UILabel *mlResult;
@property (nonatomic, retain) UITextField *minput;
@property (nonatomic, retain) UIButton *mbMore;
@property (nonatomic, retain) UIButton *mbOtherObject;

-(IBAction)doMoreButton;
-(IBAction)doOtherObjectButton;
-(void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex;
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField;
-(void) parseMatrixInput;
-(void) parsePolynomInput;
-(void) parseVectorInput;
-(void)getResult;
-(void) doMatrix;
-(void) doPolynom;
-(void) doVector;

@end

