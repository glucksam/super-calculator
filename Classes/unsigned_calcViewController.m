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
#import "calc_engine/Vector.h"
#import	"MatrixTester.h"
#import "PolynomialTester.h"

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
													otherButtonTitles:@"Do stuff with Matrix",@"Do stuff with polynomials",@"Do stuff with Vectors",nil];
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
		To get triagonal write tri[mat]\n\
		To get characteristic polynomial and\n\
		rational eigenvaues write char[mat]\n";
	}else if (polynom == m_state) {
		text = @"Type any polynomail in [] brackets\n\
		example: x^2+(-5)x^1+(-7)x^0\n\
		To add 2 polynomails write [poly1]+[poly2]\n\
		To multiply 2 polynomails write [poly1]*[poly2]\n\
		To evaluate the polinomial write eval[poly]num\n\
		To get rational roots of a polinomial write roots[poly]\n\
		To divide 2 polynomials write [poly1]/[poly2]\n";
	}else if (vector == m_state) {
		text = @"To add 2 vectors write [vec1]+[vec2]\n\
		To get inner product of 2 vectors write <[vec1];[vec2]>\n\
		To multiply a vector with a constant write [vec]*const\n";
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
													otherButtonTitles:@"Do stuff with Matrix",@"Do stuff with Polynomials",@"Do stuff with Vectors",nil];
	minput.text = @"";  
	mlResult.text = @"";
	actionSheet.tag = 10;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet release];
}



/*
 0 = matrix
 1 = polynom
 2 = vector
 
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
			case 2:
				m_state = vector;
				[self doVector];
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
	if (![self checkInput:minput.text]) {
		return;
	}
	if(matrix == m_state){
		[self parseMatrixInput];
	}else if (polynom == m_state) {
		[self parsePolynomInput];
	}else if (vector == m_state) {
		[self parseVectorInput];
	}
}
/*return true is it was a test or false otherwise*/
-(bool) checkAndTest:(NSString*)input{
	NSMutableString* sMsg = [[NSMutableString alloc]init];
	bool bRes = false;
	if ([input isEqualToString:@"test"]) {
		bRes = true;
		/*test matrices*/
		if ([MatrixTester SanityTest]){
			[sMsg appendFormat:@"Matrix: ALL TESTS PASSED!!! :D\n"];
		}else {
			[sMsg appendFormat:@"Matrix: At least one test FAILED\nsee log for more information :'(\n"];
		}
		/*test polynomials*/
		if ([PolynomialTester SanityTest]){
			[sMsg appendFormat:@"Polynomial: ALL TESTS PASSED!!! :D\n"];
		}else {
			[sMsg appendFormat:@"Polynomial: At least one test FAILED\nsee log for more information :'(\n"];
		}
		mlResult.text = sMsg;
	}
	[sMsg release];
	return bRes;
}
		 
-(bool) checkInput:(NSString*)input{
	if(minput == nil){
		return false;
	}
	if ([self checkAndTest:input]) {
		return false;
	}
	return true;
}
/*These 2 functions do both calculation and formalizing the result*/
-(void) parseMatrixInput{

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
		[ms_Res appendFormat:@"det = %0.3f",[A getDet]];
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
	}else if (YES == [minput.text hasPrefix:@"char"]) {
			[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"char"]];
			[A initNewMatrixWithString: ms_input];
			[ms_Res appendFormat:@"%@\n",[A toString]];
			[ms_Res appendFormat:@"char = %@",[A CharacteristicPolynomailandEigenvaluesToString]];
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
				[ms_Res appendFormat:@"%0.3f*%@= \n",f_const,[A toString]];
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
}

