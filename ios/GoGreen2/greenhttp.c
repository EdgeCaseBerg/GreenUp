#ifndef __LIB_GREEN_HTTP_
	#include "greenhttp.h"
	#include <stdio.h>
	#include <sys/socket.h>
	#include <arpa/inet.h>
	#include <stdlib.h>
	#include <netdb.h>
	#include <string.h>
    #include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>


#endif

/*Make a Raw http request to the port
 *General flow should be: build_VERB_query
 *Send resulting request.
 *
 *request The raw string http request to send
 *port    The port to send the information out on
*/
char * gh_make_request(char * request, char * host, char * str_ip, int port) {
	struct sockaddr_in *remote;
  	int sock;
  	int tmpres;
  	char buf[BUFSIZ+1];  /*BUFSIZ comes from stdio.h*/
    int sent;
    int htmlstart;
    char * htmlcontent;
    int htmlBufsUsed;
    int htmlBufsNeeded; 
    int freeTheDamnIndirectionPoiner;
    char * htmlBuf = malloc((BUFSIZ*GH_START_BUFF_SIZE+1)*sizeof(char));
    char * indirectionBufferPointer;

  	sock = _gh_create_tcp_socket();

  	/* fprintf(stderr, "IP is %s\n", ip); */
  	remote = (struct sockaddr_in *)malloc(sizeof(struct sockaddr_in *));
  	remote->sin_family = AF_INET;
  	tmpres = inet_pton(AF_INET, str_ip, (void *)(&(remote->sin_addr.s_addr)));
  	if( tmpres < 0)   {
    	perror("Can't set remote->sin_addr.s_addr");
    	return "PROBLEM";
  	} else if(tmpres == 0) {
    	/* fprintf(stderr, "%s is not a valid IP address\n", ip); */
    	return "PROBLEM";
  	}
  	remote->sin_port = htons(port);
 
  	if(connect(sock, (struct sockaddr *)remote, sizeof(struct sockaddr)) < 0){
	    perror("Could not connect");
	    return "PROBLEM";
  	}
 
  	/*Send the query to the server*/
    sent = 0;
  	while(sent < strlen(request)) {
    	tmpres = send(sock, request+sent, strlen(request)-sent, 0);
        
        //fprintf(stderr, "%s\n", request+sent);
        
    	if(tmpres == -1){
    	  	perror("Can't send query");
	      	return "PROBLEM";
	    }
	    sent += tmpres;
  	}
  	/*now it is time to receive the page*/
  	memset(buf, 0, sizeof(buf));

    htmlBufsNeeded = GH_START_BUFF_SIZE;
    htmlBuf[0] = '\0';
    htmlstart = htmlBufsUsed = freeTheDamnIndirectionPoiner = 0;
  	while((tmpres = recv(sock, buf, BUFSIZ, 0)) > 0){
	    if(htmlstart == 0) {
       	/* Under certain conditions this will not work.
      	* If the \r\n\r\n part is splitted into two messages
      	* it will fail to detect the beginning of HTML content
      	*/
      	htmlcontent = strstr(buf, "\r\n\r\n");
      	if(htmlcontent != NULL){
	        htmlstart = 1;
            htmlBufsUsed++;
        	htmlcontent += 4;
      	}
    	}else{
      		htmlcontent = buf;
    	}
    	if(htmlstart){
            if( htmlBufsUsed < htmlBufsNeeded){
                strcat(htmlBuf,htmlcontent);
            }else{
                /*Grow buffer first*/
                indirectionBufferPointer = realloc(htmlBuf, strlen(htmlBuf) + strlen(buf) + sizeof(char));
                if(!indirectionBufferPointer)
                    fprintf(stderr,"bad pointer\n");
                else{
                    freeTheDamnIndirectionPoiner = 1;
                    htmlBuf = indirectionBufferPointer;
                    htmlBufsNeeded = htmlBufsNeeded*2;
                    strcat(htmlBuf,htmlcontent);
                }
            }
    	}
    	memset(buf, 0, tmpres);
  	}
  	if(tmpres < 0) {
    	perror("Error receiving data");
  	}
  	free(request);
  	free(remote);
  	close(sock);
	return htmlBuf;
}

