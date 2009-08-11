//
//  CPShape.mm
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPShape.h"
#import "CPBody.h"

@interface CPShape (Private)

-(id)initWithShape:(cpShape*)shape;

@end


@implementation CPShape

@synthesize data;

-(cpShape*)cp; { return cp; }

-(id)initWithShape:(cpShape*)shape;
{
  //do not init from this class.
  if((self = [super init])){
    cp = shape;
    cp->data = self;
  }
  return self;
}


-(void)dealloc;
{
  NSLog(@"shape delete");
  cp->data = nil;
  cpShapeFree(cp);
  [super dealloc];
}


//readonly
-(cpShapeType)type; { return cp->klass->type; }
-(CPBody*)body; { return ((CPBody*)cp->body->data); }
-(cpBB)bb; { return cp->bb; }

-(unsigned int)hash; { return cp->id; }

//readwrite

-(cpFloat)elasticity; { return cp->e; }
-(cpFloat)friction; { return cp->u; }
-(cpVect)surfaceVelocity; { return cp->surface_v; }

-(void)setElasticity:(cpFloat)e; { cp->e = e; }
-(void)setFriction:(cpFloat)u; { cp->u = u; }
-(void)setSurfaceVelocity:(cpVect)surface_v; { cp->surface_v = surface_v; }

-(unsigned int)collisionType; { return cp->collision_type; }
-(unsigned int)group; { return cp->group; }
-(unsigned int)layers; { return cp->layers; }


-(void)setCollisionType:(unsigned int)collision_type; { cp->collision_type = collision_type; }
-(void)setGroup:(unsigned int)group;    { cp->group = group; }
-(void)setLayers:(unsigned int)layers;  { cp->layers = layers; }

@end




@implementation CPCircleShape

-(id)initWithBody:(CPBody*)body radius:(cpFloat)radius offset:(cpVect)offset;
{
  return [super initWithShape:cpCircleShapeNew(body.cp, radius, offset)];
}

-(cpVect)center; { return ((cpCircleShape*)cp)->c; }
-(cpFloat)radius; { return ((cpCircleShape*)cp)->r; }
-(cpVect)transformedCenter; { return ((cpCircleShape*)cp)->tc; }

-(void)setCenter:(cpVect)c; { ((cpCircleShape*)cp)->c = c; }
-(void)setRadius:(cpFloat)r; { ((cpCircleShape*)cp)->r = r; }
-(void)setTransformedCenter:(cpVect)tc; { ((cpCircleShape*)cp)->tc = tc; }


@end



@implementation CPSegmentShape

-(id)initWithBody:(CPBody*)body pointA:(cpVect)a pointB:(cpVect)b radius:(cpFloat)radius;
{
  return [super initWithShape:cpSegmentShapeNew(body.cp, a, b, radius)];
}

-(cpVect)pointA;  { return ((cpSegmentShape*)cp)->a; }
-(cpVect)pointB;  { return ((cpSegmentShape*)cp)->b; }
-(cpVect)normal;  { return ((cpSegmentShape*)cp)->n; }

-(cpFloat)radius; { return ((cpSegmentShape*)cp)->r; }

-(cpVect)transformedPointA; { return ((cpSegmentShape*)cp)->ta; }
-(cpVect)transformedPointB; { return ((cpSegmentShape*)cp)->tb; }
-(cpVect)transformedNormal; { return ((cpSegmentShape*)cp)->tn; }

-(void)setPointA:(cpVect)a;            { ((cpSegmentShape*)cp)->a  = a; }
-(void)setPointB:(cpVect)b;            { ((cpSegmentShape*)cp)->b  = b; }
-(void)setNormal:(cpVect)n;            { ((cpSegmentShape*)cp)->n  = n; }

-(void)setRadius:(cpFloat)r;           { ((cpSegmentShape*)cp)->r  = r; }

-(void)setTransformedPointA:(cpVect)ta; { ((cpSegmentShape*)cp)->ta = ta; }
-(void)setTransformedPointB:(cpVect)tb; { ((cpSegmentShape*)cp)->tb = tb; }
-(void)setTransformedNormal:(cpVect)tn; { ((cpSegmentShape*)cp)->tn = tn; }


@end





@implementation CPPolyShape

+(id)polyShapeBoxWithBody:(CPBody*)body width:(float)width height:(float)height offset:(cpVect)offset;
{
  float w = width/2.0;
  float h = height/2.0;
  static cpVect verts[] = {
		cpv(-w,-h),
		cpv(-w, h),
		cpv( w, h),
		cpv( w,-h),
	};
  return [[[CPPolyShape alloc] initWithBody:body vertexCount:4 vertexes:verts offset:offset] autorelease];
}

-(id)initWithBody:(CPBody*)body vertexCount:(int)numVerts vertexes:(cpVect *)verts offset:(cpVect)offset;
{
  return [super initWithShape:cpPolyShapeNew(body.cp, numVerts, verts, offset)];
}

-(int)numVerts; { return ((cpPolyShape*)cp)->numVerts; }
-(cpVect *)verts; { return ((cpPolyShape*)cp)->verts; }
-(cpPolyShapeAxis *)axes; { return ((cpPolyShape*)cp)->axes; }

-(cpVect *)transformedVerts; { return ((cpPolyShape*) cp)->tVerts; }
-(cpPolyShapeAxis *)transformedAxes; { return ((cpPolyShape*)cp)->tAxes; }



@end