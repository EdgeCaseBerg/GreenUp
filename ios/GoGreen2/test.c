#include "greenhttp.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
	char * request;
	char * request2;
	char * request3;
	char * returned_content1;
	char * returned_content2;
	char * returned_content3;

	request = gh_build_get_query("greenupapi.appspot.com","/api/comments");
	returned_content1 = gh_make_request(request,"greenupapi.appspot.com",_gh_get_ip("greenupapi.appspot.com"),80);
	printf("%s\n", returned_content1 );
	free(returned_content1);
	
	
	request2 = gh_build_post_query("greenupapi.appspot.com","api/comments", "{\"type\" : \"forum\", \"message\" : \"Have you guys heard about the free cookies on Pearl St and South Winooski? Bring your green bags down there and get one!\"}");
	returned_content2 = gh_make_request(request2,"greenupapi.appspot.com",_gh_get_ip("greenupapi.appspot.com"),80);
	printf("%s\n", returned_content2 );
	free(returned_content2);

	request3 = gh_build_put_query("greenupapi.appspot.com","api/heatmap","[{\"latDegrees\" : 24.53, \"lonDegrees\" : 43.2, \"secondsWorked\" : 120}]");
	returned_content3 = gh_make_request(request3,"greenupapi.appspot.com",_gh_get_ip("greenupapi.appspot.com"),80);
	printf("%s\n", returned_content3 );
	free(returned_content3);
	


	return 0;
}