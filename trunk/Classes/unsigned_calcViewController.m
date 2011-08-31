//
//  unsigned_calcViewController.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 22/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "unsigned_calcViewController.h"
#import "calc_engine/Matrix.h"
#import "calc_engine/Polynom.h"

@implementation unsigned_calcViewController

@synthesize mlabel;
@synthesize minput;
@synthesize mbMore;
@synthesize mlResult;
@synthesize mbOtherObject;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	m_state = not_set;
	[mbMore setTitle:@"More about input" forState:UIControlStateNormal];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Do stuff with Matrix",@"Do stuff with polynom",nil];
    actionSheet.tag = 10;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet release];
	
}
- (IBAction)doMoreButton{
	NSString* text;
	if(matrix == m_state){
		text = @"To add 2 martixes write [mat1]+[mat2]\n\
		To multiply 2 martixes write [mat1]*[mat2]\n\
		To multiply a matrix with a constant write [mat]*const\n\
		To get inverse write inv[mat]\n\
		To get determinant write det[mat]\n\
		To get adjoint write adj[mat]\n\
		To get triagonal write tri[mat]\n";
	}else if (polynom == m_state) {
		text = @"To add 2 polinoms write poly1+poly2\n\
		To multiply 2 polynoms write poly1*poly2";
	}
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:text
															 delegate:self
													cancelButtonTitle:@"0K" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.tag = 11;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet release];
}

-(IBAction)doOtherObjectButton{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Do stuff with Matrix",@"Do stuff with polynom",nil];
    actionSheet.tag = 10;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet release];
}



/*
 0 = matrix
 1 = polynom
 
 */
-(void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex{
	if(11 == actionSheet.tag){
		return;
	}
	else if(10 == actionSheet.tag){
		switch (buttonIndex) {
			case 0:
				m_state = matrix;
				[self doMatrix];
				break;
			case 1:
				m_state = polynom;
				[self doPolynom];
				break;
			default:
				break;
		}
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if(theTextField == minput) {
		[minput resignFirstResponder];
		[self getResult];
	}
	return YES;
}

-(void)getResult{
	if(matrix == m_state){
		[self parseMatrixInput];
	}else if (polynom == m_state) {
		[self parsePolynomInput];
	}
}

/*These 2 functions do both calculation and formalizing the result*/
-(void) parseMatrixInput{
	if(minput == nil)
		return;
	NSMutableString *ms_input = [NSMutableString stringWithString:minput.text];
	NSMutableString* ms_Res = [NSMutableString stringWithString:@"original input:\n"];
	Matrix* A = [Matrix alloc];
	Matrix* B = [Matrix alloc];
	Matrix* result = [Matrix alloc];
	float f_const;
	if (YES == [minput.text hasPrefix:@"det"]) {
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"det"]];
		[A initNewMatrixWithString: ms_input];
		[ms_Res appendFormat:@"%@\n",[A toString]];
		[ms_Res appendFormat:@"det = %f",A.m_fdet];
	}else if(YES == [minput.text hasPrefix:@"adj"]){
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"adj"]];
		[A initNewMatrixWithString: ms_input];
		[ms_Res appendFormat:@"%@\n",[A toString]];
		[A adjMat:B];
		[ms_Res appendFormat:@"adjoint matrix:\n %@",[B toString]];
	}else if (YES == [minput.text hasPrefix:@"inv"]) {
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"inv"]];
		[A initNewMatrixWithString: ms_input];
		[ms_Res appendFormat:@"%@\n",[A toString]];
		[ms_Res appendFormat:@"inverse matrix:\n %@",[A inverseMatrixToString]];
	}else if (YES == [minput.text hasPrefix:@"tri"]) {
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"tri"]];
		[A initNewMatrixWithString: ms_input];
		[ms_Res appendFormat:@"%@\n",[A toString]];
		[ms_Res appendFormat:@"triangle matrix:\n %@",[A triagonalMatrixToString]];
	}else {
		NSArray *chunks = [minput.text componentsSeparatedByString: @"*"];
		if([chunks count] == 2){/*it was multiplication*/
			[A initNewMatrixWithString: [chunks objectAtIndex:0]];	/*first object is always a matrix*/
			if(YES == [[chunks objectAtIndex:1] hasPrefix:@"["]){/*second object is a matrix*/
				[B initNewMatrixWithString: [chunks objectAtIndex:1]];
				[Matrix multiplyMatrix:A :B :result];
				[ms_Res appendFormat:@"%@*\n%@= \n",[A toString],[B toString]];
				[ms_Res appendFormat:@"%@",[result toString]];
			}else {/*it's a const*/
				f_const = [[chunks objectAtIndex:1] floatValue];
				[Matrix multiply: f_const: A:result];
				[ms_Res appendFormat:@"%f*%@= \n",f_const,[A toString]];
				[ms_Res appendFormat:@"%@",[result toString]];
			}
			
		}else {/*it's + */
			chunks = [minput.text componentsSeparatedByString: @"+"];
			[A initNewMatrixWithString: [chunks objectAtIndex:0]];
			[B initNewMatrixWithString: [chunks objectAtIndex:1]];
			[Matrix addMatrix:A :B :result];
			[ms_Res appendFormat:@"%@+\n%@= \n",[A toString],[B toString]];
			[ms_Res appendFormat:@"%@",[result toString]];
		}
	}
	[A release];
	[B release];
	[result release];
	mlResult.text = ms_Res;
	//[ms_Res release];
	//[ms_input release];
}

-(void) parsePolynomInput{
	/*TODO- add bracets for polynoms*/
	Polynom* p = [Polynom alloc];
	Polynom* q = [Polynom alloc];
	Polynom* res = [Polynom alloc];
	float f_const;
	NSMutableString* ms_Res = [NSMutableString stringWithString:@"original input:\n"];
	NSArray *chunks = [minput.text componentsSeparatedByString: @"*"];
	if([chunks count] == 2){/*it was multiplication*/
		[p initNewPolinomWithString:[chunks objectAtIndex:0]];	/*first object is always a matrix*/
		if(YES == [[chunks objectAtIndex:1] hasPrefix:@"("]){/*second object is a matrix*/
			[q initNewPolinomWithString:[chunks objectAtIndex:1]];
			[Polynom multiply:p :q :res];
			[ms_Res appendFormat:@"%@*\n%@= \n",[p toString],[q toString]];
			[ms_Res appendFormat:@"%@",[res toString]];
		}else {/*it's a const*/
			f_const = [[chunks objectAtIndex:1] floatValue];
			[Polynom constMultiply:p:f_const:res];
			[ms_Res appendFormat:@"%f*%@= \n",f_const,[p toString]];
			[ms_Res appendFormat:@"%@",[res toString]];
		}
	}else {/*it's + */
		chunks = [minput.text componentsSeparatedByString: @"+"];
		[p initNewPolinomWithString:[chunks objectAtIndex:0]];
		[q initNewPolinomWithString:[chunks objectAtIndex:1]];
		[Polynom add:p :q :res];
		[ms_Res appendFormat:@"%@+%@= \n",[p toString],[q toString]];
		[ms_Res appendFormat:@"%@",[res toString]];
	}
	[p release];
	[q release];
	[res release];
	mlResult.text = ms_Res;
}

-(void) doMatrix{
	mlabel.text = @"matrix input example\n[1 2 3;4 5 6;7 8 9]";
}
-(void) doPolynom{
	mlabel.text = @"polynom input example\nx^2+7x^1+-3x^0";
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mlabel release];
	[mlResult release];
	[mbMore release];
	[mbOtherObject release];
	[minput release];
    [super dealloc];
}


@end
