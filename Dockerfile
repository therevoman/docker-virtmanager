FROM alpine:3.9

# Setup demo environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
#	DISPLAY_WIDTH=640 \
#	DISPLAY_HEIGHT=480
	DISPLAY_WIDTH=1024 \
	DISPLAY_HEIGHT=768
#	DISPLAY_WIDTH=800 \
#	DISPLAY_HEIGHT=600

# x11vnc is in testing repo
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install git, supervisor, VNC, X11, & virt-manager packages
RUN apk --update --upgrade add \
	bash \
#	fluxbox \
        openbox \
	git \
	supervisor \
	x11vnc \
#    libressl2.6-libcrypto \ 
#    libressl2.6-libssl \
	xvfb \
    dbus-x11 \
    libxext \
    libxtst \
    libxrender \
    virt-manager \
    openssh \
    openssh-askpass \
    openssh-client \
#    razorqt-openssh-askpass \
#    x11-ssh-askpass \
#    ssh-askpass \
    xterm \
   && rm -rf /var/cache/apk/*

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
	&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& apk del git

ADD etc /etc
ADD .xinitrc /root
ADD .ssh /root

# Modify the launch script 'ps -p'
#RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

# Autostart firefox (might not be the best way to do it, but it does the trick)
#RUN     sh -c 'echo "exec openbox-session &" >> ~/.xinitrc' && \
#        sh -c 'echo "virt-manager" >> ~/.xinitrc' && \
#        sh -c 'chmod 755 ~/.xinitrc' 

EXPOSE 8001

VOLUME ["/root/.config/dconf", "/root/.ssh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
