extends Control

onready var chart_node = get_node('chart')
onready var fps_label = get_node('benchmark/fps')
onready var points_label = get_node('benchmark/points')

func _ready():
  chart_node.initialize(chart_node.LABELS_TO_SHOW.NO_LABEL,
  {
	les_go = Color(1.0, 0.18, 0.18),
	recettes = Color(0.58, 0.92, 0.07),
	interet = Color(0.5, 0.22, 0.6)
  })

  reset()
  set_process(true)

func _process(delta):
  fps_label.set_text('FPS: %02d' % [Engine.get_frames_per_second()])
  points_label.set_text('NB POINTS: %d' % [chart_node.current_data_size * 3.0])

func reset():
  chart_node.create_new_point({
	label = 'JANVIER',
	values = {
	  les_go = 150,
	  recettes = 1025,
	  interet = 1050
	}
  })

  chart_node.create_new_point({
	label = 'FEVRIER',
	values = {
	  les_go = 500,
	  recettes = 1020,
	  interet = -150
	}
  })

  chart_node.create_new_point({
	label = 'MARS',
	values = {
	  les_go = 10,
	  recettes = 1575,
	  interet = -450
	}
  })

  chart_node.create_new_point({
	label = 'AVRIL',
	values = {
	  les_go = 350,
	  recettes = 750,
	  interet = -509
	}
  })

  chart_node.create_new_point({
	label = 'MAI',
	values = {
	  les_go = 1350,
	  recettes = 750,
	  interet = -505
	}
  })

  chart_node.create_new_point({
	label = 'JUIN',
	values = {
	  les_go = 350,
	  recettes = 1750,
	  interet = -950
	}
  })

  chart_node.create_new_point({
	label = 'JUILLET',
	values = {
	  les_go = 100,
	  recettes = 1500,
	  interet = -350
	}
  })

  chart_node.create_new_point({
	label = 'AOUT',
	values = {
	  les_go = 350,
	  recettes = 750,
	  interet = -500
	}
  })

  chart_node.create_new_point({
	label = 'SEPTEMBRE',
	values = {
	  les_go = 1350,
	  recettes = 750,
	  interet = -50
	}
  })

  chart_node.create_new_point({
	label = 'OCTOBRE',
	values = {
	  les_go = 350,
	  recettes = 1750,
	  interet = -750
	}
  })

  chart_node.create_new_point({
	label = 'NOVEMBRE',
	values = {
	  les_go = 450,
	  recettes = 200,
	  interet = -150
	}
  })

  chart_node.create_new_point({
	label = 'DECEMBRE',
	values = {
	  les_go = 1350,
	  recettes = 500,
	  interet = -500
	}
  })

