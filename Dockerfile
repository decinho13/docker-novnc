FROM decinho13/ros-vnc:latest

COPY . /app
CMD ["/app/entrypoint.sh"]
EXPOSE 7000
