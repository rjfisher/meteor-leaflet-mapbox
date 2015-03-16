@LiveLeaflet =
  addDataToMap: (layer, cursors) ->
    if not Array.isArray(cursors)
      cursors = [cursors]
    queries = (liveData(layer, cursor) for cursor in cursors)
    return stop: -> do stopQuery for stopQuery in queries

liveData = (layer, cursor) ->
  points = []

  if cursor.observe
    transform = (doc) ->
      obj = {
        'type': 'Feature'
        'properties': {
          'Planning_O': doc.Planning_O
          'Marker_Typ': doc.Marker_Typ
          'Marker_Com': doc.Marker_Com
          'Location': doc.Location
          'County': doc.County
          'MPO_RPO': doc.MPO_RPO
          'markersize': doc.markersize
          'markercolo': doc.markercolo
          'markersymb': doc.markersymb
        },
        'geometry': {
          'type': 'Point',
          'coordinates': [doc.loc.lon, doc.loc.lat]
        }
      }

      return obj
  else
    transform = cursor.transform
    cursor = cursor.cursor

  addData = (doc) ->
    data = transform(doc)
    layer.addData(data)
    points[doc._id] = doc
  removeData = (doc) ->
    layer.removeLayer(doc)
    delete points[doc._id]

  liveQuery = cursor.observe
    added: addData
    changed: (newDoc, oldDoc) ->
      removeData(oldDoc)
      addData(newDoc)
    removed: removeData

  return ->
    do liveQuery.stop
    layer.removeLayer(data) for pt in points
