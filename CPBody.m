//
//  CPBody.m
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPBody.h"


void bodyVelocityFunc(struct cpBody *b, cpVect gravity, cpFloat damping, cpFloat dt)
{
  CPBody *body = (CPBody*)b->data;
  if([body.delegate respondsToSelector:@selector(integrateVelocityForBody:gravity:damping:delta:)])
    [body.delegate integrateVelocityForBody:body gravity:gravity damping:damping delta:dt];
}

void bodyPositionFunc(struct cpBody *b, cpFloat dt)
{
  CPBody *body = (CPBody*)b->data;
  if([body.delegate respondsToSelector:@selector(integratePositionForBody:delta:)])
    [body.delegate integratePositionForBody:body delta:dt];
}


@implementation CPBody

@synthesize delegate, data;
-(id)initWithMass:(cpFloat)mass moment:(cpFloat)moment;
{
  if((self = [super init])){
    cp = cpBodyNew(mass, moment);
    cp->data = self;
  }
  return self;
}

-(id)initWithMass:(cpFloat)mass momentForCircleWithRadius:(cpFloat)r1 innerRadius:(cpFloat)r2 offset:(cpVect)offset;
{
  return [self initWithMass:mass moment:cpMomentForCircle(mass, r1, r2, offset)];
}

-(id)initWithMass:(cpFloat)mass momentForPolyWithVerts:(cpVect*)verts numVerts:(int)numVerts offset:(cpVect)offset;
{
  return [self initWithMass:mass moment:cpMomentForPoly(mass, numVerts, verts, offset)];
}

-(id)initWithMass:(cpFloat)mass momentForSegmentWithPoint:(cpVect)a and:(cpVect)b;
{
  return [self initWithMass:mass moment:cpMomentForSegment(mass, a, b)];
}

-(void)dealloc;
{
  cpBodyFree(cp);
  [super dealloc];
}

-(cpBody*)cp; { return cp; }

-(cpFloat)mass; { return cp->m; }
-(cpFloat)moment; { return cp->i; }
-(cpFloat)angle; { return cp->a; }
-(cpFloat)angularVelocity; { return cp->w; }
-(cpFloat)torque; { return cp->t; }
-(cpVect)position; { return cp->p; }
-(cpVect)velocity; { return cp->v; }
-(cpVect)force; { return cp->f; }
-(cpVect)rotation; { return cp->rot; }

-(void)setMass:(cpFloat)m;            { cpBodySetMass(cp, m); }
-(void)setMoment:(cpFloat)i;         { cpBodySetMoment(cp, i); }
-(void)setAngle:(cpFloat)a;           { cpBodySetAngle(cp, a); }
-(void)setAngularVelocity:(cpFloat)w; { cp->w=w; }
-(void)setTorque:(cpFloat)t;          { cp->t=t; }
-(void)setPosition:(cpVect)p;         { cp->p=p; }
-(void)setVelocity:(cpVect)v;         { cp->v=v; }
-(void)setForce:(cpVect)f;            { cp->f=f; }


//Integration Functions
//=====================

//void cpBodySlew(cpBody *body, cpVect pos, cpFloat dt);
//Modify the velocity of the body so that it will move to the specified absolute coordinates in the next timestep. Intended for objects that are moved manually with a custom velocity integration function.
-(void)slewTo:(cpVect)pos delta:(cpFloat)dt;
{
  cpBodySlew(cp, pos, dt);
}

//void cpBodyUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
//Default rigid body velocity integration function. Updates the velocity of the body using Euler integration.
-(void)updateVelocityWithGravity:(cpVect)gravity dampling:(cpFloat)damping delta:(cpFloat)dt;
{
  cpBodyUpdateVelocity(cp, gravity, damping, dt);
}

//void cpBodyUpdatePosition(cpBody *body, cpFloat dt)
//Default rigid body position integration function. Updates the position of the body using Euler integration. Unlike the velocity function, it's unlikely you'll want to override this function. If you do, make sure you understand it's source code as it's an important part of the collision/joint correction process.
-(void)updatePositionWithDelta:(cpFloat)dt;
{
  cpBodyUpdatePosition(cp, dt);
}


//Coordinate Conversion Functions
//===============================

//cpVect cpBodyLocal2World(cpBody *body, cpVect v)
//Convert from body local coordinates to world space coordinates.
-(cpVect)worldFromLocal:(cpVect)v;
{
  return cpBodyLocal2World(cp, v);
}

//cpVect cpBodyWorld2Local(cpBody *body, cpVect v)
//Convert from world space coordinates to body local coordinates.
-(cpVect)localFromWorld:(cpVect)v;
{
  return cpBodyWorld2Local(cp, v);
}


//Applying Forces and Torques
//===========================

//void cpBodyApplyImpulse(cpBody *body, cpVect j, cpVect r)
//Apply the impulse j to body at offset r. Both r and j are in absolute coordinates.
-(void)applyImpulse:(cpVect)j atOffset:(cpVect)r;
{
  cpBodyApplyImpulse(cp, j, r);
}

//void cpBodyResetForces(cpBody *body)
//Zero both the forces and torques accumulated on body.
-(void)resetForces;
{
  cpBodyResetForces(cp);
}

//void cpBodyApplyForce(cpBody *body, cpVect f, cpVect r)
//Apply (accumulate) the force f on body with offset r. Both r and f are in world coordinates.
-(void)applyForce:(cpVect)f atOffset:(cpVect)r;
{
  cpBodyApplyForce(cp, f, r);
}

//void cpDampedSpring(cpBody *a, cpBody *b, cpVect anchr1, cpVect anchr2, cpFloat rlen, cpFloat k, cpFloat dmp, cpFloat dt)
//Apply a spring force between bodies a and b at anchors anchr1 and anchr2 respectively. k is the spring constant (Young's modulus), rlen is the rest length of the spring, dmp is the damping constant (force/velocity), and dt is the time step to apply the force over. Note: not solving the damping forces in the impulse solver causes problems with large damping values. This function will eventually be replaced by a new constraint (joint) type.
-(void)dampenSpringToBody:(CPBody*)b atAnchor:(cpVect)anchr1 andAnchor:(cpVect)anchr2 restLength:(cpFloat)rlen constant:(cpFloat)k damping:(cpFloat)dmp delta:(cpFloat)dt;
{
  //cpDampedSpring(cp, b, anchr1, anchr2, rlen, k, dmp, dt);
}

-(void)setDelegate:(id<NSObject, CPBodyDelegate>)newDelegate;
{
  if(delegate){
    cp->velocity_func = cpBodyUpdateVelocity;
    cp->position_func = cpBodyUpdatePosition;
  }
  delegate = newDelegate;

  if([delegate respondsToSelector:@selector(integrateVelocityForBody:gravity:damping:delta:)])
    cp->velocity_func = bodyVelocityFunc;
  if([delegate respondsToSelector:@selector(integratePositionForBody:delta:)])
    cp->position_func = bodyPositionFunc;
}

@end
