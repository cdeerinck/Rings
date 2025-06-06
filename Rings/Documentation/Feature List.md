#  Feature list

Need to print
- Add ability to print marked up map *** Done via ShareLink in MapView, doesn't actually print
- Add ability to only print the currently viewed region of the marked up map
- Add option for overLay to be in any corner, user drags on Map screen to move it

Add Async to render
- Add progress bar on screen (only while rendering)
- Add cancel button on screen (only while rendering)
- Can we show the map while we are rending?  (only if it isn't slower)

Need better settings management
- Add ability to load/save the settings between runs (currently they are hard-coded on start)  [use @AppStorage ?]
- Add ability to load/save landables between runs (the Sectional is included in them)

Handle multiple Sectionals
- Add ability to choose which Sectional from a drop down list
    Structs created
- Load Sectional from the web, rather than keeping it as an Asset, but keep it local (don't re-download each use)
- Create option to remove all cached sectionals
- Keep track of sectional date (they are valid for only so long)
- Auto-clean up expired sectionals
- Only use landables for the selected Sectional
- Rework Lambert to use values in file, rather than hard coded

Localization Support (Hold off on all of this) https://medium.com/simform-engineering/localize-your-apps-to-support-multiple-languages-ios-localization-in-swiftui-c72d891a3e9
- Move hard-coded values
- Add setting for units (feet vs. meters)
- Add multi-language options (German, Italian, French, ?)  Can use Google translate to get values

Add winds support
- Add ability to set wind speed/direction.  This makes all circles become ellipses.

Add option for "Altitude Needed" insead of "How risky"
- Add legend to the map
- Add ability to select legends
- Add ability to create a custom legend
- Add legends to load/save data
- Add elevation topology

Fix Lambert projection calculations

Add ability to load landout points

Add option to support terrain

