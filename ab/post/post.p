# output as png image
set terminal png
 
# save file to "benchmark.png"
set output "benchmark.png"
 
# graph a title
set title "ab -k -n 5000 -c 100"
 
# nicer aspect ratio for image size
set size 1,0.7
 
# y-axis grid
set grid y
 
# x-axis label
set xlabel "request"
 
# y-axis label
set ylabel "response time (ms)"
 
# smooth sbezier lines
plot "putheatmap.txt" using 9 smooth sbezier with lines title "heatmap:", \
     "postcomments.txt" using 9 smooth sbezier with lines title "comments:", \
     "postmarkers.txt" using 9 smooth sbezier with lines title "pins:",\
     "postreport.txt" using 9 smooth sbezier with lines title "reports:"
