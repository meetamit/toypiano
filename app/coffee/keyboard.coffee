define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class MouseInteraction
    control: (keyboard) ->
      @keyboard = keyboard
      @currentNote = null
      @keyboard.$el.on 'mousedown', @update
      @keyboard.$el.on 'mousemove', @update
      @keyboard.$el.on 'mouseup', @update
    
    update: (event) =>
      event.preventDefault()
      
      switch event.type
        when 'mousemove' then return if !@isMouseDown
        when 'mousedown' then @isMouseDown = true
        when 'mouseup' then @isMouseDown = false
      
      noteUnderMouse = if @isMouseDown then @keyboard.xToNote event.pageX else null
      
      if noteUnderMouse == @currentNote then return
      if @currentNote then @keyboard.noteUp @currentNote
      if noteUnderMouse then @keyboard.noteDown noteUnderMouse
        
      @currentNote = noteUnderMouse
      
  class TouchInteraction
    control: (keyboard) ->
      @keyboard = keyboard
      @currentNotes = []
      @keyboard.$el.on 'touchstart', @update
      @keyboard.$el.on 'touchmove', @update
      @keyboard.$el.on 'touchend', @update
    
    update: (event) =>
      event.preventDefault()
      event = event.originalEvent
      
      notesUnderTouch = (@keyboard.xToNote touch.pageX for touch in event.touches)
      enterNotes = _.difference notesUnderTouch, @currentNotes
      exitNotes = _.difference @currentNotes, notesUnderTouch
      
      @keyboard.noteDown note for note in enterNotes
      @keyboard.noteUp note for note in exitNotes

      @currentNotes = notesUnderTouch
      
  class Keyboard extends Backbone.View
    @MouseInteraction: MouseInteraction
    @TouchInteraction: TouchInteraction
    
    initialize: ->
      @render()
      controller = @options.controller || 
        new (if 'ontouchstart' of document.documentElement then Keyboard.TouchInteraction else Keyboard.MouseInteraction)()
      controller.control @
      
    render: ->
      notes = @model.get 'notes'
      pctWidth = (100 / notes.length) + '%'
      notes.each (note) =>
        $note = note.$note = $(document.createElement 'div')
          .attr
            class: 'note'
          .css
            width: pctWidth
            background: note.get 'color'
          .text(note.id)
          .appendTo @$el

    noteDown: (note) ->
      note.$note.addClass 'down'
      @trigger 'noteDown', note
      
    noteUp: (note) ->
      note.$note.removeClass 'down'
      @trigger 'noteUp', note
      
    xToNote: (x) ->
      notes = @model.get('notes')
      notes.at Math.floor notes.length * x / @$el.width()
