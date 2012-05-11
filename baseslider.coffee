#    
# Base Module
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')
# the main Class
class modules.BaseSlider
  
  constructor: (@options) ->
    @currentIndex = 0
    @element = {}
    @active = {}
    @navModules = []
    @init()
    
  init: () =>
    @goTo(0)
  
  goTo: (index, skipTransition) =>   
    @currentIndex = index
    for navModule in @navModules
      console.log navModule.ctor
      console.log modules.ThumbSlider
      
      if navModule.goTo?
        navModule.goTo index, skipTransition
      
  registerNavModule: (navModule) =>
    navModule.element.on "change", (e) =>
     # @goTo navModule.currentIndex

    @navModules.push(navModule)
