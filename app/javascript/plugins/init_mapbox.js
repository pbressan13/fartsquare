import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/light-v10',
  });
};

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    new mapboxgl.Marker()
      .setLngLat([marker.longitude, marker.latitude])
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
  }
}

export { initMapbox };
