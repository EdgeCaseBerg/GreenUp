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
for z in `seq 1 9`
	do
		for i in `seq 1 9`
			do
				# echo "123"$i"456\n"
				curl -d '[
			    	{
			        	"latDegrees" : 44.481'$i'51'$z', 
			        	"lonDegrees" : -73.192'$z'7'$i'1, 
			        	"secondsWorked" : 4'$i'120, 
			        	"precision" : 6
			    	}
				]' $HMURL 2>&1
			done

		for i in `seq 1 9`
			do
				# echo "123"$i"456\n"
				curl -d '[
			    	{
			        	"latDegrees" : 44.481'$i''$z', 
			        	"lonDegrees" : -73.189'$i'17, 
			        	"secondsWorked" : 1'$i'120, 
			        	"precision" : 6
			    	}
				]' $HMURL 2>&1
			done

			for i in `seq 1 9`
			do
				# echo "123"$i"456\n"
				curl -d '[
			    	{
			        	"latDegrees" : 44.4811'$i', 
			        	"lonDegrees" : -73.181'$i$z'117, 
			        	"secondsWorked" : 1'$i'120, 
			        	"precision" : 6
			    	}
				]' $HMURL 2>&1
			done
	done
)


if [ "$result" == *"rror"* ]; 
	then
	echo "your request produced an error"
elif [ "$result" == *"404"* ];
	then
	echo "404"
elif [ "$result" == *"couldn"* ];
	then
	echo "couldn't connect to host"
elif [ "$result" == *"uccess"* ];
	then
	echo "Success"
else
	echo "Undetermined Error"
	echo "$result"
fi
