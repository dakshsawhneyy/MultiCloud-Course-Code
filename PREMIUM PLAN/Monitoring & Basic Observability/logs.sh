# Create a simple log file:
sudo mkdir -p /var/log/student-app
sudo touch /var/log/student-app/app.log

# Generate some sample logs:
echo "INFO Student application started" | sudo tee -a /var/log/student-app/app.log
echo "INFO Student 101 retrieved profile" | sudo tee -a /var/log/student-app/app.log
echo "WARN Database connection pool is high" | sudo tee -a /var/log/student-app/app.log
echo "ERROR Database connection timeout" | sudo tee -a /var/log/student-app/app.log

# Now the file contains:
INFO Student application started
INFO Student 101 retrieved profile
WARN Database connection pool is high
ERROR Database connection timeout

#################################
# Send logs to cloudwatch loggroup

sudo systemctl status amazon-cloudwatch-agent

#Install the cloud-watch agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

sudo systemctl status amazon-cloudwatch-agent

# Add forwarding log group
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Put this in it:
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/student-app/app.log",
            "log_group_name": "/student-loggroup",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 7
          }
        ]
      }
    }
  }
}


# Verify
sudo cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json


# Start the agent with your config:
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

