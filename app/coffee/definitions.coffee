define ["backbone"], (Backbone) ->
  notes =
    C0:
      src: "TP_03_v3.wav"
      color: "#893E5E"
    D0:
      src: "TP_04_v3.wav"
      color: "#1B4B8D"
    E0:
      src: "TP_05_v3.wav"
      color: "#00883E"
    F0:
      src: "TP_06_v3.wav"
      color: "#00AE0E"
    G0:
      src: "TP_07_v2.wav"
      color: "#ECD400"
    A1:
      src: "TP_08_v3.wav"
      color: "#FF4600"
    B1:
      src: "TP_09_v3.wav"
      color: "#CC0000"
    C1:
      src: "TP_10_v3.wav"
      color: "#ED938B"

  scales =
    "c-maj":
      notes: ["C0", "D0", "E0", "F0", "G0", "A1", "B1", "C1"]
  
  note.id = id for id, note of notes
  scale.id = id for id, scale of scales
  
  for id, scale of scales
    for note, i in scale.notes
      scale.notes[i] = notes[note]
    scale.notes = new Backbone.Collection scale.notes
    scales[id] = new Backbone.Model scale
  
  notes: notes
  scales: scales
  