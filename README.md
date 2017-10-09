![GGAT](http://i.imgur.com/b4dLZz7.png)
# Generic Genero Application Template
A purpose built application template to assist developers develop a cross platform application which will work in GDC, GMA, GMI and GBC. 

[![Powered By Genero](http://i.imgur.com/m0vHCJl.png)](http://4js.com/products/)&nbsp;&nbsp;&nbsp;&nbsp;[![Built by Ryan Hamlin](http://i.imgur.com/24Bf8Ql.png)](http://www.ryanhamlin.co.uk)

GGAT (Generic Genero Application Template) is an universial application base which has been designed to assist developers in developing cross platform applications by providing the basis and the necessary tools for a Genero based app. It also comes bundled with tech demos and many other features which are useful to test out new environments and give developers examples on cool features within Genero.  

GGAT was built using Genero Studio 3.10.xx and has been coded and thoroughly tested to work on most available platforms:
  - Mircosoft Windows
  - Apple Mac OS X
  - Apple iOS Devices
  - Android Devices
  - Javascript enabled web browsers

### GGAT's Main Features
  - Fully structured GST project with all configs already set up. Just compile and go!
  - Built in app and db maintenance tools with DB modification scripts.
  - Modular design to enable developers to build on top of GGAT without lots of setup.
  - Multitude of different configurable settings to change the way the application functions.
  - Pre built Javascript and Jquery plugins with examples on how to implement your own.
  - Over 1000 built in truetype font icons ready to use within your applications Including FontAwesome and FlatIcons
  - Full localisation support. (Comes with English and French Language packs by default)
  - Local SQLite3 database which houses encyrpted logins and device logs.
  - Bundled with a basic PHP nuSOAP webservice which showcases the use of webservices and Genero whilst online and offline

### GGAT's Demo Functionaility 
  - Local Login facility (Uses local SQLlite DB within the application and encrypts data using bCrypt)
  - Local user support (also includes user types i.e. Admins and Users)
  - Automated Connectivity Checks (Automatic connection detection to detect when device is online or offline)
  - Camera Upload Demo (Take or select photos from your device and upload them to a webservice using base64 payloads)
  - Interactivity Demo (Multiple Javascript & jQuery plugin demos)
    - Youtube Video Player
    - Signature Capture Demo
    - Google Maps Integration Demo
    - Minesweeper Game Demo (90% complete...I'm intending on make this it's own project)
  - Admin controls (add users, remove users and other basic admin functions) 
  - Specific User Type or Device accessable areas
  - Network synchronisation tools for end user

### Tech and what's involved...

GGAT uses a number of open source projects and platforms to work properly:

* 4GL
* FourJs Genero Suite
* SQLite3
* PHP
* nuSOAP
* jQuery
* Javascript
* HTML5
* CSS3
* FlatIcon and FontAwesome

And of course GGAT itself is open source with a [public repository](https://github.com/swingflip/Generic-Genero-Application-Template) on GitHub.

### Installation

To Develop using GGAT you must have a valid and active development license for Genero.

  1) Use your prefered GIT method and fork to your development machine...
  2) Open the GGAT GST project file `projectdir/GGAT.4pl`
  3) Hit Compile and Go! 
  
### Important Notes

When using GGAT please take note of the following:

* Make sure your GST langauge settings are set to UTF-8 to ensure cross platform compatibility
* Depending on what platform you are developing on, choose the correct FGLIMAGEPATH settings in the project environment settings (http://prntscr.com/gv8qaw)
* When deploying via GAS, there are two bundled .xcf files, a Linux and a Windows file. Make sure you use the correct file according to your gas server platform. You might want to check the xcf file settings to ensure they match your server configuration

### Configuration 

GGAT comes packed with a load of different configurable variables for you to tweak to adapt the template so it will function the way you want it. Currently the configurable variables are listed below:

```
    #Application Information
        g_application_title STRING,            #Application Title
        g_application_version STRING,          #Application Version
        g_application_about STRING,            #Application About Blurb
        g_application_database_ver INTEGER,    #Application Database Version (This is useful to force database additions to pre-existing db instances) 

    #Webservice variables
        g_client_key STRING,                  #Unique Client key for webservice purposes
        g_image_dest STRING,                  #Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet, because you should be able to fglWSDL this is pretty redundant)
        g_ws_end_point STRING,                #The webservice end point. 
        
    #Application Image variables
        g_splash_width STRING,                #Login menu splash width when not in mobile
        g_splash_height STRING,               #Login menu splash height when not in mobile

    #Application on/off toggles
        g_enable_geolocation SMALLINT,        #Toggle to enable geolocation
        g_enable_mobile_title SMALLINT,       #Toggle application title on mobile

    #Timed event toggles and variables
        g_timed_checks_time INTEGER,          #Time in seconds before running auto checks, uploads or refreshes (0 disables this globally)
        g_enable_timed_connect SMALLINT,      #Enable timed connectivity checks
        g_enable_timed_image_upload SMALLINT, #Enable timed image queue uploads (Could have a performance impact!)

    #General application variables
        g_enable_splash SMALLINT,             #Open splashscreen when opening the application.
        g_splash_duration SMALLINT,           #Splashscreen duration (seconds) g_enable_splash needs to be enabled!
        g_enable_login SMALLINT,              #Boot in to login menu or straight into application (open_application())
        g_local_stat_limit INTEGER,           #Number of max local stat records before pruning
        g_online_ping_URL STRING,             #URL of public site to test internet connectivity (i.e. http://www.google.com)
        g_date_format STRING                  #Datetime format. i.e. "%d/%m/%Y %H:%M"
```
To set the values of the config variables look for the `initialize_globals()` function which is located near the top of `main.4gl`

I have included numerous notes within the source code to help devs understand how it all works.

### Documentation

Coming soon! (I Promise)

### Development

Want to contribute? Great!

Please feel free to fork GGAT and make your own improvements and send me a pull request. I developed GGAT to help developers and my own personal application development within Genero. If you think you can improve GGAT then please do!

### Contact Me!
If you have any questions, suggestions or enquiries then don't hesitate to contact me! You can reach me via email at: [ryan@ryanhamlin.co.uk](mailto:ryan@ryanhamlin.co.uk)
OR
you can catch me on Skype during office hours @ ryan.hamlin2014

### Credit
**Development, Lead Testing, Graphic Design** - Ryan Hamlin (http://www.ryanhamlin.co.uk)
**Software Platform Provider and Support** - FourJs (http://4js.com)
**FontAwesome Icon Set** - Dave Gandy (http://fontawesome.io/)
**FlatIcon Icon Set** - Madebyoliver (http://www.flaticon.com/)
### License and Legal

[FlatIcon Free Use License](https://profile.flaticon.com/license/free)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


