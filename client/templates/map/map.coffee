Template.home.rendered = ->
  Leaflet.initialize() unless Session.get 'map'

  _.each(Layers, (layer) ->
    LiveLeaflet.addDataToMap(layer.data, [
      cursor: Sites.find('Marker_Typ': layer.type)
      transform: (site) ->
        obj =
          "type": "Feature",
          "properties":
            'Planning_O': site.Planning_O
            'Marker_Typ': site.Marker_Typ
            'Marker_Com': site.Marker_Com
            'Location': site.Location
            'County': site.County
            'MPO_RPO': site.MPO_RPO
            'markersize': site.markersize
            'markercolo': site.markercolo
            'markersymb': site.markersymb
          "geometry":
            'type': 'Point'
            'coordinates': [site.loc.lon, site.loc.lat]
    ])
  )

Template.home.destroyed = ->
  Session.set 'map', false
