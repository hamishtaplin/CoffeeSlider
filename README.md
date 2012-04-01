CoffeeSlider
============
Coffeeslider is a touch-enabled slider module written in Coffeescript.

Features
--------

- Rigged for touch devices.
- Fully compatible with responsive CSS techniques.
- Infinite Scrolling.
- Horizontal, vertical and fade transitions.
- Uses 'Transition' CSS3 transition framework for cutting-edge, hardware-accelerated animations on supported browser/devices.
- Callback API.

Dependencies
------------

- Transition (https://github.com/hamishtaplin/Transition)
- jQuery

Usage
-----

Coffeeslider is instantiated just like any native Javascript object, via the 'new' keyword. There are a number of options that can be passed in (via an Object-literal). The following is an example of a minimal implementation:

`
new SEQ.modules.CoffeeSlider({
	container: $("#carousel"),
	selectors: {
		slide: "figure"
	}
});
`