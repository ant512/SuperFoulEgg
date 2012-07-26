#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CCLayer.h"

@interface MenuRectLayer : CCLayer {
	NSUInteger _selectedIndex;
	NSMutableArray *_rectangles;
}

@property (readonly, retain, nonatomic) NSMutableArray *rectangles;
@property (readwrite, nonatomic) NSUInteger selectedIndex;

- (void)selectNext;
- (void)selectPrevious;

@end
