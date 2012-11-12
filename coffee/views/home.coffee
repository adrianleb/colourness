class Dot.Views.Home extends Backbone.View

  template: JST['home']

  # Define main element to attach to
  el: "body"


  events: 
    'keyup #search-input' : 'search'
    'keyup' : 'handleKeyboard'
    # 'click #about-opener' : 'openAbout'

  colorViews: []

  initialize: (key) ->
    @initialKey = key
    @colors = new Dot.Collections.Colors()
    @windowPos = $(window).scrollTop()
    @render()

    @colors.fetch( 
      success: =>
        @loadCards()
        @initEvents()
    )


  render: ->
    $(@el).html(@template())

    @colorEl = @$('#color')
    @inputter = @$('#search').find('input')
    @swappers = $('.classSwaping')
    @colorizers = $('.colorizing')

  # renderAbout: ->
  #   p = @
  #   vi = new Dot.Views.About(parent:@)
  #   @$el.append vi.el

  # openAbout: (e) ->
  #   e.preventDefault()
  #   @$el.addClass 'flap_about'

  loadCards: ->
    for color in @colors.models
      do (color) =>
        vi = new Dot.Views.ColorCard(color:color)
        @$('#roll').append vi.el
        @colorViews.push vi

    _.delay (=>
      for color in @colorViews
        height = parseFloat((color.$el.height()).toFixed(0))
        res = parseFloat(color.$el.offset().top.toFixed(0)) + height
        color.offsetTop = res
        color.heightV = height

      _.delay (=>
        @findKey()
        @checkColor()
      ), 0
    ), 0

    # console.log @colorViews[6].offsetTop
    # console.log @colors
    # console.log JSON.stringify(@colors.toJSON())


  findKey: (key) ->
    # console.log 'log'
    if @initialKey isnt undefined
      res = _.find @colorViews, (v) =>
        v.hex is @initialKey.toUpperCase()

      @scrollWindow res.$el.offset().top.toFixed(0) - 150
    else
     r = Math.floor(Math.random() * @colorViews.length)
     @scrollWindow @colorViews[r].$el.offset().top.toFixed(0) - 150



  search: (e) ->
    e.preventDefault()
    if e.which is 38
      @showPrev(true)
      return false
    else if e.which is 40
      @showNext(true)
      return false

    @searcher(e)
    false


  handleKeyboard: (e) ->
    e.preventDefault()

    if e.which is 38
      @showPrev()
      return false
    else if e.which is 40
      @showNext()
      return false

    false


  showPrev: (fromSearch=false) ->
    a = @colorViews
    i = @currentColorIndex

    if fromSearch
      a = @searchRes
      i = @searchCurrent

    prev = a?[i - 1]
    if prev 
      i -= 1
      @scrollWindow a[i].$el.offset().top.toFixed(0) - 150
      if fromSearch then @searchCurrent = i else @currentColorIndex = i
    
    else
      false


  showNext: (fromSearch=false) ->
    a = @colorViews
    i = @currentColorIndex

    if fromSearch
      a = @searchRes
      i = @searchCurrent

    next = a?[i + 1]
    if next 
      i += 1
      @scrollWindow a[i].$el.offset().top.toFixed(0) - 150
      if fromSearch then @searchCurrent = i else @currentColorIndex = i

    else
      false


  scrollWindow: (val) ->
    @$el.animate
      scrollTop: val
    , 250


  initEvents: ->
    checker = _.debounce ( =>
      @windowHeight = $(window).height()
      @windowPos = $(window).scrollTop()  
      @checkColor()
    ), 20

    @searcher = _.debounce ( (e) =>
      val = $(e.currentTarget).val().toUpperCase()
      res = _.filter @colorViews, (c) =>
        (c.hex.indexOf(val) >= 0) or (c.name.toUpperCase().indexOf(val) >= 0)

      if res.length
        @searchRes = res
        @searchCurrent = 0
        @scrollWindow (res[0].$el.offset().top.toFixed(0) - 150 )
        @checkColor()
    ), 40



    $(window).on 'scroll', (e) =>
      checker()
    $(window).on 'resize', (e) =>
      checker()

    $(window).on 'hashchange', (e) =>
      e.preventDefault()
      # console.log e
      false

  checkColor: ->
    currentPos = $(window).scrollTop()
    for color in @colorViews
      pos = color.$el.offset().top.toFixed(0)
      result = pos - currentPos

      if ((result > 0) and (result < @windowHeight)) and (color isnt @currentColor)
        @currentColor = color
        @currentColorIndex = @colorViews.indexOf color
        @colorChanger()



  colorChanger: ->
      hex = @currentColor.hex
      brightness = @currentColor.brightness


      @colorEl.css "backgroundColor",  ('#' + hex)
      @inputter.css "color", ('#' + hex)

      if brightness < 0.5
        @swappers.addClass "light"
        @colorizers.css "color",  =>
          "hsl(0, 0%, 90%)"
      else
        @swappers.removeClass "light"
        @colorizers.css "color",  =>
          "hsl(0, 0%, 10%)"

      console.log hex, $("##{hex}")
      @currentColor.$el.attr 'id', ''
      Backbone.history.navigate "/#{hex}", {trigger: false}, false
      @currentColor.$el.attr 'id', hex
      # false
