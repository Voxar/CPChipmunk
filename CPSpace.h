//
//  CPSpace.h
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"

#import "CPBody.h"
#import "CPShape.h"
#import "CPConstraint.h"

@interface CPSpace : NSObject {
  cpSpace *cp;
  id delegate;
}

-(id)init;

@property (nonatomic, assign) id delegate;

@property (nonatomic, readonly) cpSpace *cp;

// Number of iterations to use in the impulse solver to solve contacts.
@property (nonatomic) int iterations;
// Number of iterations to use in the impulse solver to solve elastic collisions.
@property (nonatomic) int elasticIterations;
// Default gravity to supply when integrating rigid body motions.
@property (nonatomic) cpVect gravity;
// Default damping to supply when integrating rigid body motions.
@property (nonatomic) cpFloat damping;


//void cpSpaceFreeChildren(cpSpace *space)
//This function will free all of the shapes, bodies and joints that have been added to space. Does not free space. You will still need to call cpSpaceFree() on your own.
-(void)freeChildren;


//Operations
//==========

//void cpSpaceAddShape(cpSpace *space, cpShape *shape)
//void cpSpaceAddStaticShape(cpSpace *space, cpShape *shape)
//void cpSpaceAddBody(cpSpace *space, cpBody *body)
//void cpSpaceAddJoint(cpSpace *space, cpJoint *joint)

//void cpSpaceRemoveShape(cpSpace *space, cpShape *shape)
//void cpSpaceRemoveStaticShape(cpSpace *space, cpShape *shape)
//void cpSpaceRemoveBody(cpSpace *space, cpBody *body)
//void cpSpaceRemoveJoint(cpSpace *space, cpJoint *joint)

//These functions add and remove shapes, bodies and joints from space. Shapes added as static are assumed not to move. Static shapes should be be attached to a rigid body with an infinite /mass and moment of inertia. Also, don't add the rigid body used to the space, as that will cause it to fall under the effects of gravity.
-(void)addShape:(CPShape*)shape;
-(void)addStaticShape:(CPShape*)shape;
-(void)addBody:(CPBody*)body;
-(void)addConstraint:(CPConstraint*)constraint;

-(void)removeShape:(CPShape*)shape;
-(void)removeStaticShape:(CPShape*)shape;
-(void)removeBody:(CPBody*)body;
-(void)removeConstraint:(CPConstraint*)constraint;


//Spatial Hash Management Functions
//=================================

//Chipmunk uses a spatial hash to accelerate it's collision detection. While it's not necessary to interact with the hash directly. The current API does expose some of this at the space level to allow you to tune it.

//void cpSpaceResizeStaticHash(cpSpace *space, cpFloat dim, int count)
//void cpSpaceResizeActiveHash(cpSpace *space, cpFloat dim, int count)
//The spatial hashes used by Chipmunk's collision detection are fairly size sensitive. dim is the size of the hash cells. Setting dim to half the average collision shape size is likely to give the best performance. Setting 'dim' too small will cause the shape to be inserted into many cells, setting it too low will cause too many objects into the same slot.
//count is the suggested minimum number of cells in the hash table. If there are too few cells, the spatial hash will return many false positives. Too many cells will be hard on the cache and waste memory. the Setting count to ~10x the number of objects in the space is probably a good starting point. Tune from there if necessary.
//By default, dim is 100.0, and count is 1000.
-(void)resizeStaticHashCellSize:(cpFloat)dim count:(int)count;
-(void)resizeActiveHashCellSize:(cpFloat)dim count:(int)count;

//void cpSpaceRehashStatic(cpSpace *space)
//Rehashes the shapes in the static spatial hash. You only need to call this if you move a static shapes.
-(void)rehashStatic;

//Simulating the Space
//====================

//void cpSpaceStep(cpSpace *space, cpFloat dt)
//Update the space for the given time step. Using a fixed time step is highly recommended. Doing so will increase the efficiency of the contact persistence, requiring an order of magnitude fewer iterations to resolve the collisions in the usual case.
-(void)stepWithDelta:(cpFloat)dt;


//void cpSpaceShapePointQuery(cpSpace *space, cpVect point, cpSpacePointQueryFunc func, void *data);
//void cpSpaceStaticShapePointQuery(cpSpace *space, cpVect point, cpSpacePointQueryFunc func, void *data);
-(NSArray*)shapeQueryPoint:(cpVect)point;
-(NSArray*)staticShapeQueryPoint:(cpVect)point;

@end




@interface NSObject (ChipmunkSpaceDelegate)

//return wether the collision shall be handled by chipmunk or not
-(BOOL)shapesDidCollide:(CPShape*)shape1 with:(CPShape*)shape2 contacts:(NSArray*)contacts normalCoefficient:(cpFloat)normal_coef;

@end

