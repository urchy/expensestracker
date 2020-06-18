#!/bin/bash -e

profiles=""

if [[ ${GRAYLOG_HOST} ]]; then
  echo "Graylog logging will be sent to ${GRAYLOG_HOST}"
  profiles="--spring.profiles.active=graylog"
else
  echo "Graylog logging disabled"
fi

# Improved memory management in containers - java 11
java -XX:InitialRAMPercentage=25 -XX:MaxRAMPercentage=100 \
     -Dspring.config.location="file:app/" \
     -cp "app:lib/*" "com.asilva.expensestracker.back.BackApplication" ${profiles}
