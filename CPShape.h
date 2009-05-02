//
//  CPShape.h
//  Lubba
//
//  Created by Patrik Sjöberg on 2009-04-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"

#import "CPBody.h"

@interface CPShape : NSObject {
  cpShape *cp;
  NSObject *data;
}

@property (nonatomic, readonly) cpShape *cp;
@property (nonatomic, retain) NSObject *data;


// The "class" of a shape as defined above 
//const cpShapeClass *klass;
@property (nonatomic, readonly) cpShapeType type; //only important var in klass

// cpBody that the shape is attached to.
@property (nonatomic, readonly) CPBody *body;

// Cached BBox for the shape.
@property (nonatomic, readonly) cpBB bb;

// *** Surface properties.

// Coefficient of restitution. (elasticity)
@property (nonatomic) cpFloat elasticity;

// Coefficient of friction.
@property (nonatomic) cpFloat friction; //u

// Surface velocity used when solving for friction.
@property (nonatomic) cpVect surfaceVelocity;//surface_v;

// *** User Definable Fields


// User defined collision type for the shape.
@property (nonatomic) unsigned int collisionType;
// User defined collision group for the shape.
@property (nonatomic) unsigned int group;
// User defined layer bitmask for the shape.
@property (nonatomic) unsigned int layers;

// *** Internally Used Fields

// Unique id used as the hash value.
@property (nonatomic, readonly) unsigned int hash;

@end




@interface CPCircleShape : CPShape
{
  
}

-(id)initWithBody:(CPBody*)body radius:(cpFloat)radius offset:(cpVect)offset;

// Center in body space coordinates
@property (nonatomic) cpVect center;
// Radius.
@property (nonatomic) cpFloat radius;
// Transformed center. (world space coordinates)
@property (nonatomic) cpVect transformedCenter;


@end



@interface CPSegmentShape : CPShape
{
  
}

-(id)initWithBody:(CPBody *)body pointA:(cpVect)pointA pointB:(cpVect)pointB radius:(cpFloat)radius;

// Endpoints and normal of the segment. (body space coordinates)
@property (nonatomic) cpVect pointA; //a
@property (nonatomic) cpVect pointB; //b
@property (nonatomic) cpVect normal; //n

// Radius of the segment. (Thickness)
@property (nonatomic) cpFloat radius; //r

// Transformed endpoints and normal. (world space coordinates)
@property (nonatomic) cpVect transformedPointA; //ta
@property (nonatomic) cpVect transformedPointB; //tb
@property (nonatomic) cpVect transformedNormal; //tn

@end



@interface CPPolyShape : CPShape {
  
}

+(id)polyShapeBoxWithBody:(CPBody*)body width:(float)width height:(float)height offset:(cpVect)offset;

-(id)initWithBody:(CPBody*)body vertexCount:(int)numVerts vertexes:(cpVect *)verts offset:(cpVect)offset;

@property (nonatomic, readonly) int numVerts;
@property (nonatomic, readonly) cpVect *verts;
@property (nonatomic, readonly) cpPolyShapeAxis *axes;

// Transformed vertex and axis lists.
@property (nonatomic, readonly) cpVect *transformedVerts;
@property (nonatomic, readonly) cpPolyShapeAxis *transformedAxes;

@end


