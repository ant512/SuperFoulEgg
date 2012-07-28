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
	
	NSMutableArray *rectangles = [NSMutableArray array];
	
	for (int i = start; i <= end; i += step) {
		if (i == midPoint) {
			y -= height;
			x = (self.boundingBox.size.width - (width * (midPoint - start))) / 2;
		}
		
		[self addLabelWithString:[[NSNumber numberWithInt:i] stringValue] atX:x + (width / 2) y:y];
		[rectangles addObject:[NSValue valueWithRect:NSMakeRect(x, y - (height / 2), width, height)]];
		
		x += width;
	}
	
	[_rectLayer.rectangleGroups addObject:rectangles];
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
		
		[_rectLayer.selectedRectangleIndexes setObject:[NSNumber numberWithInt:[Settings sharedSettings].speed] atIndexedSubscript:0];
		[_rectLayer.selectedRectangleIndexes setObject:[NSNumber numberWithInt:[Settings sharedSettings].height] atIndexedSubscript:1];
		[_rectLayer.selectedRectangleIndexes setObject:[NSNumber numberWithInt:[Settings sharedSettings].blockColours - 4] atIndexedSubscript:2];
		[_rectLayer.selectedRectangleIndexes setObject:[NSNumber numberWithInt:([Settings sharedSettings].gamesPerMatch - 3) / 2] atIndexedSubscript:3];
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
		if ([_rectLayer selectBelowRectangle]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
		}
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoRight) {
		[_rectLayer selectNextRectangle];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoLeft) {
		[_rectLayer selectPreviousRectangle];
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoUp) {
		if ([_rectLayer selectAboveRectangle]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav"];
		}
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoA) {
		
		[Settings sharedSettings].speed = [_rectLayer selectedIndexInGroup:0];
		[Settings sharedSettings].height = [_rectLayer selectedIndexInGroup:1];
		[Settings sharedSettings].blockColours = [_rectLayer selectedIndexInGroup:2] + 4;
		[Settings sharedSettings].gamesPerMatch = ([_rectLayer selectedIndexInGroup:3] * 2) + 3;
		
		if (_rectLayer.selectedGroupIndex == 3) {
			[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
		} else {
			[_rectLayer selectNextGroup];
		}
	}
	
	if (keyCode == [Settings sharedSettings].keyCodeTwoB) {
		
		if (_rectLayer.selectedGroupIndex == 0) {
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameTypeMenuLayer scene]]];
		} else {
			[_rectLayer selectPreviousGroup];
		}
	}
	
	return YES;
}


@end
