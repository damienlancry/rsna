# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory
WORKDIR /app

COPY requirements.txt /app/requirements.txt
# Install any needed packages specified
RUN pip install --upgrade pip \
 && pip install --upgrade cython jupyter jupyter_nbextensions_configurator jupyterthemes \
 && pip install -r requirements.txt

# Don't forget to copy the jupyter folder here
# COPY jupyter /root/.jupyter/
# 
# RUN git clone https://github.com/lambdalisue/jupyter-vim-binding $(jupyter --data-dir)/nbextensions/vim_binding \
#         # Vim bindings
#         && jupyter nbextension enable vim_binding/vim_binding \
#         # Apply the dark theme
#         && jt -t monokai -f fira -fs 11 -nf ptsans -nfs 11 -dfs 10 -ofs 10 -lineh 135 -cursw 2 -cursc g -cellw 100% -T -vim \
#         # Remove a line producing a shitty looking cursor (too wide and two colors)
#         && sed -i '/.cm-s-ipython .CodeMirror-cursor {/,+2d' /root/.jupyter/custom/custom.css \
#         # Replaces fucking italic with normal font for comments
#         && sed -i 's/italic/normal/g' /root/.jupyter/custom/custom.css
# 
# COPY jupyter/custom/custom.js /root/.jupyter/custom/
# COPY jupyter/startup.ipy /root/.ipython/profile_default/startup/startup.ipy
