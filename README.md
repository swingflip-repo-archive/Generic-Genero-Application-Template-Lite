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

### NEW "Lite" Version available!
The new Lite version of GGAT comes without any of the demos and comes with the bare bones basics making it a perfect template for your mobile applications. You can find the "lite" version by clicking on the icon below...
[![GGAT Standard Version](https://i.imgur.com/BIDaNRF.png)](https://github.com/swingflip/Generic-Genero-Application-Template)&nbsp;&nbsp;[![GGAT Lite Version](https://i.imgur.com/zcEMnbm.png)](https://github.com/swingflip/Generic-Genero-Application-Template-Lite)

Standard Version Repo&nbsp;&nbsp;Lite Version


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
{
    "g_application_database_ver": 1,
    "g_client_key": "znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv",
    "g_image_dest": "webserver1",
    "g_ws_end_point": "http://www.ryanhamlin.co.uk/ws",
    "g_splash_width": "500px",
    "g_splash_height": "281px",
    "g_enable_geolocation": 0,
    "g_enable_mobile_title": 0,
    "g_timed_checks_time": 10,
    "g_enable_timed_connect": 1,
    "g_enable_timed_image_upload": 1,
    "g_enable_splash": 1,
    "g_splash_duration": 4,
    "g_enable_login": 1,
    "g_local_stat_limit": 100,
    "g_online_ping_URL": "http://www.google.com",
    "g_date_format": "%d/%m/%Y %H:%M",
    "g_default_language": "EN",
    "g_local_images_available": ["EN","FR"]
}
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


