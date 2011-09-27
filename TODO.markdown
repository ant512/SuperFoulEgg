To do
=====

 * Menu system with options:
 ** Height;
 ** Speed;
 ** Easy/medium/hard AI;
 ** Practice/vs AI game;
 ** 4/5/6 block colours;
 ** Best of 3/5/7;
 ** Redefine keys.

 * Add Simian Zombie logo as splash screen.
 * Add title screen.
 * Title screen music - MP3 seems to be the way to go.


Programming
-----------

* Simian Zombie logo screen
* Title screen
* Menu screen


Graphics
--------

Eggs have 24 frames of animation, each of which is 16x16 pixels.  Proposed
redesign would have the same frames of animation but 48x48 pixels in size.  The
graphics need to be 16-bit as 32-bit graphics have a hugely negative effect on
the frame rate.  The 16 bits are divided into 4 bits each for the alpha channel
and red, green and blue components.

Needed graphics are:

* Title screen
* Options screen background (and possibly icons)
* Game background
* Eggs (6 colours, 24 frames each)
* Grey "garbage" eggs (1 frame for standard appearance, 6 frames for the
  explosion effect)
* "Winner!" graphic
* "Paused" graphic
* 3 icons representing incoming garbage quantities
* Left, right and centre blocks for the bottom row of the grid
* Program icon


Sounds
------

Sounds from DS version will need to be replaced with something else.