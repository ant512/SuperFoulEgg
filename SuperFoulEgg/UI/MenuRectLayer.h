#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CCLayer.h"

@interface MenuRectLayer : CCLayer {
	NSUInteger _selectedGroupIndex;
	NSMutableArray *_rectangleGroups;
	NSMutableArray *_selectedRectangleIndexes;
}

@property (readonly, retain, nonatomic) NSMutableArray *rectangleGroups;
@property (readonly, retain, nonatomic) NSMutableArray *selectedRectangleIndexes;
@property (readwrite, nonatomic) NSUInteger selectedGroupIndex;

- (void)selectNextRectangle;
- (void)selectPreviousRectangle;

- (void)selectNextGroup;
- (void)selectPreviousGroup;

- (BOOL)selectBelowRectangle;
- (BOOL)selectAboveRectangle;

- (NSUInteger)selectedIndexInGroup:(NSUInteger)groupIndex;

@end
