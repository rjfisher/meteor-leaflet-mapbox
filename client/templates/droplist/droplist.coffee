Template.droplist.helpers
  sitesCount: ->
    return Sites.find().count()
  options: ->
    return Counties.find()

Template.droplist.events
  'change select': (e) ->
    county = Counties.findOne(name: $(e.target).val())
    Leaflet.zoomToCounty(county)
