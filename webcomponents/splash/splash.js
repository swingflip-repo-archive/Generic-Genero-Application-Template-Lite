onICHostReady = function(version) {

   if ( version != 1.0 ) {
      alert('Invalid API version');
   }

   gICAPI.onProperty = function(properties) {
      var ps = JSON.parse(properties);
      if (ps.url!="") {
        setTimeout( function () {
          downloadURL(ps.url);
        }, 0);
      }
   }

}

var lang
var banner_image
var loading_string
var powered_by_string

setLocale("FR");

function setLocale(lang_short_code) {
  lang = lang_short_code;
  //lang = JSON.stringify(lang_short_code);
  lang = lang.toUpperCase();
  
  if (lang == "EN") {
    banner_image = "banner.png";
    loading_string = "Loading...";
    powered_by_string = "Powered by...";
  } else if (lang == "FR") {
    banner_image = "banner.png";
    loading_string = "Chargement...";
    powered_by_string = "Alimenté par...";
  }
  document.write
  (" \
    <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"> \
    <html style=\"width: 100%; height: 100%; background-color:#FFFFFF;\"> \
      <head> \
          <meta content=\"text/html; charset=UTF-8\" http-equiv=\"content-type\"> \
          <title></title> \
          <link rel=\"stylesheet\" type=\"text/css\" href=\"splash.css\" /> \
      </head> \
      <body> \
        <div style=\"display:table; height:100%; width:100%;\"> \
          <div style=\"display:table-cell;vertical-align:middle; width:100%; text-align:center;\"> \
            <div style=\"margin-left:auto;margin-right:auto;\"> \
                <img src=\"" + banner_image + "\" width=\"75%\" /><br /> \
                <h1 style=\"font-size: 200%;\">" + powered_by_string + "</h1> \
                <img src=\"genero.png\" width=\"40%\" /><br /><br /> \
                <h1 style=\"font-size: 250%;\">" + loading_string + "</h1><br /> \
                <img src=\"box.gif\" /><br /> \
            </div> \
          </div> \
        </div> \
      </body> \
    </html> \
  ")
  return "OK";
}