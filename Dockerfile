FROM taojy123/vlang
RUN mkdir /home/colors/
WORKDIR /home/colors/
COPY . .
RUN v test .
