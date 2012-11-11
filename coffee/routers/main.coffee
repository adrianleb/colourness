class Dot.Routers.Main extends Backbone.Router

  view: null

  routes:
    '': 'home'
    ':key':'home'


  home: (key) ->
    @view = new Dot.Views.Home(key)

