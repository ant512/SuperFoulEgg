#import "CCLayer.h"

#import "cocos2d.h"
#import "MenuRectLayer.h"

@interface GameOptionsMenuLayer : CCLayer {
	MenuRectLayer *_rectLayer;
	NSMutableArray *_options;
	NSString *_title;
}

@property (readwrite, retain, nonatomic) NSString *title;

+ (CCScene*)scene;
- (id)init;
- (void)loadBackground;
- (void)addOption:(NSString *)option;

@end
