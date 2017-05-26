// This function is called by the Genero Client Container
// so the web component can initialize itself and initialize
// the gICAPI handlers
onICHostReady = function(version) {
   if ( version != 1.0 ) {
      alert('Invalid API version');
      return;
   }

   // Initialize the focus handler called by the Genero Client
   // Container when the DVM set/remove the focus to/from the
   // component
   gICAPI.onFocus = function(polarity) {
      /* looks bad on IOS, we need to add a possibility to know the client
      if ( polarity ) {
         document.body.style.border = '1px solid blue';
      } else {
         document.body.style.border = '1px solid grey';
      }
      */
   }
            
   gICAPI.onData = function(data) {
     signaturePath = data;
     p.setAttribute('d', data);
   }
   

   gICAPI.onProperty = function(property) {
   }

}