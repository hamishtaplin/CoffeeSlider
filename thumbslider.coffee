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

  setCurrentSlide: (index, skipTransition) =>
    if index is @getCurrentIndex()
      return false
    if @current?
      @current.removeClass("active")
    @current = $(@slides[index])
    @current.addClass("active")

    if not skipTransition
      @goToIndex Math.floor(index / @settings.step)

  getCurrentIndex: () =>
    if @current? then return @current.index()
    
  onClick: (e) =>
    target = $ e.target
    e.preventDefault()
    if target.hasClass("slide")
      @setCurrentSlide target.index()
      @element.trigger("change")