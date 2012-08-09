#    
# Button Nav
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')

class modules.ButtonNav extends modules.BaseSlider

  constructor: (@options) -> 
    @btns = []
    super(@options)
  
  init: () =>
    @element = $("<nav />").addClass("button-nav")
    @element.append($("<ul />"))
    # loop through slides
    for slide, i in @options.slides
      title = $(slide).find(@options.titleSelector).html()
      btn = $("<li />").html(title)
      @btns.push btn
      @element.find("ul").append(btn)   
      
    @element.on("click", @onClick)
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
  
  