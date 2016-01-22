class ReloadWidget extends BaseWidget
  init: ->
    @loop()

  loop: =>
    window.setTimeout @reload, @options.ms

  reload: =>
    @element.load @options['url'], null, @loop

Widgets.register 'reload', ReloadWidget
