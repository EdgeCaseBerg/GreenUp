#!/bin/bash

for i in {1..9}
	do
		# echo "123"$i"456\n"
		echo "\n"
		curl -d '[
	    	{
	        	"latDegrees" : 44.'$i'519, 
	        	"lonDegrees" : -73.'$i'817, 
	        	"secondsWorked" : 120, 
	        	"precision" : 4
	    	}
		]' http://localhost:30002/api/heatmap 
	done

echo "\n"