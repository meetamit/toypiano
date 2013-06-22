VENDOR = "vendor"
requirejs.config
  paths:
    'jquery': "#{VENDOR}/jquery.min"
    'backbone': "#{VENDOR}/backbone-min"
    'underscore': "#{VENDOR}/underscore-min"
    'jade': "#{VENDOR}/jade-min"
    'audio-fx': "#{VENDOR}/audio-fx"
    # 'text': "#{VENDOR}/text" # requirejs's text.js plugin, for loading raw text (json)
  shim:
    'jquery': exports: '$'
    'backbone':
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    'underscore': exports: '_'
    'jade': exports: 'jade'
    'audio-fx': exports: 'AudioFX'

requirejs ["keyboard", "synth", "definitions", "templates", "backbone", "jquery"], (Keyboard, Synth, defs, JST, Backbone, $) ->
  # console.log defs.scales['c-maj']
  # scale = new Backbone.Collection defs.scales['c-maj']
  scale = defs.scales['c-maj']
  # $('h1').text "ontouchstart" of document.documentElement
  keyboard = new Keyboard
    el: $('.keyboard')
    model: scale
  
  synth = new Synth window.IS_NATIVE
  
  keyboard.on 'noteDown', (note) ->
    synth.play note
  
  # .html JST['keyboard']
  #   scale: defs.scales['c-maj']
