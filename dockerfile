# Use the Ubuntu base image
FROM ubuntu:latest

# Set the timezone to UTC
ENV TZ=UTC

# Install Squid proxy server
RUN apt-get update && apt-get install -y squid

# Expose port 3128
EXPOSE 3128

# Start Squid proxy in the foreground
CMD ["squid", "-NYCd", "1"]