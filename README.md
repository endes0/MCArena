# MCArena
A kit PvP plugin for MCServer (In Beta)

A plugin for MCServer that adds arena-like functionality.
Currently in heavy development and beta state, this plugin is NOT recommended for non-dedicated use.
Player inventories are NOT saved between arena matches.  Take this into consideration before installing.

#CREATING AN ARENA
Use the golden pickaxe to edit your arenas.
Left Click = First position
Right Click = Second position
Shift+Click = Spectator teleport position

This is almost exactly the same as WorldEdit.
The defined cuboid will be the area of the arena.

Afterwards, do:
* /mca create <NAME>

The arena will automatically set itself up.

Use the following to join the arena
* /mca join <KIT NAME>

You must also be an Admin or have the mcarena.create permission to create these arenas.

Have fun.  :)

#NOW INCLUDES KITS
To make a new kit, edit kits.ini

Add a key entry.  This will become the kit name.

Under the key name, add item tags like:

* item1 = <some item>
* item2 = <another item>

Each item MUST have an amount specifier.  This is correct:

* item1 = 137
* amount1 = 16

This gives 16 command blocks on arena entry.

Example kit =

*item1=261
*amount1=1
*item2=262
*amount2=64
