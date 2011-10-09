//
//  polymatrix.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 31/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "polymatrix.h"
#import "Polynom.h"
#import "Matrix.h"
#import "Logger.h"


@implementation polymatrix
@synthesize m_iSize;

-(void) set:(int)i:(int)j:(NSString*) sPol{
	Polynom* p = [Polynom alloc];
	[p initNewPolinomWithString:sPol];
	m_aMatrix[i][j] = p;
}
/**********************************************************************************************/
-(void) initNewPolymatrix:(int) size{
	[super init];
	[super setObjName:@"Polymatrix"];
	int i,j;
	m_iSize = size;
	m_aMatrix = (Polynom ***)malloc(m_iSize * sizeof(Polynom**));
	for (i = 0; i < m_iSize; i++) {
		m_aMatrix[i] = (Polynom **)malloc(m_iSize * sizeof(Polynom*));
		for (j = 0; j < m_iSize; j++) {
			[self set: i:j:@"0"];
		}
	}
}
/**********************************************************************************************/
-(void) initPolymatrixWithMatrix:(Matrix*) A{/*for calculation of Characteristic polynomial*/
	[self initNewPolymatrix:A.m_iSize];
	int i,j;
	NSString *string;
	for (i = 0; i < m_iSize; i++) {
		for (j = 0; j < m_iSize; j++) {
			if(i == j){
				string = [[NSString alloc] initWithFormat:@"1x^1+%fx^0",(-1)*[A getElement:i :j]];
			}else{
				string = [[NSString alloc] initWithFormat:@"%fx^0",(-1)*[A getElement:i :j]];
			}
			[self set: i:j:string];
		}
	}
	[[Logger getInstance] PrintToLog:@"New polymatrix" :INFO :POLYMATRIX :1,self];
}
/**********************************************************************************************/
-(void) det:(Polynom*) pDet{
	int* row = (int*)malloc(m_iSize * sizeof(int));
	int* col = (int*)malloc(m_iSize * sizeof(int));
	int i;
	for (i = 0; i<m_iSize; i++) {
		row[i] = i;
		col[i] = i;
	}
	[self det:row:col:m_iSize:pDet];
}
/**********************************************************************************************/
-(void) det:(int*) row:(int*) column: (int) size:(Polynom*) pDet{
	int i,j;
	Polynom* det = [Polynom alloc];
	Polynom* temp = [Polynom alloc];
	[det initNewPolinomWithString:@"0"];
	if(1 == size){
		pDet = m_aMatrix[row[0]][column[0]];
	}
	if(2 == size){
		Polynom* a = m_aMatrix[row[0]][column[0]];
		Polynom* b = m_aMatrix[row[0]][column[1]];
		Polynom* c = m_aMatrix[row[1]][column[0]];
		Polynom* d = m_aMatrix[row[1]][column[1]];
		[Polynom multiply:b :c :temp];
		[Polynom constMultiply:temp :-1.0 :temp];
		[Polynom multiply:a :d :det];
		[Polynom add:det :temp :pDet];
		[det release];
		[temp release];
		return;
	}
	[pDet initNewPolinomWithString:@"0"];
	for (i = 0; i < size; i++) {
		int* n_row = (int*)malloc((size-1) * sizeof(int));
		int* n_column = (int*)malloc((size-1) * sizeof(int));
		for (j = 0; j < size; j++) {
			if(j > 0){
				n_row[j-1] = row[j];
			}
			if(j < i){
				n_column[j] = column[j];
			} else if(j > i){
				n_column[j-1] = column[j];
			}		
		}
		[self det: n_row: n_column: size-1:temp];
		[Polynom multiply:m_aMatrix[row[0]][column[i]]:temp:temp];
		[Polynom constMultiply:temp :pow(-1, i):temp];
		[Polynom add:temp:pDet:pDet];
		[temp clean];
		free(n_row);
		free(n_column);
	}
	[det release];
	[temp release];
}
/**********************************************************************************************/
-(NSString*) toString{
	NSMutableString *print = [[NSMutableString alloc] init];
	int i,j;
	for(i = 0; i<m_iSize; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < m_iSize; j++){
			[line appendFormat:@" %@ ", [m_aMatrix[i][j] toString]];
		}
		[line appendFormat:@"\n"];
		[print appendString:line];
		[line release];
	}
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;
}
/**********************************************************************************************/
-(void) dealloc {
	int i,j;
	for (i = 0; i < m_iSize; i++){
		for (j = 0; j < m_iSize; j++){
			[m_aMatrix[i][j] release];
		}
		free(m_aMatrix[i]);
	}
	free(m_aMatrix);
	[super dealloc];
}

@end
