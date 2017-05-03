# Basic RP Gamemode

## Features

- SQL support with mysqloo(you need it for the gamemode to work)

- Jobs and paycheck

- NPCs(no dialog yet)

- Inventory system that's fully networked with the SQL database with grid GUI

- Vehicle system and car dealer once again networked with the SQL database

- Passenger seats in cars(Big thanks to Fexa for the awesome seats position tool he made)

- Property system, ownership and key SWEP

- Basic admin system with rank system and assmenu style admin menu

- Ban system networked with SQL

- Playtime tracking

- Sort of custom GUI

## Setup

1. Install [Mysqloo](https://facepunch.com/showthread.php?t=1220537)

2. Setup a mysql database and put the information in the sv_sql.lua file

3. Once in-game use the command *sql_createtable*

4. Restart your server. Your SQL server in now configured with all the tables.

## Debug commands

### SQL

- sql_createtable - Creates the rp tables
- sql_dropthetable - Drops all the rp tables

### Inventory

- rp_inventory - Open the grid inventory
- rp_seeinventory(_cl) - Prints the inventory table
- rp_sendinventory - Sends the serverside player inventory to the player
- rp_itempanel - Open a menu to spawn items
- rp_giveitem(_cl) #id #quantity - Give an item to the player
- rp_useitem #id - Use the item
- rp_clearslot(_cl) #slot - Clear the selected item slot
- rp_setitem(_cl) #slot #id #quantity - Sets the inventory slot with the item ID and Quantity
- rp_changeitemslot(_cl) - Moves an item from a slot to another
- rp_removeitem(_cl) #id #quantity - Removes an item from the player's inventory
- rp_clearslots - Removes every item from the inventory
- rp_slotisempty(_cl) #slot - Returns wether the slot is empty or not

### Player

- rp_actionmenu - Opens the action menu when facing a player or the admin menu if admin(Admin menu can be opened anywhere)
- rp_createprofile - Creates the profile of the player
- rp_loadprofile - Loads the profile of the player
- rp_saveprofile - Saves the profile of the player
- rp_givemoney #num - Gives the player money
- rp_setrank #rank - Sets the rank of the player(Rank 5 and over is considered admin)
- rp_getrank_sv(_cl) - Prints the rank of the player

### Vehicles

- rp_spawnvehicle #id - Spawns a vehicle from the global vehicle table
- rp_getinseat #id - Get in the passenger seat of the vehicle
- rp_sendvehicles - Send the player's vehicle table to the client
- rp_newcolor #id #color - Changes the color of the player's vehicle (Untested may not work)
- rp_getvehicles - Returns the player's vehicles
- rp_spawnpersonalvehicle #id - Spawns the player's vehicle from his table
- rp_clearvehicles_sv(_cl) - Clears the player's vehicle table
- rp_playerhasvehicle #id - Returns wether or not the player has the vehicle

### Properties

- rp_rentproperty #id - Rents the property
- rp_vacantproperty #id - Vacants the property
- rp_getdoor - Prints the doors information for the property system(Vector() and Model
- rp_getowner - Prints the current owner of the door

### Useful commands

- rp_getbench - Tool to place passenger seats
- rp_campos - Tool to change dmodel camera's position
- rp_camposcar - Same as campos but for vehicles
