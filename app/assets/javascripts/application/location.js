function initMap() {
  var location_card = $(".location");
  if(location_card.size() == 0) return;

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

    fillInAddress(result.formatted_address);
    var map = setUpMap(result.geometry.location);

    $(".zoom-out").on("click", function() { map.setZoom(map.zoom - 1); });
    $(".zoom-in").on("click", function() { map.setZoom(map.zoom + 1); });
  });

  function setUpMap(location) {
    var mapElement = $(".location-map")[0];

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

    return map;
  }

  function fillInAddress(address) {
    address_parts = address.split(", ");
    address_parts.pop(); // Remove country

    var line_one = address_parts.shift();
    var line_two = address_parts.join(", ");

    $(".location-address-line-one").text(line_one);
    $(".location-address-line-two").text(line_two);
  }
}
