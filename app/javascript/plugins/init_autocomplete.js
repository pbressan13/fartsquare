import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.querySelectorAll(".mapboxgl-popup-content > p")
  if (addressInput) {
    places({ container: addressInput });
  }
};

export { initAutocomplete };
