#    
# Thumbslider
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')

class modules.ThumbSlider extends modules.CoffeeSlider
  constructor:(@options) -> 
    super(@options)
      
  init: () =>
    super()
    @element.on "click", @onClick
    
  goTo: (index, skipTransition) =>
    super(index, skipTransition)
    @setCurrentSlide()
            
  setCurrentSlide: () =>
    if @current?
      @current.removeClass("active")
    
    @current = $(@slides[@currentIndex])
    @current.addClass('active')
    
  onClick: (e) =>
    console.log $(e.target).index()
    
  
 