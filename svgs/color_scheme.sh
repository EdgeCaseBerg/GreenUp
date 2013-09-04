#!/bin/bash  
# navbar_background_current
color[0]="#009246"
# navbar_icon_inactive_current
color[1]="#004a24" 
# navbar_icon_active_current
color[2]="#a4c196"
# comment_background_blue_current
color[3]="#6fb9ec"
# comment_background_orange_current
color[4]="#fbc883"
# comment_background_green_current
color[5]="#7ccc83"
# pinwheel_green1_current
color[6]="#39b64a"
# pinwheel_green2_current
color[7]="#009246"
# pinwheel_blue1_current
color[9]="#00aef0"
# pinwheel_blue2_current
color[10]="#1875bd"
# pinwheel_orange1_current
color[11]="#fdba29"
# pinwheel_orange2_current
color[12]="#f26623"
# pinwheel_red1_current
color[13]="#b5212f"

# pinwheel_red2_current
color[14]="#ee1d26"
# navbar_background_new
color[15]="#009246"
# navbar_icon_inactive_new
color[16]="#004a24" 
# navbar_icon_active_new
color[17]="#a4c196"
# comment_background_blue_new
color[18]="#6fb9ec"
# comment_background_orange_new
color[19]="#fbc883"
# comment_background_green_new
color[20]="#7ccc83"
# pinwheel_green1_new
color[21]="#39b64a"
# pinwheel_green2_new
color[22]="#009246"
# pinwheel_blue1_new
color[23]="#00aef0"
# pinwheel_blue2_new
color[24]="#1875bd"
# pinwheel_orange1_new
color[25]="#fdba29"
# pinwheel_orange2_new
color[26]="#f26623"
# pinwheel_red1_new
color[27]="#b5212f"
# pinwheel_red2_new
color[28]="#ee1d26"

do echo date\n > color_history.txt
for col in $color
	do echo $col\n > color_history.txt

do echo \n\n > color_history.txt

for file in *.svg;
	do sed -i s/$navbar_background_current/$navbar_background_new/ $file;
done

