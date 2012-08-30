#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface ZombieLayer : CCLayer {
@private
	int _frames;
}

+ (CCScene*)scene;
- (id)init;
- (void)loadSounds;
- (void)loadBackground;

@end
