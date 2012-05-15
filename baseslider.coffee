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
    @goToIndex(0)
  
  getCurrentIndex: () =>
    return @currentIndex

  goToIndex: (index, skipTransition) =>   
    @currentIndex = index
    for module in @navModules
      module.handler(@currentIndex, skipTransition)

  registerNavModule: (navModule, changeHandler) =>
    @navModules.push
      module: navModule
      handler: if changeHandler? then changeHandler else navModule.goToIndex
    navModule.element.on "change", =>
      @onNavModuleChange navModule

  onNavModuleChange: (navModule) =>
    @goToIndex(navModule.getCurrentIndex())
    @navModulesUpdate(navModule)

  navModulesUpdate: (navModule) =>
    for module in @navModules
      if module.module is not navModule
        module.handler(navModule.getCurrentIndex)