# command to create cronjob:
# $ whenever --update-crontab 
# This will set production environment by default.
# For setting different environment  eg. development:
# $ whenever --update-crontab --set environment='<environment>'

# "/bin/bash: script/rails: Permission denied" - If following error shows up in log file, execute the following command:
# $ chmod u+x script/rails

set :output, "log/cron.log"

every 1.day do
	runner "Location.cron_update"
end
