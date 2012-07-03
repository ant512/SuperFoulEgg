#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CCLayer.h"

@interface RectLayer : CCLayer

@property (readonly, retain, nonatomic) NSMutableArray *rectangles;
@property (readwrite, nonatomic) int selectedIndex;

- (void)selectNext;
- (void)selectPrevious;

@end
