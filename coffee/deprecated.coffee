
  


  brightnessCheck: ->

    for color in @colors.models
      do (color) =>
        r = color.attributes.rgb.r
        g = color.attributes.rgb.r
        b = color.attributes.rgb.r

        brightness = (@darkOrLight(r,g,b).toFixed(2))
        console.log brightness
        color.set('brightness', brightness )
        color.save()
        console.log color

    console.log JSON.stringify(@colors.toJSON())
    # window.colorsJson = @colors.toJSON()



  darkOrLight: (red, green, blue) ->

    brightness = (red * 299) + (green * 587) + (blue * 114)
    brightness = brightness / 255000
    
    return brightness




  ralextractor: ->
    colors = @$('#ralextractor').find('tr')

    for color in colors
      do (color) =>
        rgbvals = $(color).find('b').text().trim().split(' ')
        rVal = rgbvals[0]
        gVal = rgbvals[1]
        bVal = rgbvals[2]

        colorHash = {
          name: $(color).find('.name').text().trim()
          ral: $(color).find('.ralcolor').text().trim()
          rgb: 
            r: rVal
            g: gVal
            b: bVal
            rgb: "#{rVal}, #{gVal}, #{bVal}"
          hex: $(color).find('.hexcolor').text().trim()
        }

        @colors.push colorHash
    console.log @colors
    window.colors = @colors

