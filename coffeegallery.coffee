#    
# Coffeegallery
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')
transition = SEQ.effects.Transition

CoffeeSlider = modules.CoffeeSlider
ThumbSlider = modules.ThumbSlider

# the main Class
class modules.CoffeeGallery
  # Constructor. Creates a CoffeeSlider instance.
  constructor: (@options) ->
    @initCoffeeSlider()
    @initThumbs()
    
  initCoffeeSlider: =>
    @coffeeslider = new CoffeeSlider
      container: $(@options.slider)
      transitionType: CoffeeSlider.TRANSITION_SLIDE
      loop: CoffeeSlider.INFINITE
      transitionSpeed: 1400
      transitionDelay: 5000
      transitionDirection: CoffeeSlider.DIRECTION_HORIZONTAL
      touchStyle: CoffeeSlider.TOUCH_DRAG
      preload: true
      responsive: false
      selectors:
        slide: "figure"

  initThumbs: =>
    if @options.autoThumbs
      @createThumbs()
    
    @thumbnails = new ThumbSlider
      container: $(@options.thumbslider)
      transitionType: ThumbSlider.TRANSITION_SLIDE
      loop: ThumbSlider.LOOP_LIMIT
      transitionSpeed: 1400
      transitionDelay: 5000
      transitionDirection: ThumbSlider.DIRECTION_HORIZONTAL
      touchStyle: ThumbSlider.TOUCH_DRAG
      step: 3
      responsive: false
      hasDotNav: false
      selectors:
       slide: "figure"

    @coffeeslider.registerNavModule(@thumbnails, @thumbnails.setCurrentSlide)

  createThumbs: =>
    for slide in $(@options.slider).find(".slide")
      clone = $(slide).clone()
      for element in @options.stripElements
        clone.find(element).remove()
      
      $(@options.thumbslider).append(clone)
    
    
    
    
    