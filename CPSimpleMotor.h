//
//  CPSimpleMotor.h
//  Spel
//
//  Created by Patrik Sjöberg on 2009-07-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPBody.h"
#import "CPConstraint.h"

@interface CPSimpleMotor : CPConstraint {

}

-(id)initWithBody1:(CPBody*)a and:(CPBody *)b rate:(float)rate;

@property (nonatomic, readonly) cpFloat rate;

@end
