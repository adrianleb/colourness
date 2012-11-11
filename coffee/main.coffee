window.Dot =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  init: ->

    # Init settings
    $.fx.interval = 20


    # Initialize Routers
    @Routers.main = new Dot.Routers.Main()
    Backbone.history.start()



$ ->
  Dot.init()
