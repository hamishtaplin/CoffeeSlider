#    
# Base Module
# ============

"use strict" 

# namespace
modules = SEQ.utils.namespace('SEQ.modules')
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
      if navModule.goTo?
        navModule.goTo index, skipTransition
      
  registerNavModule: (navModule) =>
    navModule.element.on "change", (e) =>
      @goTo navModule.currentIndex

    @navModules.push(navModule)
