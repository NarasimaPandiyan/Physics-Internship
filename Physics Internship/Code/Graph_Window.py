from godot import exposed, export
from godot import *
import numpy as np

@exposed
class Graph_Window(WindowDialog):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		arr = np.array([1, 2, 3, 4, 5])
		self.get_node('COE_info/VerticalBars/pe_l').set_text(str(arr))
		pass
