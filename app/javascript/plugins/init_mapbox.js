import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';
const key = process.env.MAPBOX_API_KEY

const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v10',
  });
};

const addMarkersToMap = (map, markers) => {
  const tag_coords = document.getElementById("current-user-coordinates")
  const lat = tag_coords.dataset.lat
  const long = tag_coords.dataset.long

  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(`
      <h3>${marker.name}</h3>
        <p>${marker.full_address}</p>
        <p>
          <img
            src="${marker.image_url}"
            alt="Photo from ${marker.name}"
            width="100%"
            height="100%"
          >
          </img>
        </p>
        <a
          href="https://waze.com/ul?directions?navigate=yes&to=ll.${marker.latitude}%2C${marker.longitude}&from=ll.${lat}%2C${long}"
          class="btn-waze">
          Dirigir até o local
        </a>
    `);

    // Create a HTML element for your custom marker
    const element = document.createElement('div');
    element.className = 'marker';
    element.style.backgroundSize = 'contain';
    element.style.width = '25px';
    element.style.height = '25px';

    // Pass the element as an argument to the new marker
    new mapboxgl.Marker(element)
      .setLngLat([marker.longitude, marker.latitude])
      .setPopup(popup)
      .addTo(map);
  });
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

    geolocate.on('geolocate', function (e) {
      const long = e.coords.longitude;
      const lat = e.coords.latitude
      const position = [long, lat];
      $.ajax({
        url: "/fetch_position",
        type: "POST",
        data: { data_coordinates: position }
      });
    });

    addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);

    map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    }));

    map.on('load', function () {
      geolocate.trigger(); //<- Automatically activates geolocation
    });
  }
}

export { initMapbox };
