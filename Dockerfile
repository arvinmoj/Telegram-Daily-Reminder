FROM ubuntu:latest
RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install curl
RUN apt-get update && apt-get -y install jq
COPY . /root
RUN chmod 0644 /root/app.sh
RUN crontab -l | { cat; echo "0 0 * * * bash /root/app.sh >> /var/log/cron.log 2>&1"; } | crontab -
RUN touch /var/log/cron.log
CMD cron && tail -f /var/log/cron.log