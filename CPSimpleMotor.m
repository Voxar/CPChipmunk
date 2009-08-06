//
//  CPSimpleMotor.m
//  Spel
//
//  Created by Patrik Sjöberg on 2009-07-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPSimpleMotor.h"


@implementation CPSimpleMotor

-(id)initWithBody1:(CPBody*)a and:(CPBody *)b rate:(float)rate;
{
  return [super initWithConstraint:(cpConstraint*)cpSimpleMotorNew(a.cp, b.cp, rate)];
}

-(cpFloat)rate;
{ 
  return ((cpSimpleMotor*)cp)->rate; 
}

-(void)setRate:(cpFloat)r;
{ 
  ((cpSimpleMotor*)cp)->rate = r; 
}
@end
