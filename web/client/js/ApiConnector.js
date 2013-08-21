
/* Zepto v1.0-1-ga3cab6c - polyfill zepto detect event ajax form fx - zeptojs.com/license */
(function(a){String.prototype.trim===a&&(String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g,"")}),Array.prototype.reduce===a&&(Array.prototype.reduce=function(b){if(this===void 0||this===null)throw new TypeError;var c=Object(this),d=c.length>>>0,e=0,f;if(typeof b!="function")throw new TypeError;if(d==0&&arguments.length==1)throw new TypeError;if(arguments.length>=2)f=arguments[1];else do{if(e in c){f=c[e++];break}if(++e>=d)throw new TypeError}while(!0);while(e<d)e in c&&(f=b.call(a,f,c[e],e,c)),e++;return f})})();var Zepto=function(){function E(a){return a==null?String(a):y[z.call(a)]||"object"}function F(a){return E(a)=="function"}function G(a){return a!=null&&a==a.window}function H(a){return a!=null&&a.nodeType==a.DOCUMENT_NODE}function I(a){return E(a)=="object"}function J(a){return I(a)&&!G(a)&&a.__proto__==Object.prototype}function K(a){return a instanceof Array}function L(a){return typeof a.length=="number"}function M(a){return g.call(a,function(a){return a!=null})}function N(a){return a.length>0?c.fn.concat.apply([],a):a}function O(a){return a.replace(/::/g,"/").replace(/([A-Z]+)([A-Z][a-z])/g,"$1_$2").replace(/([a-z\d])([A-Z])/g,"$1_$2").replace(/_/g,"-").toLowerCase()}function P(a){return a in j?j[a]:j[a]=new RegExp("(^|\\s)"+a+"(\\s|$)")}function Q(a,b){return typeof b=="number"&&!l[O(a)]?b+"px":b}function R(a){var b,c;return i[a]||(b=h.createElement(a),h.body.appendChild(b),c=k(b,"").getPropertyValue("display"),b.parentNode.removeChild(b),c=="none"&&(c="block"),i[a]=c),i[a]}function S(a){return"children"in a?f.call(a.children):c.map(a.childNodes,function(a){if(a.nodeType==1)return a})}function T(c,d,e){for(b in d)e&&(J(d[b])||K(d[b]))?(J(d[b])&&!J(c[b])&&(c[b]={}),K(d[b])&&!K(c[b])&&(c[b]=[]),T(c[b],d[b],e)):d[b]!==a&&(c[b]=d[b])}function U(b,d){return d===a?c(b):c(b).filter(d)}function V(a,b,c,d){return F(b)?b.call(a,c,d):b}function W(a,b,c){c==null?a.removeAttribute(b):a.setAttribute(b,c)}function X(b,c){var d=b.className,e=d&&d.baseVal!==a;if(c===a)return e?d.baseVal:d;e?d.baseVal=c:b.className=c}function Y(a){var b;try{return a?a=="true"||(a=="false"?!1:a=="null"?null:isNaN(b=Number(a))?/^[\[\{]/.test(a)?c.parseJSON(a):a:b):a}catch(d){return a}}function Z(a,b){b(a);for(var c in a.childNodes)Z(a.childNodes[c],b)}var a,b,c,d,e=[],f=e.slice,g=e.filter,h=window.document,i={},j={},k=h.defaultView.getComputedStyle,l={"column-count":1,columns:1,"font-weight":1,"line-height":1,opacity:1,"z-index":1,zoom:1},m=/^\s*<(\w+|!)[^>]*>/,n=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,o=/^(?:body|html)$/i,p=["val","css","html","text","data","width","height","offset"],q=["after","prepend","before","append"],r=h.createElement("table"),s=h.createElement("tr"),t={tr:h.createElement("tbody"),tbody:r,thead:r,tfoot:r,td:s,th:s,"*":h.createElement("div")},u=/complete|loaded|interactive/,v=/^\.([\w-]+)$/,w=/^#([\w-]*)$/,x=/^[\w-]+$/,y={},z=y.toString,A={},B,C,D=h.createElement("div");return A.matches=function(a,b){if(!a||a.nodeType!==1)return!1;var c=a.webkitMatchesSelector||a.mozMatchesSelector||a.oMatchesSelector||a.matchesSelector;if(c)return c.call(a,b);var d,e=a.parentNode,f=!e;return f&&(e=D).appendChild(a),d=~A.qsa(e,b).indexOf(a),f&&D.removeChild(a),d},B=function(a){return a.replace(/-+(.)?/g,function(a,b){return b?b.toUpperCase():""})},C=function(a){return g.call(a,function(b,c){return a.indexOf(b)==c})},A.fragment=function(b,d,e){b.replace&&(b=b.replace(n,"<$1></$2>")),d===a&&(d=m.test(b)&&RegExp.$1),d in t||(d="*");var g,h,i=t[d];return i.innerHTML=""+b,h=c.each(f.call(i.childNodes),function(){i.removeChild(this)}),J(e)&&(g=c(h),c.each(e,function(a,b){p.indexOf(a)>-1?g[a](b):g.attr(a,b)})),h},A.Z=function(a,b){return a=a||[],a.__proto__=c.fn,a.selector=b||"",a},A.isZ=function(a){return a instanceof A.Z},A.init=function(b,d){if(!b)return A.Z();if(F(b))return c(h).ready(b);if(A.isZ(b))return b;var e;if(K(b))e=M(b);else if(I(b))e=[J(b)?c.extend({},b):b],b=null;else if(m.test(b))e=A.fragment(b.trim(),RegExp.$1,d),b=null;else{if(d!==a)return c(d).find(b);e=A.qsa(h,b)}return A.Z(e,b)},c=function(a,b){return A.init(a,b)},c.extend=function(a){var b,c=f.call(arguments,1);return typeof a=="boolean"&&(b=a,a=c.shift()),c.forEach(function(c){T(a,c,b)}),a},A.qsa=function(a,b){var c;return H(a)&&w.test(b)?(c=a.getElementById(RegExp.$1))?[c]:[]:a.nodeType!==1&&a.nodeType!==9?[]:f.call(v.test(b)?a.getElementsByClassName(RegExp.$1):x.test(b)?a.getElementsByTagName(b):a.querySelectorAll(b))},c.contains=function(a,b){return a!==b&&a.contains(b)},c.type=E,c.isFunction=F,c.isWindow=G,c.isArray=K,c.isPlainObject=J,c.isEmptyObject=function(a){var b;for(b in a)return!1;return!0},c.inArray=function(a,b,c){return e.indexOf.call(b,a,c)},c.camelCase=B,c.trim=function(a){return a.trim()},c.uuid=0,c.support={},c.expr={},c.map=function(a,b){var c,d=[],e,f;if(L(a))for(e=0;e<a.length;e++)c=b(a[e],e),c!=null&&d.push(c);else for(f in a)c=b(a[f],f),c!=null&&d.push(c);return N(d)},c.each=function(a,b){var c,d;if(L(a)){for(c=0;c<a.length;c++)if(b.call(a[c],c,a[c])===!1)return a}else for(d in a)if(b.call(a[d],d,a[d])===!1)return a;return a},c.grep=function(a,b){return g.call(a,b)},window.JSON&&(c.parseJSON=JSON.parse),c.each("Boolean Number String Function Array Date RegExp Object Error".split(" "),function(a,b){y["[object "+b+"]"]=b.toLowerCase()}),c.fn={forEach:e.forEach,reduce:e.reduce,push:e.push,sort:e.sort,indexOf:e.indexOf,concat:e.concat,map:function(a){return c(c.map(this,function(b,c){return a.call(b,c,b)}))},slice:function(){return c(f.apply(this,arguments))},ready:function(a){return u.test(h.readyState)?a(c):h.addEventListener("DOMContentLoaded",function(){a(c)},!1),this},get:function(b){return b===a?f.call(this):this[b>=0?b:b+this.length]},toArray:function(){return this.get()},size:function(){return this.length},remove:function(){return this.each(function(){this.parentNode!=null&&this.parentNode.removeChild(this)})},each:function(a){return e.every.call(this,function(b,c){return a.call(b,c,b)!==!1}),this},filter:function(a){return F(a)?this.not(this.not(a)):c(g.call(this,function(b){return A.matches(b,a)}))},add:function(a,b){return c(C(this.concat(c(a,b))))},is:function(a){return this.length>0&&A.matches(this[0],a)},not:function(b){var d=[];if(F(b)&&b.call!==a)this.each(function(a){b.call(this,a)||d.push(this)});else{var e=typeof b=="string"?this.filter(b):L(b)&&F(b.item)?f.call(b):c(b);this.forEach(function(a){e.indexOf(a)<0&&d.push(a)})}return c(d)},has:function(a){return this.filter(function(){return I(a)?c.contains(this,a):c(this).find(a).size()})},eq:function(a){return a===-1?this.slice(a):this.slice(a,+a+1)},first:function(){var a=this[0];return a&&!I(a)?a:c(a)},last:function(){var a=this[this.length-1];return a&&!I(a)?a:c(a)},find:function(a){var b,d=this;return typeof a=="object"?b=c(a).filter(function(){var a=this;return e.some.call(d,function(b){return c.contains(b,a)})}):this.length==1?b=c(A.qsa(this[0],a)):b=this.map(function(){return A.qsa(this,a)}),b},closest:function(a,b){var d=this[0],e=!1;typeof a=="object"&&(e=c(a));while(d&&!(e?e.indexOf(d)>=0:A.matches(d,a)))d=d!==b&&!H(d)&&d.parentNode;return c(d)},parents:function(a){var b=[],d=this;while(d.length>0)d=c.map(d,function(a){if((a=a.parentNode)&&!H(a)&&b.indexOf(a)<0)return b.push(a),a});return U(b,a)},parent:function(a){return U(C(this.pluck("parentNode")),a)},children:function(a){return U(this.map(function(){return S(this)}),a)},contents:function(){return this.map(function(){return f.call(this.childNodes)})},siblings:function(a){return U(this.map(function(a,b){return g.call(S(b.parentNode),function(a){return a!==b})}),a)},empty:function(){return this.each(function(){this.innerHTML=""})},pluck:function(a){return c.map(this,function(b){return b[a]})},show:function(){return this.each(function(){this.style.display=="none"&&(this.style.display=null),k(this,"").getPropertyValue("display")=="none"&&(this.style.display=R(this.nodeName))})},replaceWith:function(a){return this.before(a).remove()},wrap:function(a){var b=F(a);if(this[0]&&!b)var d=c(a).get(0),e=d.parentNode||this.length>1;return this.each(function(f){c(this).wrapAll(b?a.call(this,f):e?d.cloneNode(!0):d)})},wrapAll:function(a){if(this[0]){c(this[0]).before(a=c(a));var b;while((b=a.children()).length)a=b.first();c(a).append(this)}return this},wrapInner:function(a){var b=F(a);return this.each(function(d){var e=c(this),f=e.contents(),g=b?a.call(this,d):a;f.length?f.wrapAll(g):e.append(g)})},unwrap:function(){return this.parent().each(function(){c(this).replaceWith(c(this).children())}),this},clone:function(){return this.map(function(){return this.cloneNode(!0)})},hide:function(){return this.css("display","none")},toggle:function(b){return this.each(function(){var d=c(this);(b===a?d.css("display")=="none":b)?d.show():d.hide()})},prev:function(a){return c(this.pluck("previousElementSibling")).filter(a||"*")},next:function(a){return c(this.pluck("nextElementSibling")).filter(a||"*")},html:function(b){return b===a?this.length>0?this[0].innerHTML:null:this.each(function(a){var d=this.innerHTML;c(this).empty().append(V(this,b,a,d))})},text:function(b){return b===a?this.length>0?this[0].textContent:null:this.each(function(){this.textContent=b})},attr:function(c,d){var e;return typeof c=="string"&&d===a?this.length==0||this[0].nodeType!==1?a:c=="value"&&this[0].nodeName=="INPUT"?this.val():!(e=this[0].getAttribute(c))&&c in this[0]?this[0][c]:e:this.each(function(a){if(this.nodeType!==1)return;if(I(c))for(b in c)W(this,b,c[b]);else W(this,c,V(this,d,a,this.getAttribute(c)))})},removeAttr:function(a){return this.each(function(){this.nodeType===1&&W(this,a)})},prop:function(b,c){return c===a?this[0]&&this[0][b]:this.each(function(a){this[b]=V(this,c,a,this[b])})},data:function(b,c){var d=this.attr("data-"+O(b),c);return d!==null?Y(d):a},val:function(b){return b===a?this[0]&&(this[0].multiple?c(this[0]).find("option").filter(function(a){return this.selected}).pluck("value"):this[0].value):this.each(function(a){this.value=V(this,b,a,this.value)})},offset:function(a){if(a)return this.each(function(b){var d=c(this),e=V(this,a,b,d.offset()),f=d.offsetParent().offset(),g={top:e.top-f.top,left:e.left-f.left};d.css("position")=="static"&&(g.position="relative"),d.css(g)});if(this.length==0)return null;var b=this[0].getBoundingClientRect();return{left:b.left+window.pageXOffset,top:b.top+window.pageYOffset,width:Math.round(b.width),height:Math.round(b.height)}},css:function(a,c){if(arguments.length<2&&typeof a=="string")return this[0]&&(this[0].style[B(a)]||k(this[0],"").getPropertyValue(a));var d="";if(E(a)=="string")!c&&c!==0?this.each(function(){this.style.removeProperty(O(a))}):d=O(a)+":"+Q(a,c);else for(b in a)!a[b]&&a[b]!==0?this.each(function(){this.style.removeProperty(O(b))}):d+=O(b)+":"+Q(b,a[b])+";";return this.each(function(){this.style.cssText+=";"+d})},index:function(a){return a?this.indexOf(c(a)[0]):this.parent().children().indexOf(this[0])},hasClass:function(a){return e.some.call(this,function(a){return this.test(X(a))},P(a))},addClass:function(a){return this.each(function(b){d=[];var e=X(this),f=V(this,a,b,e);f.split(/\s+/g).forEach(function(a){c(this).hasClass(a)||d.push(a)},this),d.length&&X(this,e+(e?" ":"")+d.join(" "))})},removeClass:function(b){return this.each(function(c){if(b===a)return X(this,"");d=X(this),V(this,b,c,d).split(/\s+/g).forEach(function(a){d=d.replace(P(a)," ")}),X(this,d.trim())})},toggleClass:function(b,d){return this.each(function(e){var f=c(this),g=V(this,b,e,X(this));g.split(/\s+/g).forEach(function(b){(d===a?!f.hasClass(b):d)?f.addClass(b):f.removeClass(b)})})},scrollTop:function(){if(!this.length)return;return"scrollTop"in this[0]?this[0].scrollTop:this[0].scrollY},position:function(){if(!this.length)return;var a=this[0],b=this.offsetParent(),d=this.offset(),e=o.test(b[0].nodeName)?{top:0,left:0}:b.offset();return d.top-=parseFloat(c(a).css("margin-top"))||0,d.left-=parseFloat(c(a).css("margin-left"))||0,e.top+=parseFloat(c(b[0]).css("border-top-width"))||0,e.left+=parseFloat(c(b[0]).css("border-left-width"))||0,{top:d.top-e.top,left:d.left-e.left}},offsetParent:function(){return this.map(function(){var a=this.offsetParent||h.body;while(a&&!o.test(a.nodeName)&&c(a).css("position")=="static")a=a.offsetParent;return a})}},c.fn.detach=c.fn.remove,["width","height"].forEach(function(b){c.fn[b]=function(d){var e,f=this[0],g=b.replace(/./,function(a){return a[0].toUpperCase()});return d===a?G(f)?f["inner"+g]:H(f)?f.documentElement["offset"+g]:(e=this.offset())&&e[b]:this.each(function(a){f=c(this),f.css(b,V(this,d,a,f[b]()))})}}),q.forEach(function(a,b){var d=b%2;c.fn[a]=function(){var a,e=c.map(arguments,function(b){return a=E(b),a=="object"||a=="array"||b==null?b:A.fragment(b)}),f,g=this.length>1;return e.length<1?this:this.each(function(a,h){f=d?h:h.parentNode,h=b==0?h.nextSibling:b==1?h.firstChild:b==2?h:null,e.forEach(function(a){if(g)a=a.cloneNode(!0);else if(!f)return c(a).remove();Z(f.insertBefore(a,h),function(a){a.nodeName!=null&&a.nodeName.toUpperCase()==="SCRIPT"&&(!a.type||a.type==="text/javascript")&&!a.src&&window.eval.call(window,a.innerHTML)})})})},c.fn[d?a+"To":"insert"+(b?"Before":"After")]=function(b){return c(b)[a](this),this}}),A.Z.prototype=c.fn,A.uniq=C,A.deserializeValue=Y,c.zepto=A,c}();window.Zepto=Zepto,"$"in window||(window.$=Zepto),function(a){function b(a){var b=this.os={},c=this.browser={},d=a.match(/WebKit\/([\d.]+)/),e=a.match(/(Android)\s+([\d.]+)/),f=a.match(/(iPad).*OS\s([\d_]+)/),g=!f&&a.match(/(iPhone\sOS)\s([\d_]+)/),h=a.match(/(webOS|hpwOS)[\s\/]([\d.]+)/),i=h&&a.match(/TouchPad/),j=a.match(/Kindle\/([\d.]+)/),k=a.match(/Silk\/([\d._]+)/),l=a.match(/(BlackBerry).*Version\/([\d.]+)/),m=a.match(/(BB10).*Version\/([\d.]+)/),n=a.match(/(RIM\sTablet\sOS)\s([\d.]+)/),o=a.match(/PlayBook/),p=a.match(/Chrome\/([\d.]+)/)||a.match(/CriOS\/([\d.]+)/),q=a.match(/Firefox\/([\d.]+)/);if(c.webkit=!!d)c.version=d[1];e&&(b.android=!0,b.version=e[2]),g&&(b.ios=b.iphone=!0,b.version=g[2].replace(/_/g,".")),f&&(b.ios=b.ipad=!0,b.version=f[2].replace(/_/g,".")),h&&(b.webos=!0,b.version=h[2]),i&&(b.touchpad=!0),l&&(b.blackberry=!0,b.version=l[2]),m&&(b.bb10=!0,b.version=m[2]),n&&(b.rimtabletos=!0,b.version=n[2]),o&&(c.playbook=!0),j&&(b.kindle=!0,b.version=j[1]),k&&(c.silk=!0,c.version=k[1]),!k&&b.android&&a.match(/Kindle Fire/)&&(c.silk=!0),p&&(c.chrome=!0,c.version=p[1]),q&&(c.firefox=!0,c.version=q[1]),b.tablet=!!(f||o||e&&!a.match(/Mobile/)||q&&a.match(/Tablet/)),b.phone=!b.tablet&&!!(e||g||h||l||m||p&&a.match(/Android/)||p&&a.match(/CriOS\/([\d.]+)/)||q&&a.match(/Mobile/))}b.call(a,navigator.userAgent),a.__detect=b}(Zepto),function(a){function g(a){return a._zid||(a._zid=d++)}function h(a,b,d,e){b=i(b);if(b.ns)var f=j(b.ns);return(c[g(a)]||[]).filter(function(a){return a&&(!b.e||a.e==b.e)&&(!b.ns||f.test(a.ns))&&(!d||g(a.fn)===g(d))&&(!e||a.sel==e)})}function i(a){var b=(""+a).split(".");return{e:b[0],ns:b.slice(1).sort().join(" ")}}function j(a){return new RegExp("(?:^| )"+a.replace(" "," .* ?")+"(?: |$)")}function k(b,c,d){a.type(b)!="string"?a.each(b,d):b.split(/\s/).forEach(function(a){d(a,c)})}function l(a,b){return a.del&&(a.e=="focus"||a.e=="blur")||!!b}function m(a){return f[a]||a}function n(b,d,e,h,j,n){var o=g(b),p=c[o]||(c[o]=[]);k(d,e,function(c,d){var e=i(c);e.fn=d,e.sel=h,e.e in f&&(d=function(b){var c=b.relatedTarget;if(!c||c!==this&&!a.contains(this,c))return e.fn.apply(this,arguments)}),e.del=j&&j(d,c);var g=e.del||d;e.proxy=function(a){var c=g.apply(b,[a].concat(a.data));return c===!1&&(a.preventDefault(),a.stopPropagation()),c},e.i=p.length,p.push(e),b.addEventListener(m(e.e),e.proxy,l(e,n))})}function o(a,b,d,e,f){var i=g(a);k(b||"",d,function(b,d){h(a,b,d,e).forEach(function(b){delete c[i][b.i],a.removeEventListener(m(b.e),b.proxy,l(b,f))})})}function t(b){var c,d={originalEvent:b};for(c in b)!r.test(c)&&b[c]!==undefined&&(d[c]=b[c]);return a.each(s,function(a,c){d[a]=function(){return this[c]=p,b[a].apply(b,arguments)},d[c]=q}),d}function u(a){if(!("defaultPrevented"in a)){a.defaultPrevented=!1;var b=a.preventDefault;a.preventDefault=function(){this.defaultPrevented=!0,b.call(this)}}}var b=a.zepto.qsa,c={},d=1,e={},f={mouseenter:"mouseover",mouseleave:"mouseout"};e.click=e.mousedown=e.mouseup=e.mousemove="MouseEvents",a.event={add:n,remove:o},a.proxy=function(b,c){if(a.isFunction(b)){var d=function(){return b.apply(c,arguments)};return d._zid=g(b),d}if(typeof c=="string")return a.proxy(b[c],b);throw new TypeError("expected function")},a.fn.bind=function(a,b){return this.each(function(){n(this,a,b)})},a.fn.unbind=function(a,b){return this.each(function(){o(this,a,b)})},a.fn.one=function(a,b){return this.each(function(c,d){n(this,a,b,null,function(a,b){return function(){var c=a.apply(d,arguments);return o(d,b,a),c}})})};var p=function(){return!0},q=function(){return!1},r=/^([A-Z]|layer[XY]$)/,s={preventDefault:"isDefaultPrevented",stopImmediatePropagation:"isImmediatePropagationStopped",stopPropagation:"isPropagationStopped"};a.fn.delegate=function(b,c,d){return this.each(function(e,f){n(f,c,d,b,function(c){return function(d){var e,g=a(d.target).closest(b,f).get(0);if(g)return e=a.extend(t(d),{currentTarget:g,liveFired:f}),c.apply(g,[e].concat([].slice.call(arguments,1)))}})})},a.fn.undelegate=function(a,b,c){return this.each(function(){o(this,b,c,a)})},a.fn.live=function(b,c){return a(document.body).delegate(this.selector,b,c),this},a.fn.die=function(b,c){return a(document.body).undelegate(this.selector,b,c),this},a.fn.on=function(b,c,d){return!c||a.isFunction(c)?this.bind(b,c||d):this.delegate(c,b,d)},a.fn.off=function(b,c,d){return!c||a.isFunction(c)?this.unbind(b,c||d):this.undelegate(c,b,d)},a.fn.trigger=function(b,c){if(typeof b=="string"||a.isPlainObject(b))b=a.Event(b);return u(b),b.data=c,this.each(function(){"dispatchEvent"in this&&this.dispatchEvent(b)})},a.fn.triggerHandler=function(b,c){var d,e;return this.each(function(f,g){d=t(typeof b=="string"?a.Event(b):b),d.data=c,d.target=g,a.each(h(g,b.type||b),function(a,b){e=b.proxy(d);if(d.isImmediatePropagationStopped())return!1})}),e},"focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select keydown keypress keyup error".split(" ").forEach(function(b){a.fn[b]=function(a){return a?this.bind(b,a):this.trigger(b)}}),["focus","blur"].forEach(function(b){a.fn[b]=function(a){return a?this.bind(b,a):this.each(function(){try{this[b]()}catch(a){}}),this}}),a.Event=function(a,b){typeof a!="string"&&(b=a,a=b.type);var c=document.createEvent(e[a]||"Events"),d=!0;if(b)for(var f in b)f=="bubbles"?d=!!b[f]:c[f]=b[f];return c.initEvent(a,d,!0,null,null,null,null,null,null,null,null,null,null,null,null),c.isDefaultPrevented=function(){return this.defaultPrevented},c}}(Zepto),function($){function triggerAndReturn(a,b,c){var d=$.Event(b);return $(a).trigger(d,c),!d.defaultPrevented}function triggerGlobal(a,b,c,d){if(a.global)return triggerAndReturn(b||document,c,d)}function ajaxStart(a){a.global&&$.active++===0&&triggerGlobal(a,null,"ajaxStart")}function ajaxStop(a){a.global&&!--$.active&&triggerGlobal(a,null,"ajaxStop")}function ajaxBeforeSend(a,b){var c=b.context;if(b.beforeSend.call(c,a,b)===!1||triggerGlobal(b,c,"ajaxBeforeSend",[a,b])===!1)return!1;triggerGlobal(b,c,"ajaxSend",[a,b])}function ajaxSuccess(a,b,c){var d=c.context,e="success";c.success.call(d,a,e,b),triggerGlobal(c,d,"ajaxSuccess",[b,c,a]),ajaxComplete(e,b,c)}function ajaxError(a,b,c,d){var e=d.context;d.error.call(e,c,b,a),triggerGlobal(d,e,"ajaxError",[c,d,a]),ajaxComplete(b,c,d)}function ajaxComplete(a,b,c){var d=c.context;c.complete.call(d,b,a),triggerGlobal(c,d,"ajaxComplete",[b,c]),ajaxStop(c)}function empty(){}function mimeToDataType(a){return a&&(a=a.split(";",2)[0]),a&&(a==htmlType?"html":a==jsonType?"json":scriptTypeRE.test(a)?"script":xmlTypeRE.test(a)&&"xml")||"text"}function appendQuery(a,b){return(a+"&"+b).replace(/[&?]{1,2}/,"?")}function serializeData(a){a.processData&&a.data&&$.type(a.data)!="string"&&(a.data=$.param(a.data,a.traditional)),a.data&&(!a.type||a.type.toUpperCase()=="GET")&&(a.url=appendQuery(a.url,a.data))}function parseArguments(a,b,c,d){var e=!$.isFunction(b);return{url:a,data:e?b:undefined,success:e?$.isFunction(c)?c:undefined:b,dataType:e?d||c:c}}function serialize(a,b,c,d){var e,f=$.isArray(b);$.each(b,function(b,g){e=$.type(g),d&&(b=c?d:d+"["+(f?"":b)+"]"),!d&&f?a.add(g.name,g.value):e=="array"||!c&&e=="object"?serialize(a,g,c,b):a.add(b,g)})}var jsonpID=0,document=window.document,key,name,rscript=/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,scriptTypeRE=/^(?:text|application)\/javascript/i,xmlTypeRE=/^(?:text|application)\/xml/i,jsonType="application/json",htmlType="text/html",blankRE=/^\s*$/;$.active=0,$.ajaxJSONP=function(a){if("type"in a){var b="jsonp"+ ++jsonpID,c=document.createElement("script"),d=function(){clearTimeout(g),$(c).remove(),delete window[b]},e=function(c){d();if(!c||c=="timeout")window[b]=empty;ajaxError(null,c||"abort",f,a)},f={abort:e},g;return ajaxBeforeSend(f,a)===!1?(e("abort"),!1):(window[b]=function(b){d(),ajaxSuccess(b,f,a)},c.onerror=function(){e("error")},c.src=a.url.replace(/=\?/,"="+b),$("head").append(c),a.timeout>0&&(g=setTimeout(function(){e("timeout")},a.timeout)),f)}return $.ajax(a)},$.ajaxSettings={type:"GET",beforeSend:empty,success:empty,error:empty,complete:empty,context:null,global:!0,xhr:function(){return new window.XMLHttpRequest},accepts:{script:"text/javascript, application/javascript",json:jsonType,xml:"application/xml, text/xml",html:htmlType,text:"text/plain"},crossDomain:!1,timeout:0,processData:!0,cache:!0},$.ajax=function(options){var settings=$.extend({},options||{});for(key in $.ajaxSettings)settings[key]===undefined&&(settings[key]=$.ajaxSettings[key]);ajaxStart(settings),settings.crossDomain||(settings.crossDomain=/^([\w-]+:)?\/\/([^\/]+)/.test(settings.url)&&RegExp.$2!=window.location.host),settings.url||(settings.url=window.location.toString()),serializeData(settings),settings.cache===!1&&(settings.url=appendQuery(settings.url,"_="+Date.now()));var dataType=settings.dataType,hasPlaceholder=/=\?/.test(settings.url);if(dataType=="jsonp"||hasPlaceholder)return hasPlaceholder||(settings.url=appendQuery(settings.url,"callback=?")),$.ajaxJSONP(settings);var mime=settings.accepts[dataType],baseHeaders={},protocol=/^([\w-]+:)\/\//.test(settings.url)?RegExp.$1:window.location.protocol,xhr=settings.xhr(),abortTimeout;settings.crossDomain||(baseHeaders["X-Requested-With"]="XMLHttpRequest"),mime&&(baseHeaders.Accept=mime,mime.indexOf(",")>-1&&(mime=mime.split(",",2)[0]),xhr.overrideMimeType&&xhr.overrideMimeType(mime));if(settings.contentType||settings.contentType!==!1&&settings.data&&settings.type.toUpperCase()!="GET")baseHeaders["Content-Type"]=settings.contentType||"application/x-www-form-urlencoded";settings.headers=$.extend(baseHeaders,settings.headers||{}),xhr.onreadystatechange=function(){if(xhr.readyState==4){xhr.onreadystatechange=empty,clearTimeout(abortTimeout);var result,error=!1;if(xhr.status>=200&&xhr.status<300||xhr.status==304||xhr.status==0&&protocol=="file:"){dataType=dataType||mimeToDataType(xhr.getResponseHeader("content-type")),result=xhr.responseText;try{dataType=="script"?(1,eval)(result):dataType=="xml"?result=xhr.responseXML:dataType=="json"&&(result=blankRE.test(result)?null:$.parseJSON(result))}catch(e){error=e}error?ajaxError(error,"parsererror",xhr,settings):ajaxSuccess(result,xhr,settings)}else ajaxError(null,xhr.status?"error":"abort",xhr,settings)}};var async="async"in settings?settings.async:!0;xhr.open(settings.type,settings.url,async);for(name in settings.headers)xhr.setRequestHeader(name,settings.headers[name]);return ajaxBeforeSend(xhr,settings)===!1?(xhr.abort(),!1):(settings.timeout>0&&(abortTimeout=setTimeout(function(){xhr.onreadystatechange=empty,xhr.abort(),ajaxError(null,"timeout",xhr,settings)},settings.timeout)),xhr.send(settings.data?settings.data:null),xhr)},$.get=function(a,b,c,d){return $.ajax(parseArguments.apply(null,arguments))},$.post=function(a,b,c,d){var e=parseArguments.apply(null,arguments);return e.type="POST",$.ajax(e)},$.getJSON=function(a,b,c){var d=parseArguments.apply(null,arguments);return d.dataType="json",$.ajax(d)},$.fn.load=function(a,b,c){if(!this.length)return this;var d=this,e=a.split(/\s/),f,g=parseArguments(a,b,c),h=g.success;return e.length>1&&(g.url=e[0],f=e[1]),g.success=function(a){d.html(f?$("<div>").html(a.replace(rscript,"")).find(f):a),h&&h.apply(d,arguments)},$.ajax(g),this};var escape=encodeURIComponent;$.param=function(a,b){var c=[];return c.add=function(a,b){this.push(escape(a)+"="+escape(b))},serialize(c,a,b),c.join("&").replace(/%20/g,"+")}}(Zepto),function(a){a.fn.serializeArray=function(){var b=[],c;return a(Array.prototype.slice.call(this.get(0).elements)).each(function(){c=a(this);var d=c.attr("type");this.nodeName.toLowerCase()!="fieldset"&&!this.disabled&&d!="submit"&&d!="reset"&&d!="button"&&(d!="radio"&&d!="checkbox"||this.checked)&&b.push({name:c.attr("name"),value:c.val()})}),b},a.fn.serialize=function(){var a=[];return this.serializeArray().forEach(function(b){a.push(encodeURIComponent(b.name)+"="+encodeURIComponent(b.value))}),a.join("&")},a.fn.submit=function(b){if(b)this.bind("submit",b);else if(this.length){var c=a.Event("submit");this.eq(0).trigger(c),c.defaultPrevented||this.get(0).submit()}return this}}(Zepto),function(a,b){function s(a){return t(a.replace(/([a-z])([A-Z])/,"$1-$2"))}function t(a){return a.toLowerCase()}function u(a){return d?d+a:t(a)}var c="",d,e,f,g={Webkit:"webkit",Moz:"",O:"o",ms:"MS"},h=window.document,i=h.createElement("div"),j=/^((translate|rotate|scale)(X|Y|Z|3d)?|matrix(3d)?|perspective|skew(X|Y)?)$/i,k,l,m,n,o,p,q,r={};a.each(g,function(a,e){if(i.style[a+"TransitionProperty"]!==b)return c="-"+t(a)+"-",d=e,!1}),k=c+"transform",r[l=c+"transition-property"]=r[m=c+"transition-duration"]=r[n=c+"transition-timing-function"]=r[o=c+"animation-name"]=r[p=c+"animation-duration"]=r[q=c+"animation-timing-function"]="",a.fx={off:d===b&&i.style.transitionProperty===b,speeds:{_default:400,fast:200,slow:600},cssPrefix:c,transitionEnd:u("TransitionEnd"),animationEnd:u("AnimationEnd")},a.fn.animate=function(b,c,d,e){return a.isPlainObject(c)&&(d=c.easing,e=c.complete,c=c.duration),c&&(c=(typeof c=="number"?c:a.fx.speeds[c]||a.fx.speeds._default)/1e3),this.anim(b,c,d,e)},a.fn.anim=function(c,d,e,f){var g,h={},i,t="",u=this,v,w=a.fx.transitionEnd;d===b&&(d=.4),a.fx.off&&(d=0);if(typeof c=="string")h[o]=c,h[p]=d+"s",h[q]=e||"linear",w=a.fx.animationEnd;else{i=[];for(g in c)j.test(g)?t+=g+"("+c[g]+") ":(h[g]=c[g],i.push(s(g)));t&&(h[k]=t,i.push(k)),d>0&&typeof c=="object"&&(h[l]=i.join(", "),h[m]=d+"s",h[n]=e||"linear")}return v=function(b){if(typeof b!="undefined"){if(b.target!==b.currentTarget)return;a(b.target).unbind(w,v)}a(this).css(r),f&&f.call(this)},d>0&&this.bind(w,v),this.size()&&this.get(0).clientLeft,this.css(h),d<=0&&setTimeout(function(){u.each(function(){v.call(this)})},0),this},i=null}(Zepto)

// connector class for hooking up to API
function ApiConnector(){
	var heatmapData = []; 
	var markerData = []; 
	var commentData = [];


	// var BASE = "http://greenupapp.appspot.com/api";
	var BASE = "http://localhost:30002/api";
	this.BASE = BASE;


	// api URLs have been moved into each of the functions using them as per issue 46

	// performs the ajax call to get our data
	ApiConnector.prototype.pullApiData = function pullApiData(URL, DATATYPE, QUERYTYPE, CALLBACK){
		// zepto
		console.log(URL);
		$.ajax({
			type: QUERYTYPE,
			url: URL,
			dataType: DATATYPE,
			success: function(data){
				console.log("Pull API Data: SUCCESS");
				// console.log(data);
				CALLBACK(data);
			},
			error: function(xhr, errorType, error){
				// alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						console.log("Error: api response = 500");
						break;
					case 404:
						// not found, stop trying
						// consider leaving app
						console.log('Error: api response = 404');
						break;
					case 400:
						// bad request
						console.log("Error: api response = 400");
						break;
					case 422:
						console.log("Error: api response = 422");
						break;
					case 200:
						console.log("Pull API data: 200");
						break;
					default:
						// alert("Error Contacting API: "+xhr.status);
						break;
				}
			}
		});
	} // end pullApiData



	ApiConnector.prototype.pushNewPin = function pushNewPin(jsonObj){
		console.log(jsonObj);
		var pinsURI = "/pins";
		$.ajax({
			type: "POST",
			url: BASE+pinsURI,
			data: jsonObj,
    		cache: false,
			// processData: false,
			dataType: "json",
			// contentType: "application/json",
			success: function(data){
				console.log("INFO: Pin successfully sent");
				//Becuase of the datastore's eventual consistency you must wait a brief moment for new data to be available.
				setTimeout(function(){window.ApiConnector.pullMarkerData();},150);
			},
			error: function(xhr, errorType, error){
				// // alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						console.log("Error: api response = 500");
						break;
					case 503:
						console.log("Service Unavailable");
						break;

					case 404:
						// not found, stop trying
						// consider leaving app
						console.log('Error: api response = 404');
						break;
					case 400:
						// bad request
						console.log("Error: api response = 400");
						break;
					case 422:
						console.log("Error: api response = 422");
						break;
					case 200:
						console.log("Request successful");
						break;
					default:
						// alert("Error Contacting API: "+xhr.status);
						break;
				}
			}
		});
		//zepto

	}


	// ********** specific data pullers *************
	ApiConnector.prototype.pullHeatmapData = function pullHeatmapData(latDegrees, latOffset, lonDegrees, lonOffset){
		/*
			To be extra safe we could do if(typeof(param) === "undefined" || param == null),
			but there is an implicit cast against undefined defined for double equals in javascript
		*/
		var heatmapURI = "/heatmap";
		var params = "";
		if(latDegrees != null){
			params = "?";
			params += "latDegrees=" + latDegrees + "&";
		}
		if(latOffset != null){
			params = "?";
			params += "latOffset=" + latOffset + "&";
		}
		if(lonDegrees != null){
			params = "?";
			params += "lonDegrees" + lonDegrees + "&";
		}
		if(lonOffset != null){
			params = "?";
			params += "lonOffset" + lonOffset + "&";
		}
		console.log("Preparing to pull heatmap data");
		var URL = BASE+heatmapURI+params;
		this.pullApiData(URL, "JSON", "GET", window.UI.updateHeatmap);

	}

	ApiConnector.prototype.pullMarkerData = function pullMarkerData(){
		var pinsURI = "/pins";
		var URL = BASE+pinsURI;
		//Clear the markers
		for( var i =0 ; i < window.MAP.pickupMarkers.length; i++){
			window.MAP.pickupMarkers[i].setMap(null);
		}
		window.MAP.pickupMarkers = [];
		this.pullApiData(URL, "JSON", "GET", window.UI.updateMarker);
	}

	// by passing the url as an argument, we can use this method to get next pages
	ApiConnector.prototype.pullCommentData = function pullCommentData(commentType, url){
		var urlStr = "";
		if(url == null || url == "null"){
			urlStr += "/api/comments";
		}else{
			urlStr += url;
		}

		this.pullApiData(urlStr, "JSON", "GET",  window.UI.updateForum);
	} // end pullCommentData()

	ApiConnector.prototype.pushCommentData = function pushCommentData(jsonObj){
		var commentsURI = "/comments";
		console.log("json to push: "+jsonObj);
		console.log("Push comment data to: "+BASE+commentsURI);
		$.ajax({
			type: "POST",
			url: BASE+commentsURI,
			data: jsonObj,
    		cache: false,
			// processData: false,
			dataType: "json",
			// contentType: "application/json",
			success: function(data){
				console.log("INFO: Comment successfully sent");
				window.ApiConnector.pullCommentData(JSON.parse(jsonObj).type, null);
			},
			error: function(xhr, errorType, error){
				// // alert("error: "+xhr.status);
				switch(xhr.status){
					case 500:
						// internal server error
						// consider leaving app
						console.log("Error: api response = 500");
						break;
					case 503:
						console.log("Service Unavailable");
						break;

					case 404:
						// not found, stop trying
						// consider leaving app
						console.log('Error: api response = 404');
						break;
					case 400:
						// bad request
						console.log("Error: api response = 400");
						break;
					case 422:
						console.log("Error: api response = 422");
						break;
					case 200:
						console.log("Request successful");
						break;
					default:
						// alert("Error Contacting API: "+xhr.status);
						break;
				}
			}
		});
	}

	ApiConnector.prototype.pullTestData = function pullTestData(){
		this.pullApiData(BASE, "JSON", "GET", window.UI.updateTest);
		this.pullCommentData("needs", null);
		this.pullCommentData("messages", null);
		this.pullCommentData("", null);
		this.pullHeatmapData();
		this.pullMarkerData();
	}

	//Uploads all local database entries to the Server
	//Clears the local storage after upload
	ApiConnector.prototype.pushHeatmapData = function pushHeatmapData(){
		var heatmapURI = "/heatmap";
	    if(window.logging){
	        //server/addgriddata.php
	        var jsonArray = [];
	        console.log("Heatmap data to be pushed:")
	    	window.database.all(function(data){
	   			jsonArray.push(data[0].value);
			});

			console.log(jsonArray);
		}
	
		// zepto code
		$.ajax({
	    	type:'PUT',
	    	url: BASE + heatmapURI,
	    	dataType:"json",
	    	data:  JSON.stringify(jsonArray),
	    	failure: function(errMsg){
		      	// alert(errMsg);
	      		console.log("Failed to PUT heatmap: "+errMsg);
	    	}, 
	    	success: function(data){
		      	console.log("PUT heatmap success: "+data);
	       		// window.database.nuke();
	    	}
		});//Ajax	
	}

	

	// baseline testing
	ApiConnector.prototype.testObj = function testObj(){
		var URL = testurl;
		this.pullApiData(URL, "JSON", "GET", this.updateTest);
	}

} // end ApiConnector class def

/**
* manage the loading screen
*
*/
function LoadingScreen(loadingDiv){ 
	var ISVISIBLE = false;
	this.loadingText = "Loading...";
	var loadingTextDiv = document.getElementById("loadingText");

	LoadingScreen.prototype.show = function show(){
		this.ISVISIBLE = true;
		loadingDiv.style.display = "block";
		loadingTextDiv.innerHTML = window.LS.loadingText;
	}

	LoadingScreen.prototype.hide = function hide(){
		this.ISVISIBLE = false;
		loadingDiv.style.display = "none";
	}

	LoadingScreen.prototype.isVisible = function isVisible(){
		return this.ISVISIBLE; 
	}

	LoadingScreen.prototype.setLoadingText = function setLoadingText(text){
		this.loadingText = text;
	}
} // end LoadingScreen class def



// class for managing all geolocation work
function GpsHandle(){
	
	GpsHandle.prototype.initGps = function initGps(){
		window.logging = true;
		console.log("initGps");
		window.updateCounter = 0;
    	db = Lawnchair({name : 'db'}, function(store) {
        	window.database = store;
        	window.GPS.loggingInterval = setInterval(function() {window.GPS.runUpdate()},30000);//update user location every 5 seconds
        	// instead of running 2 timers, we'll just set a counter and run the pushHeatmapData() on a multiple of... 
        	// ...the runUpdate() function
        	// setInterval(function() {window.ApiConnector.pushHeatmapData(store)},3000);//upload locations to the server every 30 seconds
    	});
	}

	//Runs the update script:
	GpsHandle.prototype.runUpdate = function runUpdate(){
		console.log("runUpdate");
	    //Grab the geolocation data from the local machine
	    if(window.updateCounter == 5){
	    	window.updateCounter = 0;
	    	window.ApiConnector.pushHeatmapData();
	    }else{
	    	// console.log("getting position data");
	    	 if(navigator.geolocation){
	    	 	var options = {timeout:29000};
	    	 	navigator.geolocation.getCurrentPosition(window.GPS.updateLocation, window.GPS.gpsErrorHandler, options);
		     	window.updateCounter++;
	    	 }else{
	    	 	console.log("Geolocation is not supported by this browser.");
	    	 }
	    }
	}

	GpsHandle.prototype.gpsErrorHandler = function gpsErrorHandler(error){
		console.log("Gps error: "); 
		console.log(error);
	}

	GpsHandle.prototype.updateLocation = function updateLocation(position){
		console.log("Update Location");
		// console.log(position);
	    if(window.logging){
	        var datetime = new Date().getTime();//generate timestamp
	        var location = {
	                "latDegrees" : position.coords.latitude,
	                "lonDegrees" : position.coords.longitude,
	                "secondsWorked" : datetime
	        }
	        console.log("database saved");
	        console.log(location);
	        window.database.save({value:location});//Save the record
	    }
	};

	GpsHandle.prototype.recenterMap = function recenterMap(lat, lon){
    	var newcenter = new google.maps.LatLng(lat, lon);
        centerPoint = newcenter;
        map.panTo(newcenter);
	}

	GpsHandle.prototype.start = function start(){
		document.getElementById("startButton").className = "bigStopButton";
		window.UI.setBigButtonText("Stop Cleaning");
		window.logging = true;
    	this.initGps();
    	console.log("initializing GPS...");
		navigator.geolocation.getCurrentPosition(function(p){
        	window.MAP.updateMap(p.coords.latitude, p.coords.longitude, 10);
     	});
    }


	GpsHandle.prototype.stop = function stop(){
		document.getElementById("startButton").className = "bigStartButton";
    	window.ApiConnector.pushHeatmapData();
    	window.logging = false;
    	console.log("stopping GPS...");
    	clearInterval(window.GPS.loggingInterval);
    	window.UI.setBigButtonText("Start Cleaning");
	}
    
} // end GpsHandle class def


// class for managing all Map work
function MapHandle(){
	// BTV coords
	this.currentLat = 44.476621500000000; 
	this.currentLon = -73.209998100000000;
	this.currentZoom = 10;
	this.markerEvent;
	this.markerType;
	this.map;
	this.pickupMarkers = [];
	// fire up our google map
	MapHandle.prototype.initMap = function initMap(){
		window.LS.setLoadingText("Please wait while the map loads");
		window.LS.show();
	    // define the initial location of our map
	    centerPoint = new google.maps.LatLng(window.MAP.currentLat, window.MAP.currentLon); 
	    var mapOptions = {
		    center: centerPoint,
		    mapTypeId: google.maps.MapTypeId.ROADMAP, 
		    mapTypeControl: true,
   			mapTypeControlOptions: {
      			position: google.maps.ControlPosition.TOP_CENTER,
      			style: google.maps.MapTypeControlStyle.DEFAULT
    		}, 
    		zoom: window.MAP.currentZoom,
    		streetViewControl: false
		  };

		  // google.maps.MapTypeControlOptions
		  // google.maps.StreetViewControlOptions
		  // google.maps.ZoomControlOptions

		  window.MAP.map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
		  // for activating the loading screen while map loads
		  google.maps.event.addListener(window.MAP.map, 'idle', window.UI.setMapLoaded);
		  google.maps.event.addListener(window.MAP.map, 'center_changed', window.LS.show);
		  google.maps.event.addListener(window.MAP.map, 'zoom_changed', window.LS.show);
		  // our comment selector initializers

		  // google.maps.event.addListener(window.MAP.map, 'mousedown', this.setMarkerEvent);
		  google.maps.event.addListener(window.MAP.map, 'mousedown', window.UI.mapTouchDown);
		  google.maps.event.addListener(window.MAP.map, 'mouseup', window.UI.mapTouchUp);
	}

	MapHandle.prototype.addMarkerFromUi = function addMarkerFromUi(message, lat, lon){
		// console.log("in addMarker()");
		console.log("message");

		var pin = new Pin();
		pin.message = message;
		pin.type = window.MAP.markerType;
		// alert(pin.type);
		
		// heres the issue (bug)
		// pin.latDegrees = lat;
		// pin.lonDegrees = lon;

		var iconUrl; 
		switch(window.MAP.markerType){
			case "general message":
				pin.type = "general message";
				iconUrl = "img/icons/orangeCircle.png";
				break;
			case "help needed":
				pin.type = "help needed";
				iconUrl = "img/icons/blueCircle.png";
				break;
			case "trash pickup":
				pin.type = "trash pickup";
				iconUrl = "img/icons/greenCircle.png";
				break;
			default:
				pin.type = "general message";
				iconUrl = "icons/blueCircle.png";
				break;
		}
	
		var eventLatLng = window.MAP.markerEvent;
		console.log(eventLatLng.latLng);
		pin.latDegrees = eventLatLng.latLng.mb;
		pin.lonDegrees = eventLatLng.latLng.nb;
		alert(pin.latDegrees);

		var serializedPin = JSON.stringify(pin);
		console.log(serializedPin);
    	window.ApiConnector.pushNewPin(serializedPin);

	}

	MapHandle.prototype.applyHeatMap = function applyHeatMap(data){
		console.log("Heatmap data to be applied to map: ");
		console.log(data);
		var dataObj = eval(data);
		var heatmapData = [];
			// console.log(dataObj[ii].latDegrees);
		for(var ii=0; ii<dataObj.length; ii++){
			heatmapData.push({location: new google.maps.LatLng(dataObj[ii].latDegrees, dataObj[ii].lonDegrees), weight: dataObj[ii].secondsWorked});
			
		}

		console.log("Processed heatmap data:");
		console.log(heatmapData);

  		if(heatmapData.length > 0){
	        var pointArray = new google.maps.MVCArray(heatmapData);

			heatmap = new google.maps.visualization.HeatmapLayer({
			    data: pointArray,
			    dissipating: true, 
			    radius: 5
			});

	  		heatmap.setMap(window.MAP.map);
	  	}
	}

	MapHandle.prototype.addMarkerFromApi = function addMarkerFromApi(markerType, message, lat, lon){
		// console.log("in addMarker()");
		var pin = new Pin();
		pin.message = message;
		pin.type = markerType;
		pin.latDegrees = lat;
		pin.lonDegrees = lon;

		var iconUrl; 
		switch(markerType){
			case "GENERAL MESSAGE":
				pin.type = "GENERAL MESSAGE";
				iconUrl = "img/icons/orangeCircle.png";
				break;
			case "HELP NEEDED":
				pin.type = "HELP NEEDED";
				iconUrl = "img/icons/blueCircle.png";
				break;
			case "TRASH PICKUP":
				pin.type = "TRASH PICKUP";
				iconUrl = "img/icons/greenCircle.png";
				break;
			default:
				pin.type = "GENERAL MESSAGE";
				iconUrl = "img/icons/orangeCircle.png";
				break;
		}

		// test "bad type" response
		// pin.type = "bullshit";

		 var marker = new google.maps.Marker({
        	position: new google.maps.LatLng(pin.latDegrees, pin.lonDegrees),
        	map: window.MAP.map,
        	icon: iconUrl
    	});
		marker.setVisible(window.UI.isMarkerVisible);
    	window.MAP.pickupMarkers.push(marker);
	}

	MapHandle.prototype.updateMap = function updateMap(lat, lon, zoom){
			window.UI.isMapLoaded = false;
		    var newcenter = new google.maps.LatLng(lat, lon);
        	window.MAP.map.panTo(newcenter);
	}

	MapHandle.prototype.toggleIcons = function toggleIcons(){
		console.log("toggle icons: "+window.MAP.pickupMarkers.length);
		if(window.UI.isMarkerVisible){
			window.UI.isMarkerVisible = false;
		}else{
			window.UI.isMarkerVisible = true;
		}
		for(var ii=0; ii<window.MAP.pickupMarkers.length; ii++){	
			window.MAP.pickupMarkers[ii].setVisible(window.UI.isMarkerVisible);		
		}
	}

	MapHandle.prototype.toggleHeatmap = function toggleHeatmap(){

	}

	MapHandle.prototype.setCurrentLat = function setCurrentLat(CurrentLat){
		this.currentLat = CurrentLat;
	}

	MapHandle.prototype.setCurrentLon = function setCurrentLon(CurrentLon){
		this.currentLon = CurrentLon;
	}

	MapHandle.prototype.setCurrentZoom = function setCurrentZoom(CurrentZoom){
		this.currentZoom = CurrentZoom;
	}

	MapHandle.prototype.setMarkerEvent = function setMarkerEvent(event){
		this.markerEvent = event;
	}

	MapHandle.prototype.getCurrentLat = function getCurrentLat(){
		return currentLat;
	}

	MapHandle.prototype.getCurrentLon = function getCurrentLon(){
		return this.currentLon;
	}

	MapHandle.prototype.getCurrentZoom = function getCurrentZoom(){
		return this.currentZoom;
	}

} //end MapHandle

function CommentsHandle(){
	this.scrollPosition = 0;

	CommentsHandle.prototype.init = function init(){
		// add the listener to our add comments button
	} // end init()

	// when the comments nest is scrolled to a position defined in index.html, more comments are added
	CommentsHandle.prototype.updateScroll = function updateScroll(element){
		// console.log("Scrolling");
		// var offset = window.pageYOffset;
		var offset = element.scrollTop - window.Comments.scrollPosition;
		if (offset > 90){
			window.Comments.scrollPosition += offset;
			// alert(window.UI.commentsNextPageUrl);
			window.ApiConnector.pullCommentData(null, window.UI.commentsNextPageUrl);
		}
	} // end updateScroll()

	// when the comments checkboxes are toggled, this turns the comments on or off
	CommentsHandle.prototype.toggleComments = function toggleComments(type){
		switch(type){
			case('forum'):
				var bubbleNodeList = document.getElementsByClassName('bubbleForum');
				if(document.getElementById("toggleForum").checked){
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "1";
 						bubbleNodeList[i].style.display = "block";
					}
				}else{
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "0";
 						bubbleNodeList[i].style.display = "none";
					}
				}
			break;
			case('needs'):
				var bubbleNodeList = document.getElementsByClassName('bubbleNeeds');
				if(document.getElementById("toggleNeeds").checked){
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "1";
 						bubbleNodeList[i].style.display = "block";
					}
				}else{
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "0";
 						bubbleNodeList[i].style.display = "none";
					}
				}
			break;
			case('message'):
				var bubbleNodeList = document.getElementsByClassName('bubbleMessage');
				if(document.getElementById("toggleMessages").checked){
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "1";
 						bubbleNodeList[i].style.display = "block";
					}
				}else{
					for (var i = 0; i < bubbleNodeList.length; ++i) {
						// bubbleNodeList[i].style.opacity = "0";
 						bubbleNodeList[i].style.display = "none";
					}
				}
			break;
		}
	} // end toggleComments()

	//  The user presses the submit button on the comment submission screen
	CommentsHandle.prototype.commentSubmission = function commentSubmission(commentType){

		var comment = new FCommment();
		comment.message = document.getElementById("dialogSliderTextarea").value;
		comment.pin = null;
		// comment.type = document.getElementById("comment_type").value;
		comment.type = commentType;
		// comment.type = document.getElementById('comment_type').value;

		var serializedComment = JSON.stringify(comment);
		console.log(serializedComment);

		window.ApiConnector.pushCommentData(serializedComment);

		//Return false to stop normal form submission form occuring
		return false;
	}
}

