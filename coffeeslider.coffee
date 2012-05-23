#    
# Coffeeslider
# ============

"use strict" 

# namespace
modules = Namespace('SEQ.modules')
Transition = SEQ.effects.Transition

# the main Class
class modules.CoffeeSlider extends modules.BaseSlider   
  # Constructor. Creates a CoffeeSlider instance.
  
  #static constants
  #transition types
  @TRANSITION_SLIDE: "slide"
  @TRANSITION_FADE: "fade"
  @TRANSITION_SLIDE_FADE: "slideFade"
  # directions
  @DIRECTION_HORIZONTAL: "horizontal"
  @DIRECTION_VERTICAL: "vertical"
  # touch styles
  @TOUCH_DRAG: "drag"
  @TOUCH_GESTURE: "gesture"
  @TOUCH_INVERSE_GESTURE: "inverseGesture"
  @TOUCH_NONE: "none"
  # loop types
  @LOOP_INFINITE: "infinite"
  @LOOP_RETURN: "return"
  @LOOP_LIMIT: "limit"
  
  constructor: (@options) ->
    # Intial settings
    # --------------
    @settings =
      # type of animation - @TRANSITION_SLIDE, @TRANSITION_FADE or @TRANSITION_SLIDE_FADE
      transitionType: CoffeeSlider.TRANSITION_SLIDE
      # slideshow?
      slideshow: false
      # the direction of transitions
      transitionDirection: CoffeeSlider.DIRECTION_HORIZONTAL
      # duration between transitions in slideshow mode
      transitionDelay: 2000 
      # duration of transition
      transitionSpeed: 1000
      # has prev/next navigation
      hasPrevNext: true
      # has dotnav
      hasDotNav: true
      # increase for multiple 'slides' in a viewport    
      step: 1
      # respond to browser resizing
      responsive: true
      # which style of touch interaction to use, @TOUCH_DRAG, @TOUCH_INVERSE_GESTURE, @TOUCH_DRAG or @TOUCH_NONE
      touchStyle: CoffeeSlider.TOUCH_DRAG                   
      # @LOOP_INFINITE - slides loop infinitely
      # @LOOP_RETURN - loops around to start/end
      # @LOOP_LIMIT - does nothing when it reaches the start/end
      loop: CoffeeSlider.LOOP_INFINITE
      # preloads the images
      preload: true                   
      
      # these are the selectors used
      selectors:
        # Coffeeslider uses this selector to define a slide. For example, if your 'slides' are a list, you would enter 'li' here.   
        slide:    ".slide"
        # The outer wrapper.
        outer:    ".outer"
        # The inner wrapper.
        inner:    ".inner"      
        # The 'previous slide' button.
        prev:     ".prev"
        # The 'next slide' button.
        next:     ".next"
        # Generic button class.
        btn:      ".btn"
        # defaults to $carousel.
        uiParent: ""             
        
      callbacks:
        # Called after the slider is initialised. 
        onStart: ->
        # Called each time the slide transition starts.    
        onTransition: ->
        # Called each time the slide transition completed.
        onTransitionComplete: ->
    
    # Main container element - A jQuery object containing the slides.
    @element = {}
    # outer container
    @outer = {}
    # inner container
    @inner = {}
    # parent for ui elements
    @uiParent = {}
    # previous button
    @prevBtn = {}
    # next buttin
    @nextBtn = {}
    # array of slides
    @slides = {}
    # width of slide
    @slideWidth = 0
    # internal states
    @currentIndex = undefined
    # number of unique slides
    @numUniqueSlides = 0
    # number of slides
    @numSlides = 0
    # is currently moving
    @isMoving = false;
    # navigation modules
    super(@options)

  # initialises the class
  init: () =>
    @element = @options.container
    @element
      .addClass("coffee-slider")
      .css
        opacity: 1
    
    @applySettings()
    @bindToDOM()
    @initUI()
    # init slides and pass in callback for image preloading
    @initSlides =>      
      @applyStyles()  
      @applySizes()          
      @bindUIEvents()
      @settings.callbacks.onStart()
      @goToIndex(0, true)
    
    if @settings.responsive
      $(window).resize @onWindowResize
  
  # Merges user-defined options with defaults.
  applySettings:() ->
    # merge settings defaults
    $.extend true, @settings, @options
  
  # Binds internal properties to DOM elements.
  bindToDOM: ->   
    # bind DOM references
    @slides = @find("slide")
    #store number of unique slides for later
    @numSlides = @slides.length
    
    for slide, i in @slides
      $(slide).addClass("slide slide-#{i}")
    
    # if inner/outer don't exist, create them
    if (@inner = @find("inner")).length is 0
      @slides.wrapAll($("<div />").addClass(@getSelector("inner")))
      @inner = @find("inner")
  
    if (@outer = @find("outer")).length is 0
      @inner.wrap $("<div />").addClass(@getSelector("outer"))
      @outer = @find("outer")
  
  # Initialises slides
  initSlides: (callback) =>    
    # add cloned slides for infine scrolling unless fade  
    if @settings.loop is CoffeeSlider.LOOP_INFINITE and @settings.transitionType isnt CoffeeSlider.TRANSITION_FADE
      @appendClonedSlides()

    if @settings.preload
      @preload(callback)
    else
      callback() if callback?

  # Preloads the images. 
  preload: (callback) =>
    @outer.css
      opacity: 0
    @images = @element.find("img")
    @numImages = @images.length
    @checkImagesLoaded(callback)
  
  # Loops through each image and checks if loaded. If ready, calls the callback to continue.
  checkImagesLoaded: (callback) =>
    imgsLoaded = 0

    for img in @images 
      if img.complete
        imgsLoaded++ 
        
    if imgsLoaded is @numImages
      callback() if callback?
      Transition.To
        target: @outer
        duration: 300
        props:
          opacity: 1
        complete: @onImagesLoadedTransitionComplete
          
    else
      setTimeout =>
        @checkImagesLoaded(callback)
      , 100
  
  onImagesLoadedTransitionComplete: =>
    Transition.To
      target: @slides
      duration: 300
      props:
        opacity: 1
      complete: =>
        @element.css
          height: "auto"
     
  # Appends cloned slides to either side for purposes of creating illusion of infinite scrolling.
  appendClonedSlides: ->     
    float = (if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL then "left" else "none")
    i = 0
    while i < @settings.step
      i++
      # append 1st slide to end
      @inner.append @slides
        .eq(0 + (i-1))
        .clone()
        .addClass('clone')
        .css
          float: float
      # append last slide to start
      @inner.prepend @slides
        .eq(@numSlides-i)
        .clone()
        .addClass('clone')
        .css
          float: float
    @numUniqueSlides = @numSlides
    @slides = @find("slide")
    @numSlides = @slides.length
  
  # Applies some basic CSS.
  applyStyles: (callback) =>
    # set some initial styles
    @inner.css 
      position: "relative"
      overflow: "hidden"
    @outer.css
      overflow: "hidden"

    # if using 'slide' option
    if @settings.transitionType is CoffeeSlider.TRANSITION_SLIDE or @settings.transitionType is CoffeeSlider.TRANSITION_SLIDE_FADE
      if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL
        @slides.css
          float: "left"
          overflow: "hidden"                    
    else if @settings.transitionType is CoffeeSlider.TRANSITION_FADE
      @slides.css
        position: "absolute"
        left: "0"
        opacity: "0"
        
  # calculates and applies sizes
  applySizes: =>
    #  don't do this in the middle of a transition
    if @isMoving then return
  
    # get width of single slide      
    @slideWidth = @slides.eq(0).outerWidth(true)
    @slideHeight = @slides.eq(0).innerHeight(true)
    @totalWidth = (@slideWidth * @numSlides) * @settings.step
    @totalHeight = @slideHeight * @numSlides
    outerWidth = @outer.width()
    outerHeight = @outer.height()
    @element.css
      width: outerWidth * @settings.step
    
    # set slide widths to that of main container        
    @slides.css
      width: outerWidth
    
    # if using @TRANSITION_SLIDE option
    if @settings.transitionType is CoffeeSlider.TRANSITION_SLIDE or @settings.transitionType is CoffeeSlider.TRANSITION_SLIDE_FADE
      if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL
        # recalculate width
        @slideWidth = @slides.eq(0).outerWidth(true)
        @totalWidth = @slideWidth * @numSlides
        # set width of inner to accomodate slides and adjust left position
        
        @inner.css
          width: @totalWidth
          # left: 0-(outerWidth * (@currentIndex + 1)) 
        # set width of outer wrapper
        @outer.css
          height: @slideHeight
      else if @settings.transitionDirection is CoffeeSlider.DIRECTION_VERTICAL
        # set width of inner to accomodate slides
        @inner.css
          height: @totalHeight
          # top: 0-(@slideHeight * (@currentIndex + 1))  
        @outer.css
          height: @slideHeight
    
    # if @TRANSITION_FADE
    else if @settings.transitionType is CoffeeSlider.TRANSITION_FADE
      @inner.css
        height: @slideHeight
        
  # Initialises UI components.
  initUI: ->
    @uiParent = @getContainer "uiParent", @element  
    # create next/prev buttons
    if @settings.hasPrevNext
      @prevBtn = $("<div />")
        .addClass("#{@getSelector("prev")}")
        .addClass("#{@getSelector("btn")}")
        .html("prev")
      @nextBtn = $("<div />")
        .addClass("#{@getSelector("next")}") 
        .addClass("#{@getSelector("btn")}")        
        .html("next") 
      @uiParent.append(@prevBtn)
      @uiParent.append(@nextBtn)
        
    if @settings.hasDotNav
      dotNav = new modules.DotNav
        slides: @slides
        parent: @uiParent
      @registerNavModule(dotNav)
          
  # Removes UI components.
  removeUI: ->
    @nextBtn.remove()
    @prevBtn.remove()
  
  # Binds event-handling to user controls.       
  bindUIEvents: =>
    if @settings.hasPrevNext
    # next / back click events
      @nextBtn.bind "click", (e) =>
        e.preventDefault()
        if !$(e.target).hasClass("disabled")
          @next()
      @prevBtn.bind "click", (e) =>
        e.preventDefault()
        if !$(e.target).hasClass("disabled")
          @prev()
    
    #touch events
    @inner.bind "touchstart", @onTouchStart if @settings.touchStyle isnt CoffeeSlider.TOUCH_NONE
  
  onWindowResize: =>
    @applySizes()
  
  # Initialises the slideshow, if needed.
  initSlideshow: =>    
    clearTimeout(@timer)
    @timer = setTimeout(@onSlideshowTick, @settings.transitionDelay)
    
  onSlideshowTick: () =>
    @next()
        
  # Called when a touch start event fires.
  onTouchStart: (e) =>
    @innerLeft = parseInt(@inner.css("left"))
    @innerTop = parseInt(@inner.css("top"))
    @touchStartPoint = 
      x: e.originalEvent.touches[0].pageX
      y: e.originalEvent.touches[0].pageY        
    @distanceMoved =
      x: 0
      y: 0
    @inner.bind("touchend", @onTouchEndOrCancel)
    @inner.bind("touchcancel", @onTouchEndOrCancel)
    @inner.bind("touchmove", @onTouchMove)
    
    # pause slideshow
    if @settings.slideshow
      clearTimeout(@timer)

  # Called when a touch move event fires.     
  onTouchMove: (e) =>
    @touchEndPoint =
      x: e.originalEvent.touches[0].pageX  
      y: e.originalEvent.touches[0].pageY
    @distanceMoved =
      x: @touchStartPoint.x - @touchEndPoint.x
      y: @touchStartPoint.y - @touchEndPoint.y

    dragPos =
      x:0
      y:0

    if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL
      if Math.abs(@distanceMoved.x) > 15    
        e.preventDefault()     
      else if Math.abs(@distanceMoved.y) > 15
        @inner.unbind "touchmove", @onTouchMove
    
    else if @settings.transitionDirection is CoffeeSlider.DIRECTION_VERTICAL
      if Math.abs(@distanceMoved.y) > 10
        e.preventDefault()     
      else if Math.abs(@distanceMoved.x) > 10
        @inner.unbind "touchmove", @onTouchMove
    
    if @settings.touchStyle is CoffeeSlider.TOUCH_DRAG     
      if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL
        dragPos.x = @innerLeft - (@touchStartPoint.x - @touchEndPoint.x) 
        if @settings.loop isnt CoffeeSlider.LOOP_INFINITE and (dragPos.x >= 10  or dragPos.x <= 0 - (@totalWidth - @slideWidth - 10))
          @inner.unbind "touchmove", @onTouchMove
          @distanceMoved.x = 0
        else
          @inner.css
            left: dragPos.x           
      else if @settings.transitionDirection is CoffeeSlider.DIRECTION_VERTICAL
        dragPos.y = @innerTop - (@touchStartPoint.x - @touchEndPoint.x) 
        if @settings.loop isnt CoffeeSlider.LOOP_INFINITE and dragPos.y >= 10
          @inner.unbind "touchmove", @onTouchMove
          @distanceMoved.y = 0
        else  
          @inner.css
            top: dragPos.y

  # Called when a touch event finishes.
  onTouchEndOrCancel: (e) =>
    @inner.unbind("touchend", @onTouchEndOrCancel)
    @inner.unbind("touchcancel", @onTouchEndOrCancel)
    @inner.unbind("touchmove", @onTouchMove)
    e.preventDefault()
    e.stopPropagation()

    

    # if @settings.transitionDirection is CoffeeSlider.DIRECTION_HORIZONTAL    
    #   if @distanceMoved.x > 50
    #     if @settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.touchStyle is CoffeeSlider.TOUCH_INVERSE_GESTURE
    #       @prev()
    #     else
    #       @next()
    #   else if @distanceMoved.x < -50
    #     if @settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.touchStyle is CoffeeSlider.TOUCH_INVERSE_GESTURE
    #       @next()
    #     else
    #       @prev()
    #   else
    #     @goToIndex @currentIndex
        
    # else if @settings.transitionDirection is CoffeeSlider.DIRECTION_VERTICAL    
    #   if @distanceMoved.y > 50
    #     if @settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.touchStyle is CoffeeSlider.TOUCH_INVERSE_GESTURE
    #       @prev()
    #     else
    #       @next()
    #   else if @distanceMoved.y < -50
    #     if @settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.touchStyle is CoffeeSlider.TOUCH_INVERSE_GESTURE
    #       @next()
    #     else
    #       @prev()
    #   else
    #     @goToIndex @currentIndex
                           
  # Goes to a specific slide (as indicated).
  goToIndex: (index, skipTransition) =>
    @settings.callbacks.onTransition()
    
    if !skipTransition
      @isMoving = true    
    
    switch @settings.transitionType
      when CoffeeSlider.TRANSITION_SLIDE
        @slideTo(index, skipTransition)
      when CoffeeSlider.TRANSITION_FADE
        @fadeTo(index, skipTransition)
      when CoffeeSlider.TRANSITION_SLIDE_FADE
        @slideFadeTo(index, skipTransition)
          
    if @settings.slideshow
      @initSlideshow()
      
    super(index, skipTransition)
  
  updateNavModules: (index, skipTransition) =>
    # prevent navmodules from moving to out-of-bounds index
    if index >= 0 and index <= @numUniqueSlides-1
      super(index, skipTransition)

  # Uses the 'slide' animation to move to a slide.
  slideTo: (index, skipTransition) =>
    # record the current index
    @currentIndex = index
    # offset to compensate for extra slide if in infinite mode
    offset = (if @settings.loop is "infinite" then @settings.step else 0)       
        
    switch @settings.transitionDirection
      when CoffeeSlider.DIRECTION_HORIZONTAL
        position = left: 0 - (index + offset) * @slideWidth * @getStepMultiplier()
      when CoffeeSlider.DIRECTION_VERTICAL
        position = top: 0 - (index + offset) * @slideHeight * @getStepMultiplier()

    Transition.To
      target: @inner
      props: position    
      duration: if skipTransition then 0 else @settings.transitionSpeed / 2
      complete: @onTransitionComplete
  
  getStepMultiplier: =>
    i = @currentIndex * @settings.step
    if i + @settings.step > @numSlides
      diff = @numSlides - i
    else
      diff = @settings.step
    return diff

  # fades to the index
  fadeTo: (index, skipTransition) =>
    # fade out the current slide, if it exists
    if @slides[@currentIndex]?
      Transition.To
        target: @slides[@currentIndex]
        props:
          opacity: 0
        duration: if skipTransition then 0 else @settings.transitionSpeed / 2 
        
    # record the current index
    @currentIndex = index
    
    Transition.To
      target: @slides[index]
      props:
        opacity: 1
      duration: @settings.transitionSpeed
      complete: @onTransitionComplete
       
  # Uses the 'slideFade' animation to move to a slide.
  slideFadeTo: (index, skipTransition) =>
    @fadeTo index, skipTransition      
    @slideTo index, skipTransition

  # Goes to the previous page.  
  prev: ->
    # don't proceed if still moving
    return false if @isMoving
    prevIndex =  @currentIndex - 1
    if (@settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.loop is CoffeeSlider.LOOP_RETURN) and prevIndex < 0
      prevIndex = (@numSlides - 1)
    @goToIndex prevIndex, false
    
  # Goes to the next page. 
  next: ->  
    # don't proceed if still moving
    return false if @isMoving
    nextIndex = @currentIndex + 1
    if nextIndex > (@numSlides - 1)
      if (@settings.transitionType is CoffeeSlider.TRANSITION_FADE or @settings.loop is CoffeeSlider.LOOP_RETURN) 
        nextIndex = 0
      else if not @settings.loop
        return
        
    @goToIndex nextIndex, false
        
  # Called whenever a slide transition completes.
  onTransitionComplete: () =>
    if @settings.loop is CoffeeSlider.LOOP_LIMIT
      if @currentIndex is 0
        @prevBtn.addClass("disabled")
      else
        @prevBtn.removeClass("disabled")
    
      if @currentIndex is (@numSlides - 1)
        @nextBtn.addClass("disabled")
      else
        @nextBtn.removeClass("disabled")
    
    @isMoving = false
    if @settings.loop is CoffeeSlider.LOOP_INFINITE and @settings.transitionType isnt CoffeeSlider.TRANSITION_FADE
      if @currentIndex is -1
        @goToIndex @numSlides - (3 + (if @settings.step > 1 then @settings.step + 1 else 0)), true
      else if @currentIndex is (@numSlides - 2) - (if @settings.step > 1 then @settings.step + 1 else 0)
        @goToIndex 0, true
      else
        @settings.callbacks.onTransitionComplete()
    else
      @settings.callbacks.onTransitionComplete()
    
  # Utility function. Finds an element in the container for a given selector in the selectors object.
  find: (selectorName) => 
    @element.find @settings.selectors[selectorName]
  
  # Utility function. Gets a container.      
  getContainer: (name, _default) -> 
    if @settings.selectors[name] is "" then _default else @find name

  # Utility function. Gets a container. 
  getSelector: (name) ->
    selector = @settings.selectors[name]
    selector.slice(1, selector.length)
      
