#import "BlockSpriteConnector.h"

@implementation BlockSpriteConnector

@synthesize block = _block;
@synthesize sprite = _sprite;
@synthesize isDead = _isDead;

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

	// TODO: Remove magic numbers and calculate position within the window correctly.

	// Co-ords are adjusted so that the sprite is relative to the containing
	// grid
	int x = _block.grid.x + 100 + (_block.x * BLOCK_SIZE);
	int y = _block.grid.y + 200 - ((_block.y * BLOCK_SIZE) + _yOffset);

	// Add an extra half block's height if the block has fallen a half block
	y += _block.hasDroppedHalfBlock ? BLOCK_SIZE / 2 : 0;

	_sprite.position = ccp(x, y);
}

- (void)setSpriteFrame:(int)frame {
	[_sprite setTextureRect:CGRectMake((frame % 4) * BLOCK_SIZE, (frame / 4) * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)];
	_frame = frame;
}

- (void)update {

	switch (_block.state) {
		case BlockExplodingState:

			// The block is exploding.  We run through the frames of explosion
			// animation each time this method is called until we run out of
			// frames, whereupon we tell the block that it has finished
			// exploding.  The block's explosion stopped event will fire and
			// this object and its components will eventually be deallocated
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
			break;

		case BlockLandingState:

			// The block is landing.  We run through the animation until we run
			// out of frames.  At that point, the block is told that it is no
			// longer landing.
			++_timer;

			if (_timer == 14) {

				// Reached the end of the landing animation, so tell the block
				// it has finished landing
				[_block stopLanding];
			} else if (_timer % BLOCK_ANIMATION_SPEED == 0) {

				// List of landing animation frames
				static int landingSequence[7] = { 0, 22, 23, 22, 23, 22, 0 };

				// Move to the frame appropriate to the current timer
				[self setSpriteFrame:landingSequence[_timer / 2]];
			}
			break;
		
		case BlockRecoveringFromGarbageHitState:

			// Block has been hit by a garbage block from above and is being
			// eased back to its correct position.

			++_timer;

			if (_yOffset > 0) {

				// Block has been offset by a garbage block landing in its
				// column.  We need to slowly reduce the offset back to 0.
				if (_timer % 2 == 0) {

					--_yOffset;
					[self updateSpritePosition];
				}
			} else {
				// Block can switch back to its normal state as the
				// offset has been completely reduced
				[_block stopRecoveringFromGarbageHit];
			}

			break;

		default:

			// Block isn't doing anything interesting
			break;
	}
}

- (void)hitWithGarbage {
	_yOffset = GARBAGE_HIT_OFFSET;

	[_block startRecoveringFromGarbageHit];

	[self updateSpritePosition];
}

@end
