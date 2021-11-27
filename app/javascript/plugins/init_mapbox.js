import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
const key = process.env.MAPBOX_API_KEY




const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v10',
  });
};

//const addMarkersToMap = (map, markers) => {
//  markers.forEach((marker) => {
//    new mapboxgl.Marker()
//      .setLngLat([marker.longitude, marker.latitude])
//      .addTo(map);
//  });
//};

const addMarkersToMap = (map, markers) => {
    new mapboxgl.Marker()
      .setLngLat([markers[0], markers[1]])
      .addTo(map);
};


const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([marker.longitude, marker.latitude]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
};

const geolocate = new mapboxgl.GeolocateControl({
  positionOptions: {
    enableHighAccuracy: true
  },
  trackUserLocation: true
});

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    const map = buildMap(mapElement);
    map.addControl(geolocate);
    const markers = JSON.parse(mapElement.dataset.markers);
    //addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);
    map.on('load', function () {
      geolocate.trigger(); //<- Automatically activates geolocation
      const markers = JSON.parse(mapElement.dataset.markers);
      markers.forEach((marker) => {
        const el = document.createElement('div');
        el.className = 'marker';
        new mapboxgl.Marker(el)
          .setLngLat([marker.longitude, marker.latitude])
          .setPopup(
            new mapboxgl.Popup({ offset: 25 }) // add popups
              .setHTML(
                `<h3>${marker.name}</h3><p>${marker.full_address}</p>`
              )
          )
          .addTo(map);
      });

    });

    const searchMap = (event) => {
      event.preventDefault();
      const address = document.getElementById("search_query").value;
      const baseUrl = `https://api.mapbox.com/geocoding/v5/mapbox.places/${address}.json?access_token=${key}`;
      console.log(baseUrl);
      console.log(address);
      fetch(`${baseUrl}`)
        .then(response => response.json())
        .then((data) => {
          console.log(data.features[0].center);
          const latlong = data.features[0].center;
          new mapboxgl.Marker()
            .setLngLat([latlong[0], latlong[1]])
            .setPopup(
              new mapboxgl.Popup({ offset: 25 }) // add popups
                .setHTML(
                  `<h3>${address}</h3>`
                )
            )
            .addTo(map);
          //addMarkersToMap(map, latlong);
        })
      };
    const searchButton = document.getElementById("searchbtn");
    searchButton.addEventListener("click", searchMap);
  }
}

//searchButton.addEventListener("click", searchMap);

export { initMapbox };
