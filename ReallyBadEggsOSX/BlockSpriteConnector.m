#import "BlockSpriteConnector.h"

@implementation BlockSpriteConnector

@synthesize block = _block;
@synthesize sprite = _sprite;
@synthesize isDead = _isDead;
@synthesize yOffset = _yOffset;

- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite {
	if ((self = [super init])) {
		_block = [block retain];
		_sprite = [sprite retain];
		_isDead = NO;
		_timer = 0;
		_yOffset = 0;

		[self updateSpritePosition];
		[self setSpriteFrame:0];

		_block.onConnect = ^(BlockBase* block) {

			// Change the sprite's appearance to match the connections
			[self setSpriteFrame:block.connections];
		};

		_block.onMove = ^(BlockBase* block) {
			[self updateSpritePosition];
		};

		_block.onStopExploding = ^(BlockBase* block) {

			// Remove the sprite from its parent
			[_sprite.parent removeChild:_sprite cleanup:YES];
			
			[_sprite release];
			[_block release];

			_sprite = nil;
			_block = nil;

			_isDead = YES;
		};

		_block.onStartExploding = ^(BlockBase* block) {
			_timer = 0;

			[self setSpriteFrame:BLOCK_EXPLODE_START_FRAME];
		};

		_block.onStartLanding = ^(BlockBase* block) {
			_timer = 0;

			[self setSpriteFrame:BLOCK_LAND_START_FRAME];
		};

		_block.onStopLanding = ^(BlockBase* block) {
			// Don't care about this
		};

		_block.onStartFalling = ^(BlockBase* block) {
			// Don't care about this
		};
	}
	
	return self;
}

- (void)updateSpritePosition {

	// Move the sprite to match the block's position
	int extraY = _block.hasDroppedHalfBlock ? BLOCK_SIZE / 2 : 0;

	_sprite.position = ccp(_block.grid.x + 100 + (_block.x * BLOCK_SIZE), _block.grid.y + 200 - ((_block.y * BLOCK_SIZE) + extraY));
}

- (void)setSpriteFrame:(int)frame {
	[_sprite setTextureRect:CGRectMake((frame % 4) * BLOCK_SIZE, (frame / 4) * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)];
	_frame = frame;
}

- (void)update {
	if (_block.isExploding) {
		++_timer;

		if (_timer % BLOCK_ANIMATION_SPEED == 0) {

			if (_frame == BLOCK_EXPLODE_START_FRAME + BLOCK_EXPLODE_FRAME_COUNT - 1) {

				// Reached the end of the explosion frames
				[_block stopExploding];
			} else {

				// Move to the next explosion frame
				[self setSpriteFrame:_frame + 1];
			}
		}

	} else if (_block.isLanding) {
		++_timer;

		if (_timer == 14) {

			// Reached the end of the landing animation, so tell the block it
			// has finished landing
			[_block stopLanding];
		} else if (_timer % BLOCK_ANIMATION_SPEED == 0) {

			// List of landing animation frames
			static int landingSequence[7] = { 0, 22, 23, 22, 23, 22, 0 };

			// Move to the frame appropriate to the current timer
			[self setSpriteFrame:landingSequence[_timer / 2]];
		}
	}
}

@end
