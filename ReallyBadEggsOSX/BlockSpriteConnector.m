#import "BlockSpriteConnector.h"

@implementation BlockSpriteConnector

@synthesize block = _block;
@synthesize sprite = _sprite;
@synthesize isDead = _isDead;

- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite {
	_block = block;
	_sprite = sprite;
	_isDead = NO;

	_block.onConnect = ^(BlockBase* block) {

		// Change the sprite's appearance to match the connections
		[_sprite setTextureRect:CGRectMake((block.connections % 4) * BLOCK_SIZE, (block.connections / 4) * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)];
	};

	_block.onMove = ^(BlockBase* block) {

		// Move the sprite to match the block's position
		int extraY = block.hasDroppedHalfBlock ? BLOCK_SIZE / 2 : 0;

		_sprite.position = ccp(block.grid.x + 100 + (block.x * BLOCK_SIZE), block.grid.y + 200 - ((block.y * BLOCK_SIZE) + extraY));
	};

	_block.onDealloc = ^(BlockBase* block) {

		// Remove the sprite from its parent
		[_sprite.parent removeChild:_sprite cleanup:YES];
		_isDead = YES;
	};

	_block.onExplode = ^(BlockBase* block) {
	};

	_block.onLand = ^(BlockBase* block) {
	};

	_block.onFall = ^(BlockBase* block) {
	};
}

- (void)update {

}

@end
