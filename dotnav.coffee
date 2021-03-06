#    
# DotNav
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')

class modules.DotNav extends modules.BaseSlider

  constructor: (@options) -> 
    @btns = []
    super(@options)
  
  init: () =>
    @element = $("<nav />").addClass("dot-nav")
    @element.append($("<ol />"))
    # loop through slides
    for slide, i in @options.slides
      btn = $("<li />").html(i)
      @btns.push btn
      @element.find("ol").append(btn)
      
    @element.on("click", @onClick)
    @element.on "mousedown", (e) =>
      e.preventDefault()
      return false;
    @options.parent.append(@element)
    
    super()

  onClick: (e) =>
    e.preventDefault()
    @setActive($(e.target))
    @element.trigger("change")
    return false
  
  setActive: (btn) =>
    if !btn.is("li") then return
    if @active.length > 0
      @active.removeClass('active')
    @active = btn
    @active.addClass('active')
    @currentIndex = btn.index()
    
  goToIndex: (index, skipTransition) =>
    super(index, skipTransition)
    if @btns[index]? and @btns[index].length > 0
      @setActive @btns[index]
  
  