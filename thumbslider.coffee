#    
# Thumbslider
# ============

"use strict" 

# namespace
modules = SEQ.utils.namespace('SEQ.modules')

class modules.ThumbSlider extends modules.CoffeeSlider
  constructor:(@options) ->
    super(@options)
    
  goTo: (index, skipTransition) =>
    super(index, skipTransition)
    @setActive $(@slides[index])
    
  bindUIEvents: =>
    super()

    for slide in @slides
      $(slide).on("click", @onClick)
    
  onClick: (e) =>
    @clicked = $(e.currentTarget)
    slideIndex = @clicked.index() - @settings.step
    
    
    
    
    limit = (@numUniqueSlides - 1)
    if slideIndex > limit
      slideIndex = Math.abs(limit-slideIndex) - 1
      
    @currentIndex = slideIndex
  
    @setActive(@clicked)  
    @element.trigger("change")
    
  setActive: (slide) =>
    if @active.length > 0
      @active.removeClass('active')
    @active = slide
    @active.addClass('active')