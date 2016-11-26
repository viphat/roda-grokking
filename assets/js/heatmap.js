$(document).ready(function(){
  $('#datepicker1').datepicker();
  $('#filterBtn').click(function(){
    filterTopLocation();
  });
});

function filterTopLocation(){
  var top = $('#top').val();
  var date = $('#datepicker1').val();
  date = Date.parse(date) / 1000;
  getLocations(top, date);
}

function getLocations(top, date) {
  if ((top === null) || (top === undefined)) { top = 10; }
  if ((date === null) || (date === undefined)) { date = Date.now() / 1000; }
  $.get('/api/heatmap?top=' + top + '&date=' + date , function(data, status) {
    var myLatLng = new google.maps.LatLng(10.776889, 106.700806);
    var myOptions = {
      zoom: 4,
      center: myLatLng
    };
    map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);
    heatmap = new HeatmapOverlay(map,{
      "radius": 0.6,
      "maxOpacity": 0.5,
      "scaleRadius": true,
      "useLocalExtrema": true,
      latField: 'lat',
      lngField: 'lng',
      valudField: 'count'
    });
    var mapData = {
      data: data.locations
    };
    heatmap.setData(mapData);
  });
}
