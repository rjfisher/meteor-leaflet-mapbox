Meteor.publish 'counties', ->
  Counties.find {}, sort: name: 1
