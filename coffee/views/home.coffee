class Dot.Views.Home extends Backbone.View

  template: JST['home']

  # Define main element to attach to
  el: "body"


  colorViews: []

  initialize: (key) ->
    @colors = new Dot.Collections.Colors()
    console.log key
    console.log @colors
    @render()
    @colors.fetch( 
      success: =>
        @loadCards()
    )


  render: ->
    $(@el).html(@template())
    @$el.attr('class', 'container homePage')
    @colorDebouncer = _.debounce(@colorChanger, 10)
    @colorEl = @$('#color')



  loadCards: ->
    for color in @colors.models
      do (color) =>
        vi = new Dot.Views.ColorCard(color:color)
        # console.log vi
        @$('#roll').append vi.el
        @colorViews.push vi
    @bindWaypoint()
    @checkColor()



  colorChanger: ->
      data = @currentColor.$el.find('[data-hex]')
      # b = $(data).data "brightness"
      # realB = (100 - (b * 100) )


      @$el.css "backgroundColor",  @currentColorHex
      $('.colorizing').css "color",  =>
        if @currentColorBrightness < 0.5
          "hsl(0, 0%, 90%)"
        else
          "hsl(0, 0%, 10%)"


  bindWaypoint: ->
    checker = _.debounce ( =>
      @windowPos = $(window).scrollTop()
      @windowHeight = $(window).height()
      @checkColor()
    ), 20
    $(window).on 'scroll', (e) =>
      checker()
    # $('.isle').on 'inview', (event, isInView, visiblePartX, visiblePartY )=>
    #   @colorChanger(event, isInView, visiblePartX, visiblePartY)


  checkColor: ->
    for color in @colorViews
      pos = color.$el.offset().top.toFixed(0)
      result =  pos - @windowPos
      if (result > 0) and (result < @windowHeight)
        if (color is @currentColor)
          return false
        @currentColor = color 
        @currentColorHex = @currentColor.$el.find('[data-hex]').data "hex"
        @currentColorBrightness = @currentColor.$el.find('[data-hex]').data "brightness"
        @colorChanger()
      # if (color.$el.offset().top - @windowPos) > 0 < 1000 and color isnt @currentColor
