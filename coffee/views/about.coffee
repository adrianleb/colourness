class Dot.Views.About extends Backbone.View

  template: JST['about']

  className: 'about'

  events:
    'click #about-back' : 'back'

  initialize: (parent) ->
    console.log parent
    @parent = parent.parent
    console.log 'hai'
    console.log @
    @render()

  render: ->
    $(@el).html(@template())


  back: (e) ->
    e.preventDefault()
    @parent.$el.removeClass('flap_about')
