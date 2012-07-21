#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CCLayer.h"

@interface MenuRectLayer : CCLayer {
	int _selectedIndex;
	NSMutableArray *_rectangles;
}

@property (readonly, retain, nonatomic) NSMutableArray *rectangles;
@property (readwrite, nonatomic) int selectedIndex;

- (void)selectNext;
- (void)selectPrevious;

@end
