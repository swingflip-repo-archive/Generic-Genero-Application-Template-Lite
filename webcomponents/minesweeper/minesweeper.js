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

function new_game(difficulty) {
    document.getElementById("smiley_element").style.background = "#c0c0c0 url('happy.png') center no-repeat";
    document.getElementById("smiley_element").style.backgroundSize  = "cover";

    var element = document.getElementById('level');
    element.value = difficulty;

    $("#newGame").click()
}