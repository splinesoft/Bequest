# Bequest

Bequest is an **[iOS app]** of type **[developer utility]** that **[creates and replays HTTP/S requests]**.

### Major goals:

1. Universal app (iPhone and iPad)
2. 99% Swift (excluding Pods)
3. Developed and maintained open-source at this location
4. Released on the App Store for the gasp-inducingly phone-grabbingly TouchID-pressingly price of $0.99

(Are goals 3 and 4 mutually exclusive? Stay tuned to find out!)

### Major features:

* Create an HTTP/S request with:
     * A **URL**
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
* Display and restore saved requests 

### Nice to have:

* Search saved requests by URL, header, parameter
* Syntax highlighting for response text
* Prettify/auto-indent response JSON/XML
* CloudKit as saved request storage
* Something nicer to look at than a spinner and text label while it's loading
* A slick app icon with a "B" and an arrow or something EVEN CRAZIER

### Yacht features:

(As in, we'll build them from the deck of our yacht that we bought after releasing Bequest)

* Response asset loading timeline (waterfall)

### Brought to you by:

* [Jonathan Hersh](https://github.com/jhersh)
* ...