/*Builds a GET request for the host/page. No need to put a leading /
 *It will just be removed anyway. Include any ? params in the page
*/
char *gh_build_get_query(char *host, char *page) {
	char *query;
  	char *getpage = page;
  	char *headers = "GET /%s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nConnection: close\r\n\r\n";
  	if(getpage[0] == '/') {
	    getpage = getpage + 1; /*Pointer arith to move base up one*/
	    /* fprintf(stderr,"Removing leading \"/\", converting %s to %s\n", page, getpage); */
  	} 
  	/* -5 is to consider the %s %s %s in headers and the ending \0 */
  	query = (char *)malloc(strlen(host)+strlen(getpage)+strlen(GH_USERAGENT)+strlen(headers)-5);
  	sprintf(query, headers, getpage, host, GH_USERAGENT);
  	return query;
}

/*Builds a POST request for host/page and sends the payload along.
 *Note it's a raw payload so you'll have to encode it yourself into form data or
 *what have you. Its good to send raw json though!
*/
char *gh_build_post_query(char *host, char*page, char*payload) {
	char *tpl = "POST /%s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nConnection: close\r\nContent-Length: %d\r\n\r\n%s";
  	char *query;
  	char *getpage = page;
  	if(getpage[0] == '/') {
	    getpage = getpage + 1;
	    /* fprintf(stderr,"Removing leading \"/\", converting %s to %s\n", page, getpage); */
  	}

  	/* -6 is to consider the %s %s %s %s in tpl and the ending \0 */
  	query = (char *)malloc(strlen(host)+strlen(getpage)+strlen(GH_USERAGENT)+strlen(payload)+strlen(tpl)-6);
  	sprintf(query, tpl, getpage, host, GH_USERAGENT, strlen(payload),payload);
  	return query;
}

/*Builds a PUT request for host/page and sends payload along.
 *It is a raw payload so be sure to encode it properly for form data, but you 
 *can send raw json easily enough with it.
*/
char *gh_build_put_query(char *host, char*page, char*payload) {
	char *tpl = "PUT /%s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nConnection: close\r\nContent-Length: %d\r\n\r\n%s";
  	char *query;
  	char *getpage = page;
  	if(getpage[0] == '/') {
	    getpage = getpage + 1;
	    /* fprintf(stderr,"Removing leading \"/\", converting %s to %s\n", page, getpage); */
  	}

  	/* -6 is to consider the %s %s %s %s in tpl and the ending \0 */
  	query = (char *)malloc(strlen(host)+strlen(getpage)+strlen(GH_USERAGENT)+strlen(payload)+strlen(tpl)-6);
  	sprintf(query, tpl, getpage, host, GH_USERAGENT, strlen(payload),payload);
  	return query;
}

/*Creates a tcp socket. Nothing special here...
*/
int _gh_create_tcp_socket() {
  int sock;
  if((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
    perror("Can't create TCP socket");
    return -1;
  }
  return sock;
}

/*Determines the ip of the host. 
 *If you know the ip already, you don't need to use this. But chances are
 *you don't know it, so here you go. A function to do it for ya.
*/
char *_gh_get_ip(char *host) {
    struct addrinfo hints, *res;
    struct in_addr addr;
    char * ip;
    int err;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;

    printf("%d\n", EAI_SYSTEM);

    if ((err = getaddrinfo(host, NULL, &hints, &res)) != 0) {
        fprintf(stderr,"error %d\n", err);
        gai_strerror(err);
        return "PROBLEM";
    }

    addr.s_addr = ((struct sockaddr_in *)(res->ai_addr))->sin_addr.s_addr;

    ip = inet_ntoa(addr);
    freeaddrinfo(res);

    return ip;
}

