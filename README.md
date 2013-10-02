#Tf2 server cookbook
##Author: Philippe Gaultier
###Purpose
Create a vm running a Half-Life Dedicated Server (here TF2 server), with etf2l configuration.
###TODO
Create a role containing the 2 following recipes:

- apt
- hlds

###Use:
-Upload the cookbook on your chef server
>`knife cookbook upload hlds`

-Create a vm with this cookbook
>`knife openstack create server ... -r 'recipe[apt],recipe[hlds]' -f flavor_id`

The apt recipe needs to be executed in order to update the apt packages.

Make sure you have a flavor with enough storage ( ~ 10 Gb, 15 Gb if you want to add mods/maps). At the moment the whole game directory takes 7.5 Gb, but the game is weekly/monthly  updated, and new files are often added.

###Details
- The server self-updates, whenever the game is updated.

- The port 27015 is used by the game server to send/receive informations from the clients (be sure it's open)

- The port 27005 is used to send SourceTV , in case of tournaments (be sure it's open in this case)

- Libc6:i386 is needed to run the server (the cookbook automatically downloads this package).

- If the server crashes, it automatically restarts and writes the problem in the log file.
- More infos: 
    - Official TF2 wiki :
 
    `http://wiki.teamfortress.com/wiki/Servers`
	
    - Valve support: 
    
    `https://support.steampowered.com/kb_cat.php?s=a9ffd147c7c72e68436ea3db26e555ef&id=77`

    - Valve developer wiki: 
    
    `https://developer.valvesoftware.com/wiki/Source_Multiplayer_Networking`
