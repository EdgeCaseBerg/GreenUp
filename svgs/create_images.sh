#Generate files from assets
#Ethan Joachim Eldridge

#rsvg-convert installed for this to work.
#On debian systems: sudo apt-get install librsvg2-bin

#You also need to install imagemagick for the convert function to generate the mirrored images with flop

#values for dpi set according to http://developer.android.com/guide/practices/screens_support.html

#For xhdpi
rsvg-convert -o ../android/res/drawable-xhdpi/bottom_menu.png bottom_menu.svg --dpi-x 960 --dpi-y 720 -h 106
rsvg-convert -o ../android/res/drawable-xhdpi/comments.png comments.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/comments_active.png comments_active.svg  --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/map.png map.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/map_active.png map_active.svg  --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/home.png home.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/home_active.png home_active.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_blue_top.png bubble_blue_top.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_blue_center.png bubble_blue_center.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_blue_bottom.png bubble_blue_bottom.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_blue_bottom_reverse.png bubble_blue_bottom_reverse.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_green_top.png bubble_green_top.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_green_center.png bubble_green_center.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_green_bottom.png bubble_green_bottom.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_green_bottom_reverse.png bubble_green_bottom_reverse.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_yellow_top.png bubble_yellow_top.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_yellow_center.png bubble_yellow_center.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_yellow_bottom.png bubble_yellow_bottom.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/bubble_yellow_bottom_reverse.png bubble_yellow_bottom_reverse.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/top_bar.png top_bar.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/hamburger_icon.png hamburger_icon.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/start.png start.svg --dpi-x 960 --dpi-y 720
rsvg-convert -o ../android/res/drawable-xhdpi/stop.png stop.svg --dpi-x 960 --dpi-y 720

#For the hdpi: 
rsvg-convert -o ../android/res/drawable-hdpi/comments.png comments.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/comments_active.png comments_active.svg  --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bottom_menu.png bottom_menu.svg --dpi-x 640 --dpi-y 480 -h 106
rsvg-convert -o ../android/res/drawable-hdpi/map.png map.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/map_active.png map_active.svg  --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/home.png home.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/home_active.png home_active.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_blue_top.png bubble_blue_top.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_blue_center.png bubble_blue_center.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_blue_bottom.png bubble_blue_bottom.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_blue_bottom_reverse.png bubble_blue_bottom_reverse.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_green_top.png bubble_green_top.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_green_center.png bubble_green_center.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_green_bottom.png bubble_green_bottom.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_green_bottom_reverse.png bubble_green_bottom_reverse.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_yellow_top.png bubble_yellow_top.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_yellow_center.png bubble_yellow_center.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_yellow_bottom.png bubble_yellow_bottom.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/bubble_yellow_bottom_reverse.png bubble_yellow_bottom_reverse.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/top_bar.png top_bar.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/hamburger_icon.png hamburger_icon.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/start.png start.svg --dpi-x 640 --dpi-y 480
rsvg-convert -o ../android/res/drawable-hdpi/stop.png stop.svg --dpi-x 640 --dpi-y 480


#For the mdpi
rsvg-convert -o ../android/res/drawable-mdpi/comments.png comments.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/comments_active.png comments_active.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bottom_menu.png bottom_menu.svg -d 470 -p 320 -h 106
rsvg-convert -o ../android/res/drawable-mdpi/map.png map.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/map_active.png map_active.svg  -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/home.png home.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/home_active.png home_active.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_blue_top.png bubble_blue_top.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_blue_center.png bubble_blue_center.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_blue_bottom.png bubble_blue_bottom.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_blue_bottom_reverse.png bubble_blue_bottom_reverse.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_green_top.png bubble_green_top.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_green_center.png bubble_green_center.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_green_bottom.png bubble_green_bottom.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_green_bottom_reverse.png bubble_green_bottom_reverse.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_yellow_top.png bubble_yellow_top.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_yellow_center.png bubble_yellow_center.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_yellow_bottom.png bubble_yellow_bottom.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/bubble_yellow_bottom_reverse.png bubble_yellow_bottom_reverse.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/top_bar.png top_bar.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/hamburger_icon.png top_bar.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/start.png start.svg -d 470 -p 320
rsvg-convert -o ../android/res/drawable-mdpi/stop.png stop.svg -d 470 -p 320

#For the ldpi
rsvg-convert -o ../android/res/drawable-ldpi/comments.png comments.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/comments_active.png comments_active.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bottom_menu.png bottom_menu.svg -d 426 -p 320 -h 106
rsvg-convert -o ../android/res/drawable-ldpi/map.png map.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/map_active.png map_active.svg  -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/home.png home.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/home_active.png home_active.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_blue_top.png bubble_blue_top.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_blue_center.png bubble_blue_center.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_blue_bottom.png bubble_blue_bottom.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_blue_bottom_reverse.png bubble_blue_bottom_reverse.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_green_top.png bubble_green_top.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_green_center.png bubble_green_center.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_green_bottom.png bubble_green_bottom.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_green_bottom_reverse.png bubble_green_bottom_reverse.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_yellow_top.png bubble_yellow_top.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_yellow_center.png bubble_yellow_center.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_yellow_bottom.png bubble_yellow_bottom.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/bubble_yellow_bottom_reverse.png bubble_yellow_bottom_reverse.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/top_bar.png top_bar.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/hamburger_icon.png hamburger_icon.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/start.png start.svg -d 426 -p 320
rsvg-convert -o ../android/res/drawable-ldpi/stop.png stop.svg -d 426 -p 320


