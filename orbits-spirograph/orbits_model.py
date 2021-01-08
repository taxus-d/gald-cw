#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd


# In[2]:


from IPython.display import display, HTML
from ipywidgets import interact, interactive, fixed, interact_manual
import ipywidgets as widgets

get_ipython().run_line_magic('load_ext', 'autoreload')
get_ipython().run_line_magic('autoreload', '2')


# In[3]:


import plotly.express as px
import plotly.graph_objects as go
import plotly.io as pio
pio.templates.default = "plotly_white"


# In[4]:


t = pd.DataFrame({
    'fx0':[1], 'fy0':[1], 'fz0':[2],
    'fx1':[4], 'fy1':[4], 'fz1':[1],
    'fx2':[1], 'fy2':[1], 'fz2':[1],
    'Ax0':[1], 'Ay0':[1], 'Az0':[0.5],
    'Ax1':[0.3], 'Ay1':[0.3], 'Az1':[0],
    'Ax2':[0], 'Ay2':[0], 'Az2':[0],
    'px0':[0], 'py0':[np.pi/2], 'pz0':[0],
    'px1':[0], 'py1':[np.pi/2], 'pz1':[0],
    'px2':[0], 'py2':[0], 'pz2':[0],
})


# In[5]:


def build_orbit(t, rown):
    tt = np.linspace(0,9*np.pi,num=500)
    pos = pd.DataFrame(np.zeros(shape=(len(tt), 3)), columns=['x', 'y', 'z'])
    row = t.loc[rown]
    for c in pos.columns:
        pos[c] += sum(
            (np.cos(tt*row[f"f{c}{i}"] + row[f"p{c}{i}"])*row[f"A{c}{i}"] for i in range(3))
        )
    return pos


# In[8]:


pos = build_orbit(t, 0)


# In[13]:


fig = px.line(pos, 'x', 'y', render_mode='webgl')
fig.update_layout(
    xaxis=dict(range=[-1.5,1.5]),
    yaxis=dict(range=[-1.5, 1.5], scaleanchor="x", scaleratio=1))
fig.update_traces(
    line=dict(width=5, color='darkred'))
None


# In[14]:


fw = go.FigureWidget(fig)


# In[16]:


widgs = dict()
for flsl in ['fx0', 'fx1', 'fy0', 'fy1']:
    widgs[flsl] = widgets.FloatSlider(description=flsl, 
                                      value=1, min=0, max=10, step=0.01)
for flsl in ['Ax0', 'Ax1', 'Ay0', 'Ay1']:
    widgs[flsl] = widgets.FloatSlider(description=flsl, 
                                      value=1, min=0, max=2, step=0.01)
for phsl in ['px0', 'px1', 'py0', 'py1']:
    widgs[phsl] = widgets.FloatSlider(description=phsl, 
                                      value=0, min=-2*np.pi, max=2*np.pi, step=0.01)
widgs['Ax1'].value = 0
widgs['Ay1'].value = 0
widgs['py0'].value = np.pi/2

ui = widgets.HBox([
    widgets.VBox([widgs['fx0'], widgs['fx1'], widgs['fy0'], widgs['fy1']]),
    widgets.VBox([widgs['Ax0'], widgs['Ax1'], widgs['Ay0'], widgs['Ay1']]),
    widgets.VBox([widgs['px0'], widgs['px1'], widgs['py0'], widgs['py1']]),
])

def update(ch):
    with fw.batch_update():
        for k,v in widgs.items():
            t.loc[0, k] = v.value
        pos = build_orbit(t, 0)
        fw.data[0].x = pos['x']
        fw.data[0].y = pos['y']

for k,v in widgs.items():
    widgs[k].observe(update, names="value")

update("whatever")
display(ui,fw)


# In[ ]:





# In[ ]:




