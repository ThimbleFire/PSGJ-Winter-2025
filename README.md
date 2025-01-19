this is my repo for my piratesoftware 2025 winter gamejam game. this readme will serve as my development diary.

# 16/1/2025 @ 11:30pm in London

I'm at work thinking of what to build. i don't know what the theme is yet.
I'd like to record my development live and submit it to YouTube as evidence of not using existing material, though i also doubt anyone will take interest as there's some 35K other participants. 
I'm thinking I'll stick to my strengths and make a short isometric rpg. I'll have a simple inventory system as i recognise i tend to spend multiple weeks on ui systems.
I'll have a black and white retro theme. I'll try to recreate my jigsaw dungeon algorithm from memory, map gen alone might take multiple days but if i can pull it off it'll be worth it,  I've gotten pretty familiar with godot, realistically it shouldn't take more than 12 hours. 
Since I'm working full time I'll only be about to work on the game 6-7 hours a day. 

* I'll start my modelling sand animating the player and writing a python script to render its frames into a 2D sprite sheet.
* I'll create jigsaw pieces each with their own json files that contain map data. the json file contains information about the size of each piece and the locations and sizes of its entrances.
* I'll get the player moving around. I've been playing a ton of poe2 lately and i want to try implementing wsad movement. not sure on this right now though, might have to be point-and-click like diablo 2. if i decide to go point and click I'll need to first write a pathfinding algorithm as i'm not a fan of godot's built in pathfinder. 
* once the player is moving around and the map is generating i can put in a basic inventory and character window. I'll have equipment show up on the player in-game.
* once they're equipping gear i can add some basic melee attack.
* I'll have a ui to determine left and right+click behaviour
* I'll have the player pick between a mage and a warrior which changes their starting item.
* I'll have mobs spawn in rooms. their design will be determined by the theme of the project, but for now let's say they're zombies.

* I'll add health to everything and see how that feels, then start fleshing out the game as much as i can with the time constraints.

# 17/1/2025 @ 1:09am

Game jam starts in 13 hours. I asked a mate if he'd be up for doing music for the game and he said maybe. I explained the theme and he thinks the scope is too big so, might have to dial back a few things like affixes, instead opting for unique behaviours for items. One such behaviour he suggested was doubling damage but attacking / firing projectiles to the sides. I agree such behaviour is more memorable than simply _+2 to range damage_.
We're in agreement on no turn based combat.
I should review my old map gen code written in c#. Will need to recreate it in gdscript. I'd like to say it won't be a problem but whereas before jigsaw pieces were saved as prefabs, I'll be saving them as json. I'll create pieces of the map in Tiled, save them, and modify the exported file to include exits. Something like this:

```
{
  Width: 9,
  Height: 7,
  Data = [ 1, 1, 1, 0, 0, 0, 1, 1, 1,
           1, 0, 0, 0, 0, 0, 0, 0, 1,
           1, 0, 0, 0, 0, 0, 0, 0, 1,
           1, 0, 0, 0, 0, 0, 0, 0, 1,
           1, 0, 0, 0, 0, 0, 0, 0, 0,
           1, 0, 0, 0, 0, 0, 0, 0, 1,
           1, 1, 1, 1, 1, 1, 1, 1, 1 ],
Doorways = [ { 3, 0, 0, 3 }, {4, 4, 1, 1 } ]
}
```

I think the original captured whether the entrances were horizontal or vertical, and the width or height of those entrance. But they didn't capture the location. This meant that doorways were always aligned with the cener in one of the two axis. In this game I'd like to also capture location. So doorway includes `{ x, y, axis, doorway_width_or_height }` where axis is 0 for horizonatal and 1 for vertical.

So lets say we've 50 variations of the above. We select the `start.json` that acts as our hub. Think of it like the rogue encampment town in the first act of Diablo 2. `start` has an exit in a random direction. We then branch out from there, selecting a random variation with a suitable connecting exit. So if town exit leads left we want a room with an exit that leads right. 
It should include one exit in all other directions. We add those exits to a list of doorways that need to be branched out from - but until then, we'll create ghost rooms. Ghost rooms are placeholders that prevent us from placing rooms that overlap with where a room will be placed later. Ghost rooms are 5x5 - the minimal size a room can be. If there's no enough space to place a 5x5 room the chosen variation should be discarded. This is a bit complicated.

We can use a sql database to store our pieces so we can quickly find which piece is suitable for us to place, it'll save us from loop-loading up random json files until we find a compatible piece.

**NOTE: Check whether the sql extension works in the browser release**.
Because I can't be bothered to manually write out all the rooms in the database I'll just write each .json file to the database at the start of runtime.

# 17/1/2025 @ 1:44am

How are we going to handle item behaviour?

I guess when we equip an item it'll subscribe to the behaviour which triggers its own behaviour.
Not sure that'll work for changing controls. Maybe attack / projectile direction will be repesented by a value and that value will be offset by the item. Oh. Yeah that works. Like on equip you invert a value and invert it again on re-equip. That way you could have a second item that counters the invert so you essentially get all the benefit without the negative. Yeah idk, we'll see. Kind of irrelevent right now.

# 18/1/2025 @ 3:37am

Pretty bad start to day 1. Sorta went in circles all afternoon trying to get some old code working. It's frustrating, I seem to write my best code while I'm not at home.
Since my old room data is written in XML I'm gonna try re-use them.

# 19/1/2025

day 2 went much better, generating a maze. should be able to do larger rooms but for testing purposes all rooms are 7x7 atm.
There's a lot of areas I'd like to improve the map generator in but I don't think I have the time. I anticipate it taking the better part of a day to model and animate the ai-player-not-player and a variety of aggressive mobs. plus I've still got to implement pathfinding.

so I'll spend a couple hours building a few interesting keystones then I'll start modelling and animating. 

I'm concerned the combat will be underwhelming, it's not something I put a lot of time into.
I guess I can make the ai extremely weak, and basically the sword (the player) fires projectiles at mobs before the ai reaches them. so it fires projectiles on lmb, shields from projectiles on rmb.

once modelling and animation is done I'd like to have a cutscene where the ai picks up the sword and the sword (the player) speaks to the ai.