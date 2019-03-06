FROM osrf/ros:kinetic-desktop-full

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      fluxbox \
      git \
      net-tools \
      novnc \
      socat \
      supervisor \
      x11vnc \
      xterm \
      xvfb

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes
RUN apt-get install -y ros-kinetic-moveit wget python-catkin-tools
RUN mkdir /src
RUN source opt/ros/kinetic/setup.bash && catkin init
RUN cd src && \
    git clone https://github.com/shadow-robot/pysdf.git && \
    git clone https://github.com/shadow-robot/gazebo2rviz.git
RUN wget https://raw.githubusercontent.com/osrf/osrf-rosdep/master/gazebo7/00-gazebo7.list -O /etc/ros/rosdep/sources.list.d/00-gazebo7.list
RUN rosdep update && rodep install --default-yes --all
RUN catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libjansson-dev nodejs libboost-dev imagemagick libtinyxml-dev mercurial cmake build-essential xvfb
RUN cd /root
RUN hg clone -r gzweb_1.3.0 https://bitbucket.org/osrf/gzweb
RUN source "/workspace/devel/setup.bash" &&\
    source "/usr/share/gazebo/setup.sh"
RUN cd /root/gzweb && ./deploy.sh
COPY . /app
CMD ["sudo","bash","/app/entrypoint.sh"]
EXPOSE 7000 8080
