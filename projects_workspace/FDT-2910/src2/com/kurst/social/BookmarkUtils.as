package com.kurst.social {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * Posts links to various social networks
	 * @author Devon O. Wolfgang
	 */
	public class BookmarkUtils {
		public static const DIGG : String = "digg";
		public static const FACEBOOK : String = "faceBook";
		public static const GOOGLE_BOOKMARK : String = "googleBookmark";
		public static const MYSPACE : String = "myspace";
		public static const STUMBLE_UPON : String = "stumbleUpon";
		public static const TECHNORATI : String = "technorati";
		public static const TWITTER : String = "twitter";
		public static const YAHOO_BOOKMARK : String = "yahooBookmark";
		public static const LINKED_IN_BOOKMARK : String = "linkedinBookmark";

		public function BookmarkUtils() { /* do not instantiate - use static method post() */
		}

		public static function post(to : String, link : String, title : String = "") : void {
			link = encodeURI(link);
			title = encodeURI(title);

			var request : URLRequest = new URLRequest();
			request.method = URLRequestMethod.GET;

			switch (to) {
				case DIGG :
					request.url = "http://digg.com/submit?phase=2&url=" + link + "&title=" + title;
					break;
				case FACEBOOK :
					request.url = "http://www.facebook.com/sharer.php?u=" + link;
					break;
				case GOOGLE_BOOKMARK :
					request.url = "http://www.google.com/bookmarks/mark?op=add&bkmk=" + link + "&title=" + title;
					break;
				case MYSPACE :
					request.url = "http://www.myspace.com/Modules/PostTo/Pages/?u=" + link + "&t=" + title;
					break;
				case STUMBLE_UPON :
					request.url = "http://www.stumbleupon.com/submit?url=" + link;
					break;
				case TECHNORATI :
					request.url = "http://technorati.com/faves/?add=" + link;
					break;
				case TWITTER :
					request.url = "http://twitter.com/home?status=" + link;
					break;
				case YAHOO_BOOKMARK :
					request.url = "http://myweb2.search.yahoo.com/myresults/bookmarklet?u=" + link + "&t=" + title;
					break;
				case LINKED_IN_BOOKMARK :
					// <%=strURL%>&amp;title=<%=strTitle %>
					request.url = "http://www.linkedin.com/shareArticle?mini=true&url=" + link + "&title=" + title;
					break;
				default :
					break;
			}

			navigateToURL(request, "_blank");
		}
	}
}
