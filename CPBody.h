//
//  CPBody.h
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"

@class CPBody;

@protocol CPBodyDelegate
@optional 
-(void)integrateVelocityForBody:(CPBody*)b gravity:(cpVect)gravity damping:(cpFloat)damping delta:(cpFloat)dt;
-(void)integratePositionForBody:(CPBody*)b delta:(cpFloat)dt;
@end



@interface CPBody : NSObject {
  cpBody *cp;
  NSObject *data;
  id<NSObject, CPBodyDelegate> delegate;
}

@property (nonatomic, assign) id<NSObject, CPBodyDelegate> delegate;
@property (nonatomic, retain) NSObject *data;

@property (nonatomic, readonly) cpBody *cp;

@property (nonatomic) cpFloat mass;
@property (nonatomic) cpFloat moment;
@property (nonatomic) cpFloat angle;
@property (nonatomic) cpFloat angularVelocity;
@property (nonatomic) cpFloat torque;
@property (nonatomic) cpVect position;
@property (nonatomic) cpVect velocity;
@property (nonatomic) cpVect force;
@property (nonatomic, readonly) cpVect rotation;



-(id)initWithMass:(cpFloat)mass moment:(cpFloat)moment;
-(id)initWithMass:(cpFloat)mass momentForCircleWithRadius:(cpFloat)r1 innerRadius:(cpFloat)r2 offset:(cpVect)offset;
-(id)initWithMass:(cpFloat)mass momentForPolyWithVerts:(cpVect*)verts numVerts:(int)numVerts offset:(cpVect)offset;
-(id)initWithMass:(cpFloat)mass momentForSegmentWithPoint:(cpVect)a and:(cpVect)b;

//Integration Functions
//=====================

//void cpBodySlew(cpBody *body, cpVect pos, cpFloat dt);
//Modify the velocity of the body so that it will move to the specified absolute coordinates in the next timestep. Intended for objects that are moved manually with a custom velocity integration function.
-(void)slewTo:(cpVect)pos delta:(cpFloat)dt;

//void cpBodyUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
//Default rigid body velocity integration function. Updates the velocity of the body using Euler integration.
-(void)updateVelocityWithGravity:(cpVect)gravity dampling:(cpFloat)damping delta:(cpFloat)dt;

//void cpBodyUpdatePosition(cpBody *body, cpFloat dt)
//Default rigid body position integration function. Updates the position of the body using Euler integration. Unlike the velocity function, it's unlikely you'll want to override this function. If you do, make sure you understand it's source code as it's an important part of the collision/joint correction process.
-(void)updatePositionWithDelta:(cpFloat)dt;


//Coordinate Conversion Functions
//===============================

//cpVect cpBodyLocal2World(cpBody *body, cpVect v)
//Convert from body local coordinates to world space coordinates.
-(cpVect)worldFromLocal:(cpVect)v;

//cpVect cpBodyWorld2Local(cpBody *body, cpVect v)
//Convert from world space coordinates to body local coordinates.
-(cpVect)localFromWorld:(cpVect)v;


//Applying Forces and Torques
//===========================

//void cpBodyApplyImpulse(cpBody *body, cpVect j, cpVect r)
//Apply the impulse j to body at offset r. Both r and j are in absolute coordinates.
-(void)applyImpulse:(cpVect)j atOffset:(cpVect)r;

//void cpBodyResetForces(cpBody *body)
//Zero both the forces and torques accumulated on body.
-(void)resetForces;

//void cpBodyApplyForce(cpBody *body, cpVect f, cpVect r)
//Apply (accumulate) the force f on body with offset r. Both r and f are in world coordinates.
-(void)applyForce:(cpVect)f atOffset:(cpVect)r;

//void cpDampedSpring(cpBody *a, cpBody *b, cpVect anchr1, cpVect anchr2, cpFloat rlen, cpFloat k, cpFloat dmp, cpFloat dt)
//Apply a spring force between bodies a and b at anchors anchr1 and anchr2 respectively. k is the spring constant (Young's modulus), rlen is the rest length of the spring, dmp is the damping constant (force/velocity), and dt is the time step to apply the force over. Note: not solving the damping forces in the impulse solver causes problems with large damping values. This function will eventually be replaced by a new constraint (joint) type.
-(void)dampenSpringToBody:(CPBody*)b atAnchor:(cpVect)anchr1 andAnchor:(cpVect)anchr2 restLength:(cpFloat)rlen constant:(cpFloat)k damping:(cpFloat)dmp delta:(cpFloat)dt;

@end
