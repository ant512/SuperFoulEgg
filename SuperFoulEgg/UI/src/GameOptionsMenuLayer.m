#import "GameOptionsMenuLayer.h"
#import "GameTypeMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "Pad.h"
#import "Settings.h"
#import "CCDirector.h"
#import "GameLayer.h"
#import "MenuRectLayer.h"
#import "GameOptionsMenuLayer.h"
#import "Constants.h"

@implementation GameOptionsMenuLayer

+ (CCScene *)scene {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOptionsMenuLayer *layer = [GameOptionsMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (void)addOptionRangeFrom:(int)start to:(int)end step:(int)step atY:(int)y withTitle:(NSString *)title {
	
	const int width = 60;
	const int height = 60;
	int x = (self.boundingBox.size.width - (width * ((end - start) / step + 1))) / 2;
	
	[self addCentredShadowedLabelWithString:title atY:y + height];
	
	int midPoint = -1;
	
	if (end - start > 5) {
		midPoint = start + ((end - start) / 2) + 1;
		
		x = (self.boundingBox.size.width - (width * (midPoint - start))) / 2;
	}
	
	for (int i = start; i <= end; i += step) {
		if (i == midPoint) {
			y -= height;
			x = (self.boundingBox.size.width - (width * (midPoint - start))) / 2;
		}
		
		[self addLabelWithString:[[NSNumber numberWithInt:i] stringValue] atX:x + (width / 2) y:y];
		[_rectLayer.rectangles addObject:[NSValue valueWithRect:NSMakeRect(x, y - (height / 2), width, height)]];
		
		x += width;
	}
}

- (void)addOption:(NSString *)option {
	
	int width = 340;
	int height = 80;
	
	int y = self.boundingBox.size.height - 200 - (80 * _options.count);
	int x = (self.boundingBox.size.width - width) / 2;
	
	//[self addCentredShadowedLabelWithString:option atY:y];
	
	[_rectLayer.rectangles addObject:[NSValue valueWithRect:NSMakeRect(x, y - 40, width, height)]];
	[_options addObject:option];
}

- (id)init {
	
	if ((self = [super init])) {
		
		_options = [[NSMutableArray array] retain];
		
		[self loadBackground];
		
		_rectLayer = [[MenuRectLayer alloc] init];
		[self addChild:_rectLayer];
		
		[self addOptionRangeFrom:0 to:9 step:1 atY:650 withTitle:@"Speed"];
		[self addOptionRangeFrom:0 to:9 step:1 atY:450 withTitle:@"Height"];
		[self addOptionRangeFrom:4 to:6 step:1 atY:250 withTitle:@"Colours"];
		[self addOptionRangeFrom:3 to:7 step:2 atY:100 withTitle:@"Best Of"];
		
		self.isKeyboardEnabled = YES;
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3"];
		}
	}
	
	return self;
}

- (void)dealloc {
	[_options release];
	[_rectLayer release];
	
	_options = nil;
	_rectLayer = nil;
	
	[super dealloc];
}

- (void)addCentredShadowedLabelWithString:(NSString *)text atY:(CGFloat)y {
	CCLabelTTF *shadow = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:30];
	CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:30];
	
	shadow.position = CGPointMake((self.boundingBox.size.width / 2) - SZShadowOffset, y - SZShadowOffset);
	
	ccColor3B color;
	color.b = 0;
	color.g = 0;
	color.r = 0;
	
	shadow.color = color;
	shadow.opacity = 192;
	
	label.position = CGPointMake(self.boundingBox.size.width / 2, y);
	
	[self addChild:shadow];
	[self addChild:label];
}

- (void)addLabelWithString:(NSString *)text atX:(CGFloat)x y:(CGFloat)y {
	CCLabelTTF *shadow = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:30];
	CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Lucida Grande" fontSize:30];
	
	shadow.position = CGPointMake(x - SZShadowOffset, y - SZShadowOffset);
	
	ccColor3B color;
	color.b = 0;
	color.g = 0;
	color.r = 0;
	
	shadow.color = color;
	shadow.opacity = 192;
	
	label.position = CGPointMake(x, y);
	
	[self addChild:shadow];
	[self addChild:label];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;
	
	CCSprite* background = [CCSprite spriteWithFile:@"menubackground.png"];
	background.position = ccp(x, y);
	[background.texture setAliasTexParameters];
	[self addChild:background z:0];
}

- (BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString *character = [event characters];
    unichar keyCode = [character characterAtIndex:0];
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoDown) {
		[_rectLayer selectNext];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoUp) {
		[_rectLayer selectPrevious];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoA) {
		switch (_rectLayer.selectedIndex) {
			case 0:
				[Settings sharedSettings].gameType = GamePracticeType;
				break;
			case 1:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIEasyType;
				break;
			case 2:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIMediumType;
				break;
			case 3:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIHardType;
				break;
			case 4:
				[Settings sharedSettings].gameType = GameSinglePlayerType;
				[Settings sharedSettings].aiType = AIInsaneType;
				break;
			case 5:
				[Settings sharedSettings].gameType = GameTwoPlayerType;
				break;
		}
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic]; 
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoB) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameTypeMenuLayer scene]]];
	}
	
	return YES;
}


@end