// class for managing the UI
function UiHandle(){
	this.currentDisplay = 1;
	this.isMarkerDisplayVisible = false;
	this.MOUSEDOWN_TIME;
	this.MOUSEUP_TIME;
	this.isMarkerVisible = true;
	this.isMapLoaded = false;

	this.scrollPosition = 0;

	this.isNavbarUp = true;
	this.isTopSliderUp = true;

	this.textInputIsVisible = false;

	this.isClockRunning = false;
	this.clockHrs = 00;
	this.clockMins = 00;
	this.clockSecs = 00;

	this.commentPurpose = -1;
	this.MARKER = 1; 
	this.COMMENT = 0;

	// for comment pagination
	this.commentsType = ""
	this.commentsNextPageUrl = "";
	this.commentsPrevPageUrl = "";

    UiHandle.prototype.init = function init(){

    	// top slider dropdown
    	document.getElementById("hamburger").addEventListener('mousedown', function(){UI.topSliderToggle();});

	    // controls the main panel movement
	    document.getElementById("timeSpentClockDigits").innerHTML = "0"+window.UI.clockHrs+":0"+window.UI.clockMins+":0"+window.UI.clockSecs;
	    document.getElementById("pan1").addEventListener('mousedown', function(){UI.setActiveDisplay(0);});
	    document.getElementById("pan2").addEventListener('mousedown', function(){UI.setActiveDisplay(1);});
	    document.getElementById("pan3").addEventListener('mousedown', function(){UI.setActiveDisplay(2);});
	    document.getElementById("panel1SlideDownContent").style.display = "block";

	    document.getElementById("navbarPullUpTab").addEventListener('mousedown', function(){
	    	window.UI.navbarSlideUp();
	    });

	    // the text input that slides up from the bottom
	    document.getElementById("dialogCommentOk").addEventListener('mousedown', function(){
	    	// prevent OK from being clicked if dialogSlider textarea is empty
	    	if(document.getElementById("dialogSliderTextarea").value == ""){
	    		alert("no message entered");
	    	}else{
		    	var userComment = document.getElementById("dialogSliderTextarea").value;
		    	switch(window.CURRENT_USER_INPUT_TYPE){
		    		case window.INPUT_TYPE.MARKER:
		    			window.MAP.addMarkerFromUi(document.getElementById("dialogSliderTextarea").value);
		    			window.UI.hideTextInput();
		    			window.UI.clearTextInput();
		    			break;
		    		case window.INPUT_TYPE.COMMENT:
		    			window.Comments.commentSubmission();
		    			window.UI.hideTextInput();
		    			window.UI.clearTextInput();
		    			break;
		    		default:
		    			alert("no content type");
		    			break;
		    	}
		    	document.getElementById("dialogSliderTextarea").value = ""
		   		window.UI.hideTextInput();
		    }
	    });
	    // cancel button
	    document.getElementById("dialogCommentCancel").addEventListener('mousedown', function(){window.UI.hideTextInput();});		
		
	} // end init

	UiHandle.prototype.clearTextInput = function clearTextInput(){
		document.getElementById("comment_type").value = "FORUM";
		document.getElementById("comment_message").value = "";
		document.getElementById("input_purpose").value = "";
		return false;
	}

	UiHandle.prototype.topSliderToggle = function topSliderToggle(){
		if (document.getElementById("topSlideDown").className.match("sliderDown")){
			window.UI.isTopSliderUp = true;
			document.getElementById("topSlideDown").className = "sliderUp";
		}else{
			window.UI.isTopSliderUp = false;
			document.getElementById("topSlideDown").className = "sliderDown";
		}
	}

	// start or stop the UI clock 
	UiHandle.prototype.toggleClockRun = function toggleClockRun(){
		if(window.UI.isClockRunning){
			// stop the clock
			console.log("stopping clock");
			clearInterval(window.UI.clockInterval);
			window.UI.clockInterval = null;
			window.UI.isClockRunning = false;
		}else{
			// start the clock
			console.log("starting clock");
			window.UI.clockInterval = setInterval(window.UI.updateClock, 1000);
			window.UI.isClockRunning = true;
		}
	}

	UiHandle.prototype.hideMarkerTypeSelect = function hideMarkerTypeSelect(){
		document.getElementById("markerTypeDialog").style.display = "none";
		window.UI.isMarkerDisplayVisible = false;
	}

	// shows the marker/comment type menu, and adds listeners to the buttons depending on their purpose
	UiHandle.prototype.showMarkerTypeSelect = function showMarkerTypeSelect(){
		if(window.CURRENT_USER_INPUT_TYPE == window.INPUT_TYPE.COMMENT){
			window.UI.topSliderToggle();
			// add marker type selectors
			alert("comment");
		    document.getElementById("selectPickup").addEventListener('mousedown', function(){window.Comments.commentSubmission("trash pickup")});
		    document.getElementById("selectComment").addEventListener('mousedown', function(){window.Comments.commentSubmission("general message")});
		    document.getElementById("selectTrash").addEventListener('mousedown', function(){window.Comments.commentSubmission("help needed")});

		}else{
			// add marker type selectors
			alert("marker");
		    document.getElementById("selectPickup").addEventListener('mousedown', function(){window.UI.markerTypeSelect("trash pickup")});
		    document.getElementById("selectComment").addEventListener('mousedown', function(){window.UI.markerTypeSelect("general message")});
		    document.getElementById("selectTrash").addEventListener('mousedown', function(){window.UI.markerTypeSelect("help needed")});
		}
		
		document.getElementById("cancel").addEventListener('mousedown', function(){
	    	window.UI.hideMarkerTypeSelect();
	    });
		
		document.getElementById("markerTypeDialog").style.display = "block";
		window.UI.isMarkerDisplayVisible = true;
	}

	// sets the color of the front page button
	UiHandle.prototype.setBigButtonColor = function setBigButtonColor(colorHex){
		document.getElementById('startButton').style.backgroundColor=colorHex;
	}
	// sets the text of the front page start cleaning button
	UiHandle.prototype.setBigButtonText = function setBigButtonText(buttonText){
		document.getElementById('startButton').innerHTML = buttonText;
	}

	// called after the map has loaded, and hides the loading screen
	UiHandle.prototype.setMapLoaded = function setMapLoaded(){
		window.MAP.isMapLoaded = true;
		window.LS.hide();
	}

	// centers the appropriate panels (main display panels)
	UiHandle.prototype.setActiveDisplay = function setActiveDisplay(displayNum){
		var container = document.getElementById("container");
		if(displayNum != window.UI.currentDisplay){
			if(window.UI.isMarkerDisplayVisible){
				window.UI.hideMarkerTypeSelect();
			}
			if(window.UI.textInputIsVisible){
				window.UI.hideTextInput();
			}
			if(!window.UI.isTopSliderUp){
				window.UI.topSliderToggle();
			}
		}
		container.className = "";
		switch(displayNum){
			case 0:
				this.currentDisplay = 1;
				document.getElementById("panel2SlideDownContent").style.display = "none";
				document.getElementById("panel3SlideDownContent").style.display = "none";
				document.getElementById("panel1SlideDownContent").style.display = "block";
				container.className = "panel1Center";
			break;
			case 1:
				this.currentDisplay = 2;
				document.getElementById("panel1SlideDownContent").style.display = "none";
				document.getElementById("panel3SlideDownContent").style.display = "none";
				document.getElementById("panel2SlideDownContent").style.display = "block";
				container.className = "panel2Center";
			break;
			case 2:
				this.currentDisplay = 3;
				document.getElementById("panel1SlideDownContent").style.display = "none";
				document.getElementById("panel2SlideDownContent").style.display = "none";
				document.getElementById("panel3SlideDownContent").style.display = "block";
				this.navbarSlideDown();
				container.className = "panel3Center";
			break;
			default:
				this.currentDisplay = 1;
				document.getElementById("panel2SlideDownContent").style.display = "none";
				document.getElementById("panel3SlideDownContent").style.display = "none";
				document.getElementById("panel1SlideDownContent").style.display = "block";
				container.className = "panel1Center";

		}
	}

	// drops the 3-button navbar down for more reading room
	// currently only used on comments page
	UiHandle.prototype.navbarSlideDown = function navbarSlideDown(){
		window.UI.isNavbarUp = false;
		document.getElementById("navContainer").style.top = "100%";
	}
	// raises the navbar 3-button ui 
	UiHandle.prototype.navbarSlideUp = function navbarSlideUp(){
		window.UI.isNavbarUp = true;
		document.getElementById("navContainer").style.top = "86%";
	}

	// when the user chooses which type of marker to add to the map
	UiHandle.prototype.markerTypeSelect = function markerTypeSelect(markerType){
		console.log(markerType);
		// first we need to show the marker on the map
		// var iconUrl = "img/icons/blueCircle.png";
		var iconUrl = "";
		switch(markerType){
			case "forum":
				iconUrl = "img/icons/orangeCircle.png";
				break;
			case "trash pickup":
				iconUrl = "img/icons/blueCircle.png";
				break;
			case "help needed":
				iconUrl = "img/icons/greenCircle.png";
				break;
			default:
				iconUrl = "img/icons/orangeCircle.png";
				break;
		}

		window.MAP.markerType = markerType;

		// console.log(window.MAP.markerEvent);

		var marker = new google.maps.Marker({
        	position: new google.maps.LatLng(window.MAP.markerEvent.latLng.mb, window.MAP.markerEvent.latLng.nb),
        	map: window.MAP.map,
        	icon: iconUrl
    	});
		marker.setVisible(window.UI.isMarkerVisible);
    	window.MAP.pickupMarkers.push(marker);



		window.UI.hideMarkerTypeSelect();
		window.CURRENT_USER_INPUT_TYPE = INPUT_TYPE.MARKER;
		window.UI.showTextInput();
		// (bug) here we need to prevent more map touches
	}

	// text to get user input
	UiHandle.prototype.showTextInput = function showTextInput(){
		window.UI.textInputIsVisible = true;
		if(window.CURRENT_USER_INPUT_TYPE == window.INPUT_TYPE.COMMENT){
			document.getElementById("input_purpose").value == window.UI.COMMENT;
		}else{
			google.maps.event.addListener(window.MAP.map, 'mousedown', function(e){
				e.cancelBubble = true; 
  				if (e.stopPropagation) e.stopPropagation(); 
			});
			document.getElementById("input_purpose").value == window.UI.MARKER;
		}


		if(window.UI.isNavbarUp){
			document.getElementById("dialogSlider").style.top = "72%";
		}else{
			document.getElementById("dialogSlider").style.top = "80%";
		}
		document.getElementById("dialogSlider").style.opacity = "1.0";
		document.getElementById("dialogSliderTextarea").focus();

	}

	// hide the user text input dialog
	UiHandle.prototype.hideTextInput = function hideTextInput(){
		window.UI.textInputIsVisible = false;
		document.getElementById("dialogSlider").style.top = "86%";
		document.getElementById("dialogSlider").style.opacity = "0.0";
	}

	// show the marker type select dialog
	UiHandle.prototype.mapTouchUp = function mapTouchUp(){
		// set the coords of the marker event
	    MOUSEUP_TIME = new Date().getTime() / 1000;
	    // if it was a short touch
	    if((MOUSEUP_TIME - this.MOUSEDOWN_TIME) < 0.3){
	    	// check if the marker select menu is showing and toggle appropriately
	        if(this.isMarkerDisplayVisible){
	        	window.CURRENT_USER_INPUT_TYPE = window.INPUT_TYPE.MARKER;
	        	window.UI.hideMarkerTypeSelect();
	        }else{
	        	window.CURRENT_USER_INPUT_TYPE = window.INPUT_TYPE.MARKER;
	        	window.UI.showMarkerTypeSelect();
	        }

	        this.MOUSEDOWN_TIME =0;
	        this.MOUSEDOWN_TIME =0;
	    }else{
	        this.MOUSEDOWN_TIME =0;
	        this.MOUSEDOWN_TIME =0;
	    }
	}

	// track how long the user's finger was toucking to determine click while allowing map to be usable (touch-scroll)
	UiHandle.prototype.mapTouchDown = function mapTouchDown(event){
		// set the coords of the marker event
		if(!window.UI.textInputIsVisible){
		    window.MAP.markerEvent = event;
		    this.MOUSEDOWN_TIME = new Date().getTime() / 1000;
		}
	}

	// ******* DOM updaters (callbacks for the ApiConnector pull methods) *********** 
	UiHandle.prototype.updateHeatmap = function updateHeatmap(data){
		console.log("Heatmap data returned from api, preparing to apply data to map.");
		window.MAP.applyHeatMap(data);
	}

	// markers coming from the apiconnector comes here to be added to the UI
	UiHandle.prototype.updateMarker = function updateMarker(data){
		console.log("marker response: "+data);
		var dataArr = eval("("+data+")");
        for(ii=0; ii<dataArr.length; ii++){
            window.MAP.addMarkerFromApi(dataArr[ii].type, dataArr[ii].message, dataArr[ii].latDegrees, dataArr[ii].lonDegrees);
        }

	}

	// data is passed from the api connector to here to update the forum.
	UiHandle.prototype.updateForum = function updateForum(data){
		console.log("In Update forum");
		// console.log("Comment data: "+data);
		// document.getElementById("bubbleContainer").innerHTML = "";
		var dataObj = JSON.parse(data);
		var comments = dataObj.comments;
		// window.UI.commentsPrevPageUrl = dataObj.page.previous;
		// window.UI.commentsNextPageUrl = dataObj.page.next;
		if(dataObj.page.next != null){
			var nextArr = dataObj.page.next.split("greenupapp.appspot.com/api");
			window.UI.commentsNextPageUrl = window.ApiConnector.BASE+"/"+nextArr[1];
		}else{
			window.UI.commentsNextPageUrl = null;
		}
		if(dataObj.page.previous != null){
			var prevArr = dataObj.page.previous.split("greenupapp.appspot.com/api");
			window.UI.commentsPrevPageUrl = window.ApiConnector.BASE+"/"+prevArr[1];
		}else{
			window.UI.commentsPrevPageUrl = null;
		}

		for(var ii=0; ii<comments.length; ii++){
				var div = document.createElement("div");
				var timeDiv = document.createElement("div");
				var messageContent = document.createElement("span");
				var currentDate = new Date();
				var timezoneOffsetMillis = currentDate.getTimezoneOffset()*60*1000;
				var messageDate = new Date(comments[ii]['timestamp']);
				var diffMins = Math.round((((timezoneOffsetMillis + currentDate.getTime()) - messageDate.getTime())/1000)/60);
				if(diffMins > 59){
					var mins = (diffMins % 60);
					var timeSinceMessage = ((diffMins - mins)/60)+"hrs, "+mins+"mins ago"; 
				}else{
					var timeSinceMessage = diffMins+"mins ago"; 
				}
				
				messageContent.innerHTML = comments[ii]['message'];
				timeDiv.innerHTML = timeSinceMessage;
				timeDiv.className = "bubbleTime";
				if(ii % 2 == 0){
					div.className = "bubbleRight bubble"; 
				}else{
					div.className = "bubbleLeft bubble";
				}

				switch(comments[ii]['type']){
					case 'FORUM':
						div.className += " bubbleForum";
					break;
					case 'needs':
						div.className += " bubbleNeeds";
					break;
					case 'message':
						div.className += " bubbleMessage";
					break;
					default:
						div.className += " bubbleForum";
					break;
				}
				div.appendChild(timeDiv);
				div.appendChild(messageContent);
				document.getElementById("bubbleContainer").appendChild(div);

		}
	}


	// updates the clock over time
	UiHandle.prototype.updateClock = function updateClock(){
		if(window.UI.clockSecs == 59){
			window.UI.clockSecs = 00;
			if(window.UI.clockMins == 59){
				window.UI.clockMins = 00;
				window.UI.clockHrs++;
			}else{
				window.UI.clockMins++;
			}
		}else{
			window.UI.clockSecs++;
		}
		var clockSecStr = (window.UI.clockSecs < 10) ? "0"+window.UI.clockSecs : window.UI.clockSecs;
		var clockMinStr = (window.UI.clockMins < 10) ? "0"+window.UI.clockMins : window.UI.clockMins;
		var clockHrStr = (window.UI.clockHrs < 10) ? "0"+window.UI.clockHrs : window.UI.clockHrs;
		
		document.getElementById("timeSpentClockDigits").innerHTML = clockHrStr + ":" + clockMinStr + ":" + clockSecStr;
	}
	// ******** End DOM Updaters *********

	// ---- begin COMMENT pagination control toggle ----
	UiHandle.prototype.showNextCommentsButton = function showNextCommentsButton(){
		document.getElementById("nextPage").style.display = "inline-block";
	}

	UiHandle.prototype.hideNextCommentsButton = function hideNextCommentsButton(){
		document.getElementById("nextPage").style.display = "none";
	}

	UiHandle.prototype.showPrevCommentsButton = function showPrevCommentsButton(){
		document.getElementById("prevPage").style.display = "inline-block";
	}

	UiHandle.prototype.hidePrevCommentsButton = function hidePrevCommentsButton(){
		document.getElementById("prevPage").style.display = "none";
	}
	// ---- end COMMENT pagination control toggle


	// mock callback function for logging data that would ordinarily hit one of the UI updates
	UiHandle.prototype.updateTest = function updateTest(data){
		console.log(data);
	}

} // end UiHandle class def

