FROM ubuntu

RUN apt-get update && apt-get install -y \
  sudo \
  wget \
  libcanberra-gtk-module \
  libcanberra-gtk3-module \
  firefox

RUN export uid=1000 gid=1000 && \
  addgroup --gid ${gid} developer && \
  echo "123\n123\nDeveloper\n\n\n\n\n\n" | adduser --shell "/bin/bash" --uid ${uid} --gid ${gid} developer && \
  usermod -aG sudo developer && \
  echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
  chmod 0440 /etc/sudoers.d/developer

USER developer
ENV HOME /home/developer
CMD /usr/bin/firefox
