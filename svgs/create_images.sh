#Generate files from assets
#Ethan Joachim Eldridge

#rsvg-convert installed for this to work.
#On debian systems: sudo apt-get install librsvg2-bin

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





