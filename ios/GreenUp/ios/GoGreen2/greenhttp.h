/*Author(s) Ethan J. Eldridge
 *
 *Green HTTP Lib. Simple library to make PUT, POST, and GET requests. Designed
 *To be simple, lightweight, and used by the Green Up Vermont application ios
 *client as an alternative to other libraries.
*/


/*Rather simple to use, call one of the build_VERB_queries to create the request
 *itself and then pass the request along with the identifying information to the
 *make request function. You'll get the response back in a string.
 *
 *  ====IMPORTANT====
 *Please remember to free the pointer returned by gh_make_request
*/

#ifndef __LIB_GREEN_HTTP__
#define __LIB_GREEN_HTTP__

/* Defines prefixed by gh for green-http to avoid namespace conflicts */
#define GH_HOST ""
#define GH_USERAGENT "GreenUpVT App 0.1"
#define GH_START_BUFF_SIZE 4
/* Primary methods to be called: */

 /*Make a Raw http request to the port
 *General flow should be: build_VERB_query
 *Send resulting request.
 *
 *request The raw string http request to send
 *port    The port to send the information out on
 *Note that you are responsible for free-ing the returned char *, it uses malloc
*/
char * gh_make_request(char * request, char * host, int port);

/*Builds a GET request for the host/page. No need to put a leading /
 *It will just be removed anyway. Include any ? params in the page
*/
char * gh_build_get_query(char *host, char *page);

/*Builds a POST request for host/page and sends the payload along.
 *Note it's a raw payload so you'll have to encode it yourself into form data or
 *what have you. Its good to send raw json though!
*/
char * gh_build_post_query(char *host, char*page, char*payload);

/*Builds a PUT request for host/page and sends payload along.
 *It is a raw payload so be sure to encode it properly for form data, but you 
 *can send raw json easily enough with it.
*/
char * gh_build_put_query(char *host, char*page, char*payload);


/* "private" inner library functions */
int _gh_create_tcp_socket();
char *_gh_get_ip(char *host);

#endif