-(void) parsePolynomInput{
	Polynom* p = [Polynom alloc];
	Polynom* q = [Polynom alloc];
	Polynom* res = [Polynom alloc];
	Polynom* residue = [Polynom alloc];
	operation op;
	float f_value;
	NSMutableString *ms_input = [NSMutableString stringWithString:minput.text];
	NSMutableString* ms_Res = [NSMutableString stringWithString:@"original input:\n"];
	NSMutableString *mutableString;
	if (YES == [minput.text hasPrefix:@"eval"]) {
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"eval["]];
		NSArray *chunks = [ms_input componentsSeparatedByString: @"]"];
		f_value = [[chunks objectAtIndex:1] floatValue];
		[p initNewPolinomWithString: [chunks objectAtIndex:0]];
		[ms_Res appendFormat:@"value of %@ at x = %f is %f\n",[p toString],f_value
															,[p getValue:f_value]];
	}else if(YES == [minput.text hasPrefix:@"roots"]){
		[ms_input deleteCharactersInRange:[ms_input rangeOfString:@"roots["]];
		NSArray *chunks = [ms_input componentsSeparatedByString: @"]"];
		NSMutableString* mutStr = [[NSMutableString alloc] init];
		[p initNewPolinomWithString: [chunks objectAtIndex:0]];
		float* roots;
		[p getRationalRoots :&roots];
		int i;
		for (i = 1; i<= roots[0]; i++) {
			NSLog(@"root %i = %0.3f\n",i,roots[i]);
			[mutStr appendFormat:@"root %i = %0.3f\n",i,roots[i]];
		}
		[ms_Res appendFormat:@"%@\n%@",[p toString],mutStr];
		[mutStr release];
	}else{
		/*for operations with no prefix*/
		NSArray *chunks = [minput.text componentsSeparatedByString: @"["];
		if([chunks count] == 3){/*2 polynomails operation*/
			mutableString = [NSMutableString stringWithString:[chunks objectAtIndex:1]];
			if ([[chunks objectAtIndex:1]hasSuffix:@"*"]) {/*multiplication*/
				[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]*"]];
				op = multiply;
			}else if([[chunks objectAtIndex:1]hasSuffix:@"+"]){
				[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]+"]];
				op = plus;
			}else if([[chunks objectAtIndex:1]hasSuffix:@"/"]){
				[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]/"]];
				op = divide;
			}
			[p initNewPolinomWithString:mutableString];
			mutableString = [NSMutableString stringWithString:[chunks objectAtIndex:2]];
			[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]"]];
			[q initNewPolinomWithString:mutableString];
			switch (op) {
				case multiply:
					[Polynom multiply:p :q :res];
					[ms_Res appendFormat:@"%@*%@= %@\n",[p toString],[q toString],[res toString]];
					break;
				case plus:
					[Polynom add:p :q :res];
					[ms_Res appendFormat:@"%@+%@= %@\n",[p toString],[q toString],[res toString]];
					break;
				case divide:
					[Polynom divide:p :q :res:residue];
					[ms_Res appendFormat:@"%@/%@= %@ with residue %@\n",
					 [p toString],[q toString],[res toString],[residue toString]];
					break;
				default:
					break;
			}
		}
	}

	[p release];
	[q release];
	[res release];
	[residue release];
	mlResult.text = ms_Res;
}

-(void) parseVectorInput{
	Vector* v = [Vector alloc];
	Vector* u = [Vector alloc];
	Vector* res = [Vector alloc];
	double dTemp;
	NSMutableString* ms_Res = [NSMutableString stringWithString:@"original input:\n"];

	if (YES == [minput.text hasPrefix:@"<"]) {/*this is inner product*/
		NSMutableString *mutableString = [NSMutableString stringWithString:minput.text];
		[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"<"]];
		[mutableString deleteCharactersInRange:[mutableString rangeOfString: @">"]];
		NSArray *chunks = [mutableString componentsSeparatedByString: @";"];
		[v initNewVectorWithSring:[chunks objectAtIndex:0]];
		[u initNewVectorWithSring:[chunks objectAtIndex:1]];
		dTemp = [Vector inner_prod:v :u];
		[ms_Res appendFormat:@"<%@,%@> = %0.3f\n",[v toString],[u toString],dTemp];
	}else {
		NSArray *chunks = [minput.text componentsSeparatedByString: @"*"];
		if([chunks count] == 2){/*it was multiplication*/
			[v initNewVectorWithSring:[chunks objectAtIndex:0]];
			dTemp = [[chunks objectAtIndex:1] doubleValue];
			[Vector multiply:v :dTemp :u];
			[ms_Res appendFormat:@"%0.3f*%@= \n",dTemp,[v toString]];
			[ms_Res appendFormat:@"%@",[u toString]];
		}else {/*it's + */
			chunks = [minput.text componentsSeparatedByString: @"+"];
			[v initNewVectorWithSring:[chunks objectAtIndex:0]];
			[u initNewVectorWithSring:[chunks objectAtIndex:1]];
			[Vector add:v :u :res];
			[ms_Res appendFormat:@"%@+\n%@= \n",[v toString],[u toString]];
			[ms_Res appendFormat:@"%@",[res toString]];
		}
	}

	[v release];
	[u release];
	[res release];
	mlResult.text = ms_Res;
}

-(void) doMatrix{
	mlabel.text = @"matrix input example\n[1 2 3;4 5 6;7 8 9]";
}

-(void) doPolynom{
	mlabel.text = @"polynom input example\n[1x^2+7x^1+-3x^0]";
}

-(void) doVector{
	mlabel.text = @"vector input example\n[v1,v2,...,vn]";
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
