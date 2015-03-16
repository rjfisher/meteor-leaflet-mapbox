Meteor.publish 'sites', (query) ->
  check query, Object

  if query.bounds?
    return Sites.find(loc:
      $geoWithin:
        $polygon: query.bounds
    )

  return Sites.find()
