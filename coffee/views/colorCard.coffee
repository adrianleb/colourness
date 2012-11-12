class Dot.Views.ColorCard extends Backbone.View

  template: JST['colorCard']

  className:"isle colorize"

  initialize: (color) ->
    @model = color
    @hex = @model.color.attributes.hex
    @name = @model.color.attributes.name
    @brightness = @model.color.attributes.brightness
    @$el.attr 'id', "#{@hex}"
    @render()

  render: ->
    # console.log @el
    @$el.html(@template(color:@model))
