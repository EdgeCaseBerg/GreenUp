//
//    Copyright (c) 2012 Norman Basham
//    http://www.apache.org/licenses/LICENSE-2.0
//
#import <Foundation/Foundation.h>

@interface NSArray(Primitive)
-(BOOL)boolAtIndex:(NSUInteger)index;
-(char)charAtIndex:(NSUInteger)index;
-(int)intAtIndex:(NSUInteger)index;
-(float)floatAtIndex:(NSUInteger)index;
@end

@interface NSMutableArray(Primitive)
-(void)addBool:(BOOL)b;
-(void)insertBool:(BOOL)b atIndex:(NSUInteger)index;
-(void)replaceBoolAtIndex:(NSUInteger)index withBool:(BOOL)b;

-(void)addChar:(char)c;
-(void)insertChar:(char)c atIndex:(NSUInteger)index;
-(void)replaceCharAtIndex:(NSUInteger)index withChar:(char)c;

-(void)addInt:(int)i;
-(void)insertInt:(int)i atIndex:(NSUInteger)index;
-(void)replaceIntAtIndex:(NSUInteger)index withInt:(int)i;

-(void)addFloat:(float)f;
-(void)insertFloat:(float)f atIndex:(NSUInteger)index;
-(void)replaceFloatAtIndex:(NSUInteger)index withFloat:(float)f;
@end