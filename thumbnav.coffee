#    
# Button Nav
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')

class modules.ThumbNav extends modules.BaseSlider

  constructor: (@options) ->
    super(@options)
  
  init: () =>
    super()
    @element = @options.element
    @element.on "click", "li", @onClick
    
  onClick: (e) =>
    @goToIndex($(e.currentTarget).index(), false)
    @element.trigger("change")

  goToIndex: (index, skipTransition) =>
    @currentIndex = index
    # $("#booknav").find(".active").removeClass("active")  
    # $("#booknav").find("li").eq(index).addClass("active")    

  getCurrentIndex: =>
    return Math.floor(@currentIndex / 3)