#  TFW Information

Los Angeles SEC.tfw
42.3350312379
0.0000000000
0.0000000000
-42.3359715248
-350999.2901801879
277717.8196927544

Anchorage SEC.tfw
42.3349388890
0.0000000000
0.0000000000
-42.3364468631
-365713.6560533495
240127.6757701858

San Francisco SEC.tfw
42.3366006779
0.0000000000
0.0000000000
-42.3371681488
-384300.5425231989
256233.4262048799

Details from: https://en.wikipedia.org/wiki/World_file

Line 1: A: Pixel size in the x-direction in the map units/pixel
Line 2: D: Rotation about y-axis
Line 3: B: Rotation about x-axis
Line 4: E: pixel size in the y-directin in map units, almost always negative
Line 5: C: x-coordinate of the center of the upper left pixel
Line 6: F: y-coordinate of the center of the upper left pixel

To go from pixel position (x,y) to UTM(x'y') use
    x' = Ax + By + C
    y' = Dx + Ey + F
To go from UTM(x'y') to pixel position (x,y) use
    x = (Ex' - By' + BF - EC) / (AE - DB)
    y = (-Dx' + Ay' + DC - AF) / (AE - DB)
    
x' is the calculated UTM easting of the pixel on the map
y' is the calculated UTM northing of the pixel on the map
x is the column number of the pixel in the image counting from left
y is the row number of the pixel in the image counting from top
All in meters per pixel
