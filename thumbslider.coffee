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
    # don't bother
    if index is @getCurrentIndex() then return false
    # if current exists, remove class
    if @current?
      @current.removeClass("active")
    # set current to incoming slide index 
    @current = $(@slides[index])
    @current.addClass("active")

    @goToIndex Math.floor(index / @settings.step), false

  getCurrentIndex: () =>
    if @current? then return @current.index()
    
  onClick: (e) =>
    target = $ e.target
    e.preventDefault()
    if target.hasClass("slide")
      @setCurrentSlide target.index()
      @element.trigger("change")