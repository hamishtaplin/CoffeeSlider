#    
# DotNav
# ============

"use strict" 

# namespace
# namespace
modules = SEQ.utils.namespace('SEQ.modules')

class modules.DotNav extends modules.BaseModule

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
    @options.parent.append(@element)
    
    super()

  onClick: (e) =>
    e.preventDefault()
    
    
    @setActive($(e.target))
    @element.trigger("change")
    return false
  
  setActive: (btn) =>
    if @active.length > 0
      @active.removeClass('active')
    @active = btn
    @active.addClass('active')
    @currentIndex = btn.index()
    
  goTo: (index, skipTransition) =>
    super(index, skipTransition)
    if @btns[index]? and @btns[index].length > 0
      @setActive @btns[index]
  
  