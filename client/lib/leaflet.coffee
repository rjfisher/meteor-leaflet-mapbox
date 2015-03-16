@Leaflet =
  map: null
  currLocation: null
  sitesHandler: false

  initializeLayerList: ->
    return unless @map?

    overlays = {}
    _.each Layers, (l) ->
      overlays['<img src=' + l.img + '> ' + l.name] = l.data

    L.control.layers(null, overlays,
      collapsed: false
      position: 'topleft'
    ).addTo(@map)

  zoomToCounty: (county) ->
    return unless county?

    zoom = new L.LatLng(county.loc.lat, county.loc.lon)
    @map.setView(zoom, 11)

  onEachFeature: (feature, layer) ->
    popUpContent = "<strong>Planning Org:</strong><br> " +
     feature.properties.Planning_O + "<br><strong>Comment:</strong><br> " +
     feature.properties.Marker_Com + "<br><strong>Location:</strong><br> " +
     feature.properties.Location;
    if (feature.properties)
      layer.bindPopup(popUpContent)

  pointToLayer: (f, loc) ->
    return L.circleMarker(loc, Styles[f.properties.Marker_Typ])

  handleExtentChanged: ->
    b = @.getBounds()
    return unless b?

    bounds =
      a:
        x: b.getNorthEast().lat
        y: b.getSouthWest().lng
      b:
        x: b.getNorthEast().lat
        y: b.getNorthEast().lng
      c:
        x: b.getSouthWest().lat
        y: b.getNorthEast().lng
      d:
        x: b.getSouthWest().lat
        y: b.getSouthWest().lng

    query =
      bounds: bounds

    newsitesHandler = Meteor.subscribe('sites', query)
    if @sitesHandler
      @sitesHandler.stop()
    @sitesHandler = newsitesHandler

  initialize: ->
    map = L.map 'map', minZoom: 7
    map.setView [40.84, -77.83], 7
    map.setMaxBounds [[45, -86], [37, -69]]
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/mccormicktaylor.k2ijn48c/{z}/{x}/{y}.png', attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>').addTo map
    L.tileLayer('http://{s}.tiles.mapbox.com/v3/stevec.eat9be29/{z}/{x}/{y}.png').addTo(map);
    L.control.scale().addTo map

    _.each Layers, (layer) =>
      layer.data = L.geoJson(null,
        onEachFeature: @onEachFeature
        pointToLayer: @pointToLayer
      )

      layer.data.on 'click', (e) ->
        map.panTo(e.layer.getLatLng())

    map.on('moveend', @handleExtentChanged)

    @map = map

    @initializeLayerList()
