# Prop Chooser
## An Automated Prop List, which you can choose whenever you want!

## About

Simple addons for Prop Hunt: Enhanced which allows you to choose any props from a map whenever you want!  
Current Version: **1.2**

Fixes on 1.2:
- Removed some uneeded net Messages
- Added delay to prevent Model-Changing Spam
- Limit can be checked both in client and server-side
- Added CVars
- Other Improvements

### How it Works

*Please note: currently this addon may only works & supported for Prop Hunt: Enhanced.*

Map Props will be scanned and added during gamemode initialisation. They will soon be added into a list (Proccessed in serverside) and transfered to client side.  
Each time when player joins, the prop list will be available to them.  
The Prop Chooser list window will only appear when you are on Prop Team by simply pressing F8 key by default.

By default, Prop team have 3x chances to choose and change the prop whenever they can. (It can be unlimited based settings!) - Make sure you have a some plenty-open room choose other props, 
and stay on the ground and not crouching as well.

### What Can't
- Assign random/custom prop from a player/client ( this will provided from Server only! )
- Add custom prop from player

This is perfect condition whenever you were feel attacked / found by selecting any props you like to change and... Taadaaa...! hunters will be confused 😉

*Please note: This addon is a Server-sided Feature. It's not meant to be available for client-side!*

### How to Contribute or Support?

Feel free to open a pull request in this repository, if you have any (better) suggestions!  
I worked this nearly about 6 hours, pretty quickly because just wanted to make one. If you have a moment, feel free to contribute by supporting too!

Support on Ko-fi: https://ko-fi.com/wolvyrra/  
Support on Official Website: https://www.wolvindra.net/donate/  
Twitter: https://twitter.com/vinzuerio  (*Questions only!*)

### How's about Customisation and/or configurations?

#### Console Variable & Configurations
- pcr_enable : Enable/Disable this Feature.
- pcr_allow_custom : Allow custom prop models to be added outside from the map's props.
- pcr_enable_prop_ban : Enable Prop Banning. This will also includes the ban list from PH:E Prop Bans list too.
- pcr_max_enable : Enable/Disable Limit the maximum of addition to the Prop Chooser.
- pcr_max_prop_list : Maximum number of Limit to be added to the Prop Chooser. Default is 100.
- pcr_max_use : Maximum Usage after Props chosen their Prop. Default is 3.
- pcr_default_key_menu : Default Key to open up a menu. Default is KEY_F8 (Value: 9). To change/bind to other keys, please see here: https://wiki.garrysmod.com/page/Enums/BUTTON_CODE
- pcr_enable_bbox_limit : Enable/Disable Prop's Bounding Box (AABB)/Hull Size Limit. Purpose is to prevent using any larger objects which might be unexpected.
- pcr_bbox_max_height : Entity Max Height of Bounding Box (AABB)/Hull Size. Default is 96, 72 (Standard Kleiner model).
- pcr_bbox_max_width : Entity Max Width of Bounding Box (AABB)/Hull Size. Default is 72, 56, or 48.

#### New ConVars:
- pcr_kick_invalid : Kick any user attempt to access invalid model that does not exists in current map/custom list with threshold 4x max attempts.
- pcr_delay_use : Delay, in seconds before player able to use Prop Chooser in next N seconds. (default is 2) - This prevent spamming issues.

#### How to Add Custom Props & Adding Prop Bans?

Simply, navigate to your Root Garry's Mod game data folder, e.g: "../garrysmod/data/phe_config/" - You'll see two folder called:
- A folder "prop_chooser_custom" containing "models.txt", which will be used to add new Props Model; and
- A folder "prop_model_bans" containing "model_bans.txt" and "pcr_bans.txt" which will be used to add Prop Bans model.
- Make sure these files & folders are Writeable!

Each data will contains something like this:

```json
[
	"models/something.mdl",
	"models/anothermodels.mdl",
	"models/any/other/paths/here.mdl"
]
```

#### But, How do I get model listed after it being added?
Currently there is a console command to debug & list which models has been added to the Prop Chooser list: "pcr_debug_model_list".  
This command will prints All available models listed which specified from the maps, and can be accessed only by Admin/Superadmin.

### I got Errors!
Please open up an issue on Issue tracker if you have anything with Error and other issues related. Please NOTE that:
- This Addon currently only works with Prop Hunt: Enhanced gamemode. There are currently support for Classic version yet!
- Currently do not support with ULX integration yet. 
- If you wanted this version compatible with other prop hunt version / addon integration, consider contact via DM on Twitter: https://twitter.com/Vinzuerio