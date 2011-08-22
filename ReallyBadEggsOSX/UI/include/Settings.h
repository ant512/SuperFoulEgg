#import <Foundation/Foundation.h>

typedef enum {
	AIEasyType = 0,
	AIMediumType = 1,
	AIHardType = 2
} AIType;

typedef enum {
	GamePracticeType = 0,
	GameSinglePlayerType = 1
} GameType;

@interface Settings {
	AIType _aiType;
	GameType _gameType;
	int _height;
	int _speed;
	BOOL _isDropManual;
}

@property(readwrite) AIType aiType;
@property(readwrite) GameType gameType;
@property(readwrite) int height;
@property(readwrite) int speed;
@property(readwrite) BOOL isDropManual;

+ (Settings*)sharedSettings;
- (id)init;

@end
