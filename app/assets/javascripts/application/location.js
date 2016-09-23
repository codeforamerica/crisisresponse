function ignoreEnterKey() {
  return !(window.event && window.event.keyCode == 13);
}

function initAutocomplete() {
  var element = document.getElementById("response_plan_location_address");
  $(element).on("keypress", ignoreEnterKey)

  if(element) {
    var autocomplete = new google.maps.places.Autocomplete(element, {
      types: ["geocode"],
    });
  }
}

function initMap() {
  initAutocomplete();

  var location_card = $(".profile-location");
  if(location_card.length == 0) return;

  var address = location_card.data("address");

  var geocoder = new google.maps.Geocoder();
  var mapMarkerIcon = {
    path: google.maps.SymbolPath.CIRCLE,
    scale: 12,
    fillColor: "rgb(255,0,128)",
    fillOpacity: 1,
    strokeOpacity: 0
  };

  geocoder.geocode({
    address: address,
    componentRestrictions: {
      country: 'US',
      administrativeArea: "King County, WA"
    }
  }, function(result) {
    var result = result[0];

    var map = setUpMap(result.geometry.location);

    $(".zoom-out").on("click", function() { map.setZoom(map.zoom - 1); });
    $(".zoom-in").on("click", function() { map.setZoom(map.zoom + 1); });
  });

  function setUpMap(location) {
    var mapElement = $(".location-map-canvas")[0];

    map = new google.maps.Map(mapElement, {
      center: location,
      zoom: 15,
      disableDefaultUI: true
    });

    var marker = new google.maps.Marker({
      position: location,
      map: map,
      icon: mapMarkerIcon
    });

    setTimeout(function() {
      $(".location-map").addClass("collapsed");
    }, 1000);

    return map;
  }
}
