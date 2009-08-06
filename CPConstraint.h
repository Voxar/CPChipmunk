//
//  CPConstraint.h
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"

@interface CPConstraint : NSObject {
  cpConstraint *cp;
}

-(id)initWithConstraint:(cpConstraint *)cp;

@property (nonatomic, readonly) cpConstraint *cp;

@end
