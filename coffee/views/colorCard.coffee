class Dot.Views.ColorCard extends Backbone.View

  template: JST['colorCard']

  className:"isle colorize"

  initialize: (color) ->
    @color = color
    # console.log @color
    @render()

  render: ->
    # console.log @el
    @$el.html(@template(color:@color))
