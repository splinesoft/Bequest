## Bequest

Bequest is an [iOS app] of type [developer utility] that [creates and replays HTTP/S requests].

Major goals for Bequest:

1. Universal app (iPhone and iPad)
2. 99% Swift (excluding Pods)
3. Developed and maintained open-source at this location
4. Released on the App Store for the gasp-inducingly phone-grabbingly TouchID-pressingly price of $0.99

(Are items 3 and 4 mutually exclusive? Stay tuned to find out!)

Major features for Bequest:

* Create an HTTP/S request with:
     * A **method** (`GET`, `POST`, `PATCH`, etc. or any custom value)
     * Zero or more **headers**
     * Zero or more **parameters**
     * ...
* View the response including:
     * Headers
     * Text contents
     * An option to render the response in a webview
     * Open in other apps(?)
* Save the request to be replayed later
* Display and open saved requests 

Nice to have:

* Syntax highlighting 
* Prettify/auto-indent for JSON/XML
* CloudKit as request storage
* Something nicer to look at than a spinner and text label while it's loading
* A slick app icon with a "B" and an arrow or something EVEN CRAZIER

Yacht features (as in, we'll build it from the deck of our yacht that we bought after releasing Bequest):

* Response asset loading timeline (waterfall)

Brought to you by:

* [Jonathan Hersh](https://github.com/jhersh)
* ...
