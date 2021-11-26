import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    var geolocate = new mapboxgl.GeolocateControl({
      positionOptions: {
        enableHighAccuracy: true
      },
      trackUserLocation: true
    });
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10',
      center: [-23.5517186, -46.6892309], // starting position
      zoom: 3 // starting zoom
    });
    map.addControl(geolocate);
    map.on('load', function () {
      geolocate.trigger(); //<- Automatically activates geolocation
      $.ajax({
        dataType: 'text',
        url: '/map',
        success: function (data) {
          var myjson;
          geojson = JSON.parse(data);
          var geojson = {
            type: 'FeatureCollection',
            features: myjson
          };

          // add markers to map
          geojson.forEach(function (marker) {

            // create a HTML element for each feature
            var el = document.createElement('div');
            el.className = 'geomarker';

            // make a marker for each feature and add to the map
            new mapboxgl.Marker(el)
              .setLngLat(marker.geometry.coordinates)
              .setPopup(new mapboxgl.Popup({ offset: 25 }) // add popups
                .setHTML('<a href="/establishment/' + marker.properties.id + '"><div class="row popup-bckg ml-0 mt-2 mb-0 align-items-end rounded" style="background-image:url(' + marker.properties.image + ')">' +
                  '<div class="w-100 row ml-0 marker-title rounded-bottom"><div class="col-9"><h4 class="mb-0"><strong>' + marker.properties.title + '</strong></h4><small>' + marker.properties.address + '</small></div>' +
                  '<div class="row justify-content-center"><div class="col-11"><hr class="mb-2 mt-1"/><p>' + marker.properties.title + '</p></div></div>'))
              .addTo(map);
          });
        },
        error: function () {
          alert("Could not load the events");
        }
      });
    });
  }
}

export { initMapbox };
