#!/bin/bash
# HMURL=honda
if [ -z $1 ]
	then
		HMURL="http://localhost:30002/api/heatmap"
	else
		HMURL="$1"
	fi
# echo $HMURL

echo "working..."
result=$(
for z in {1..9}
	do
		for i in {1..9}
			do
				# echo "123"$i"456\n"
				curl -d '[
			    	{
			        	"latDegrees" : 44.4'$i'51, 
			        	"lonDegrees" : -73.2'$z'7'$i', 
			        	"secondsWorked" : 4'$i'120, 
			        	"precision" : 4
			    	}
				]' $HMURL 2>&1
			done

		for i in {9..1}
			do
				# echo "123"$i"456\n"
				curl -d '[
			    	{
			        	"latDegrees" : 44.4'$z'1'$i', 
			        	"lonDegrees" : -72.89'$i'17, 
			        	"secondsWorked" : 1'$i'120, 
			        	"precision" : 4
			    	}
				]' $HMURL 2>&1
			done
	done
)


if [[ "$result" == *"rror"* ]]; 
	then
	echo "your request produced an error"
elif [[ "$result" == *"404"* ]];
	then
	echo "404"
elif [[ "$result" == *"couldn"* ]];
	then
	echo "couldn't connect to host"
elif [[ "$result" == *"uccess"* ]];
	then
	echo "Success"
else
	echo "Undetermined Error"
fi