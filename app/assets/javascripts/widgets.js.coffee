class @BaseWidget
  constructor: (@element, @options) ->

class @Widgets
  @widgets: {}

  @register: (name, klass) ->
    @widgets[name] = klass

  @init: ->
    @initWidget e for e in $('[data-widget]')

  @initWidget: (element) ->
    names = $(element).data("widget").split /\s+/
    for name in names
      widget  = @widgets[name]
      @initWidgetInstance widget, element if widget

  @initWidgetInstance: (klass, element) ->
    e = $ element
    options = {}
    for attribute in element.attributes
      matches = attribute.name.match(/^data\-widget\-(.+)/)
      if matches
        name = matches[1]
        options[name] = e.data("widget-#{name}") if matches

    instance = new klass $(element), options
    instance.init()

$ ->
  Widgets.init()