// prototype objects for posting to API
function Pin(){
	this.latDegrees; 
    this.lonDegrees;
    this.type; 
    this.message = "I had to run to feed my cat, had to leave my Trash here sorry! Can someone pick it up?";
}


//We cannot call this Comment because it's reserved by javascript
function FCommment(){
	this.message ="FORUM";
	this.pin = null;
	this.type = "";
}

function INPUT_TYPE(){
	this.NONE  = -1;
	this.PIN = 0;
	this.MARKER = 0;
	this.COMMENT = 1;
}

// logger for reporting problems to the server
function ClientLogger(){
	ClientLogger.prototype.logEvent = function logEvent(eventString){

	}
}


/**
* This is where all the action begins (once content is loaded)
* @author Josh
*/
document.addEventListener('DOMContentLoaded',function(){
	window.INPUT_TYPE = new INPUT_TYPE();
	window.DEBUG = false;
	// are we currently logging GPS data?
	window.logging = false;


	// what type of user content are we taking in
	window.CURRENT_USER_INPUT_TYPE = -1;

	// dealing with touch ui shit
	document.addEventListener("touchmove", function(e){e.preventDefault();}, false);
	document.addEventListener("touchstart", function(){}, true);

	// instansiate the api
	window.ApiConnector = new ApiConnector();
	// instansiate the forum
	window.Comments = new CommentsHandle();
	// instansiate /initialize the UI controls
	window.UI = new UiHandle();
	window.UI.init();
	//	instansiate the loading screen dialog 
	window.LS = new LoadingScreen(document.getElementById("loadingScreen"));
	// fire up the GPS logger
	window.GPS = new GpsHandle();
	// build out the google map
	window.MAP = new MapHandle();
	window.MAP.initMap();
	// grab our comments, map markers, and heatmap data
	window.ApiConnector.pullCommentData();
	window.ApiConnector.pullMarkerData();
	window.ApiConnector.pullHeatmapData();
	// wait for the user to click the big start/stop button
	document.getElementById("startButton").addEventListener('mousedown', function(){
		if(!window.logging){
			window.UI.toggleClockRun(); 
			window.GPS.start();
		}else{
			window.GPS.stop();
			window.UI.toggleClockRun();
		}
	});

});

