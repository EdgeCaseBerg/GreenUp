//
//    Copyright (c) 2012 Norman Basham
//    http://www.apache.org/licenses/LICENSE-2.0
//
#import "NSArray+Primitive.h"

@implementation NSArray(Primitive)

-(BOOL)boolAtIndex:(NSUInteger)index {
    NSNumber* n = [self objectAtIndex:index];
    BOOL b = [n boolValue];
    return b;
}

-(char)charAtIndex:(NSUInteger)index {
    NSNumber* n = [self objectAtIndex:index];
    char c = [n charValue];
    return c;
}

-(int)intAtIndex:(NSUInteger)index {
    NSNumber* n = [self objectAtIndex:index];
    int i = [n intValue];
    return i;
}

-(float)floatAtIndex:(NSUInteger)index {
    NSNumber* n = [self objectAtIndex:index];
    float i = [n floatValue];
    return i;
}

@end

@implementation NSMutableArray(Primitive)

-(void)addBool:(BOOL)b {
    [self addObject:[NSNumber numberWithBool:b]];
}

-(void)insertBool:(BOOL)b atIndex:(NSUInteger)index {
    [self insertObject:[NSNumber numberWithBool:b] atIndex:index];
}

-(void)replaceBoolAtIndex:(NSUInteger)index withBool:(BOOL)b {
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:b]];
}

-(void)addChar:(char)c {
    [self addObject:[NSNumber numberWithChar:c]];
}

-(void)insertChar:(char)c atIndex:(NSUInteger)index {
    [self insertObject:[NSNumber numberWithChar:c] atIndex:index];
}

-(void)replaceCharAtIndex:(NSUInteger)index withChar:(char)c {
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithChar:c]];
}

-(void)addInt:(int)i {
    [self addObject:[NSNumber numberWithInt:i]];
}

-(void)insertInt:(int)i atIndex:(NSUInteger)index {
    [self insertObject:[NSNumber numberWithInt:i] atIndex:index];
}

-(void)replaceIntAtIndex:(NSUInteger)index withInt:(int)i {
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:i]];
}

-(void)addFloat:(float)f {
    [self addObject:[NSNumber numberWithFloat:f]];
}

-(void)insertFloat:(float)f atIndex:(NSUInteger)index {
    [self insertObject:[NSNumber numberWithFloat:f] atIndex:index];
}

-(void)replaceFloatAtIndex:(NSUInteger)index withFloat:(float)f {
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:f]];
}

@end
