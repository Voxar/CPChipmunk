//
//  CPSpace.mm
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPSpace.h"
#import "chipmunk.h"


@interface CPSpace (CollisionDispatch)

-(int)dispatchCollisionForShape1:(CPShape*)shape1 shape2:(CPShape*)shape2 contacts:(NSArray*)contacts normalCoefficient:(cpFloat)normalCoefficient;

@end

@implementation CPSpace (CollisionDispatch)

-(int)dispatchCollisionForShape1:(CPShape*)shape1 shape2:(CPShape*)shape2 contacts:(NSArray*)contacts normalCoefficient:(cpFloat)normalCoefficient;
{
  if(delegate && [delegate respondsToSelector:@selector(shapesDidCollide:with:contacts:normalCoefficient:)]){
    return [delegate shapesDidCollide:shape1 with:shape2 contacts:contacts normalCoefficient:normalCoefficient] == YES ? 1 : 0;
  } 
  return 1;
}

@end

// space collision callback
int handleCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data){
  CPSpace *space = (CPSpace*)data;
  CPShape *shape1 = (CPShape*)a->data;
  CPShape *shape2 = (CPShape*)b->data;
  
  NSMutableArray *contactsArray = [NSMutableArray arrayWithCapacity:numContacts];
  for(int i = 0; i < numContacts; i++)
    [contactsArray addObject:[NSValue valueWithPointer:&contacts[i]]];
  
  int result = [space dispatchCollisionForShape1:shape1 shape2:shape2 contacts:contactsArray normalCoefficient:normal_coef];

  return result;
}


void handleQueryResult(cpShape *shape, void *data){
  NSMutableArray *array = (NSMutableArray*)data;
  CPShape *theShape = ((CPShape*)shape->data);
  [array addObject:theShape];
}



@implementation CPSpace

@synthesize delegate;

-(id)init;
{
  if((self = [super init])){
    cp = cpSpaceNew();
    cpSpaceAddCollisionPairFunc(cp, 0, 1, handleCollision, NULL);
  }
  return self;
}

-(void)dealloc;
{
  cpSpaceFree(cp);
  [super dealloc];
}

-(void)setDelegate:(id)newDelegate;
{
  //subscribe to collisions only of we have a delegate
  [newDelegate retain];
  [delegate release];
  
  if(delegate && !newDelegate){
    cpSpaceRemoveCollisionPairFunc(cp, 0, 0);
  }
  
  if(!delegate && newDelegate){
    cpSpaceAddCollisionPairFunc(cp, 0, 0, handleCollision, self);
  }
   delegate = newDelegate;
}

-(cpSpace *)cp; { return cp; }

-(int)iterations; { return cp->iterations; }
-(int)elasticIterations; { return cp->elasticIterations; }
-(cpVect)gravity; {return cp->gravity; }
-(cpFloat)damping; {return cp->damping; }

-(void)setIterations:(int)iterations; { cp->iterations = iterations; }
-(void)setElasticIterations:(int)elasticIterations; { cp->elasticIterations = elasticIterations; }
-(void)setGravity:(cpVect)gravity; { cp->gravity = gravity; }
-(void)setDamping:(cpFloat)damping; { cp->damping = damping; }


//void cpSpaceFreeChildren(cpSpace *space)
//This function will free all of the shapes, bodies and joints that have been added to space. Does not free space. You will still need to call cpSpaceFree() on your own.
-(void)freeChildren; 
{
  cpSpaceFreeChildren(cp);
}


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
-(void)addShape:(CPShape*)shape; { cpSpaceAddShape(cp, shape.cp); }
-(void)addStaticShape:(CPShape*)shape; { cpSpaceAddStaticShape(cp, shape.cp); }
-(void)addBody:(CPBody*)body; { cpSpaceAddBody(cp, body.cp); }
-(void)addConstraint:(CPConstraint*)constraint; { cpSpaceAddConstraint(cp, constraint.cp); }

-(void)removeShape:(CPShape*)shape; { cpSpaceRemoveShape(cp, shape.cp); }
-(void)removeStaticShape:(CPShape*)shape; { cpSpaceRemoveStaticShape(cp, shape.cp); }
-(void)removeBody:(CPBody*)body; { cpSpaceRemoveBody(cp, body.cp); }
-(void)removeConstraint:(CPConstraint*)constraint; { cpSpaceRemoveConstraint(cp, constraint.cp); }


//Spatial Hash Management Functions
//=================================

//Chipmunk uses a spatial hash to accelerate it's collision detection. While it's not necessary to interact with the hash directly. The current API does expose some of this at the space level to allow you to tune it.

//void cpSpaceResizeStaticHash(cpSpace *space, cpFloat dim, int count)
//void cpSpaceResizeActiveHash(cpSpace *space, cpFloat dim, int count)
//The spatial hashes used by Chipmunk's collision detection are fairly size sensitive. dim is the size of the hash cells. Setting dim to half the average collision shape size is likely to give the best performance. Setting 'dim' too small will cause the shape to be inserted into many cells, setting it too low will cause too many objects into the same slot.
//count is the suggested minimum number of cells in the hash table. If there are too few cells, the spatial hash will return many false positives. Too many cells will be hard on the cache and waste memory. the Setting count to ~10x the number of objects in the space is probably a good starting point. Tune from there if necessary.
//By default, dim is 100.0, and count is 1000.
-(void)resizeStaticHashCellSize:(cpFloat)dim count:(int)count; { cpSpaceResizeStaticHash(cp, dim, count); }
-(void)resizeActiveHashCellSize:(cpFloat)dim count:(int)count; { cpSpaceResizeActiveHash(cp, dim, count); }

//void cpSpaceRehashStatic(cpSpace *space)
//Rehashes the shapes in the static spatial hash. You only need to call this if you move a static shapes.
-(void)rehashStatic; { cpSpaceRehashStatic(cp); }

//Simulating the Space
//====================

//void cpSpaceStep(cpSpace *space, cpFloat dt)
//Update the space for the given time step. Using a fixed time step is highly recommended. Doing so will increase the efficiency of the contact persistence, requiring an order of magnitude fewer iterations to resolve the collisions in the usual case.
-(void)stepWithDelta:(cpFloat)dt; { cpSpaceStep(cp, dt); }


-(NSArray*)shapeQueryPoint:(cpVect)point;
{
  NSMutableArray *array = [NSMutableArray array];
  cpSpaceShapePointQuery(cp, point, handleQueryResult, array);
  return array;
}

-(NSArray*)staticShapeQueryPoint:(cpVect)point;
{
  NSMutableArray *array = [NSMutableArray array];
  cpSpaceStaticShapePointQuery(cp, point, handleQueryResult, array);
  return array;
}

@end
