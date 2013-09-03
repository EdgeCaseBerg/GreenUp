#!/bin/bash  

navbar_background_current="#009246"
navbar_icon_inactive_current="#004a24" 
navbar_icon_active_current="#a4c196"
comment_background_blue_current="#6fb9ec"
comment_background_orange_current="#fbc883"
comment_background_green_current="#7ccc83"
pinwheel_green1_current="#39b64a"
pinwheel_green2_current="#009246"
pinwheel_blue1_current="#00aef0"
pinwheel_blue2_current="#1875bd"
pinwheel_orange1_current="#fdba29"
pinwheel_orange2_current="#f26623"
pinwheel_red1_current="#b5212f"
pinwheel_red2_current="#ee1d26"

navbar_background_new="#000000"
navbar_icon_inactive_new="#004a24" 
navbar_icon_active_new="#a4c196"
comment_background_blue_new="#6fb9ec"
comment_background_orange_new="#fbc883"
comment_background_green_new="#7ccc83"
pinwheel_green1_new="#39b64a"
pinwheel_green2_new="#009246"
pinwheel_blue1_new="#00aef0"
pinwheel_blue2_new="#1875bd"
pinwheel_orange1_new="#fdba29"
pinwheel_orange2_new="#f26623"
pinwheel_red1_new="#b5212f"
pinwheel_red2_new="#ee1d26"

for file in *.svg;
do sed -i s/$navbar_background_current/$navbar_background_new/ $file;
done

