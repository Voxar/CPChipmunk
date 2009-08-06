//
//  CPConstraint.mm
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPConstraint.h"


@implementation CPConstraint
@synthesize cp;

-(id)initWithConstraint:(cpConstraint *)_cp;
{
  if(![super init]) return nil;
  
  cp = _cp;
  
  return self;
}


@end
