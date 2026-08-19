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
