FROM opensuse/archive:latest

# General information
LABEL brianbatesactual.sapnwdocker.version="0.1.0"
LABEL brianbatesactual.sapnwdocker.vendor="Brian Bates"
LABEL brianbatesactual.sapnwdocker.name="Docker for SAP NetWeaver 7.51 Developer Edition"

# Install dependencies
RUN zypper --non-interactive install --replacefiles uuidd expect tcsh which vim hostname tar net-tools iputils libaio iproute2 gzip; \
    zypper clean

# Run uuidd
RUN mkdir /run/uuidd && chown uuidd /var/run/uuidd && /usr/sbin/uuidd

# Copy the downloaded and unrared SAP NW ABAP files to the container
COPY NW751 /var/tmp/NW751/

# We will work from /var/tmp/NW751
WORKDIR /var/tmp/NW751

# Make the install.sh from SAP executable
RUN chmod +x install.sh

# Prepare the shell script to install NW ABAP without asking for user input (using expect)
# Note: Password being used is s@pABAP752
# RUN echo $'#!/usr/bin/expect -f \n\
# spawn ./install.sh -s -k \n\
# set PASSWORD "s@pABAP752"\n\
# set timeout -1\n\
# expect "Do you agree to the above license terms? yes/no:"\n\
# send "yes\\r"\n\
# expect "Please enter a password:"\n\
# send "$PASSWORD\\r"\n\
# expect "Please re-enter password for verification:"\n\
# send  "$PASSWORD\\r"\n\
# expect eof' >> ./run.sh; chmod +x ./run.sh

# Expose the ports to work with NW ABAP
EXPOSE 8000
EXPOSE 44300
EXPOSE 3300
EXPOSE 3200
