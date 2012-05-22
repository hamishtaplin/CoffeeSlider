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

    # some DOM shenanigans happens here necessitating this hack
    # maybe fix this properly one day
    if skipTransition
      delay = 10
    else
      delay = 0

    setTimeout => 
      @goToIndex Math.floor(index / @settings.step), skipTransition
    , delay

  getCurrentIndex: () =>
    if @current? then return @current.index() else return null
    
  onClick: (e) =>
    target = $ e.target
    e.preventDefault()
    if target.hasClass("slide")
      @setCurrentSlide target.index()
      @element.trigger("change")