define ["audio-fx"], (AudioFX) ->
  class Synth
    constructor: (isNative = false) ->
      @isNative = isNative
      @sounds = {}
      
    play: (note) ->
      if @isNative
        sound = new Media "sound/#{note.attributes.src}"
      else
        sound = @sounds[note.id]
        if !sound
          sound = @sounds[note.id] = AudioFX "sound/#{note.attributes.src}", volume: 1
        else
          sound.stop()
          
      sound.play()
