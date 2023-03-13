# Set the base image to Ubuntu 16.04
FROM ubuntu:16.04

LABEL authors="eva.hamrud@kcl.ac.uk" \
      description="Docker image containing cellranger-atac"

# update apt-get and install
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

# Install cellranger-atac
RUN cd /opt/ && \
  wget -O cellranger-atac-2.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-atac/cellranger-atac-2.0.0.tar.gz?Expires=1644625687&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hdGFjL2NlbGxyYW5nZXItYXRhYy0yLjAuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2NDQ2MjU2ODd9fX1dfQ__&Signature=baIO-IDFeoDesXx6gpNWvyDbwgy2Pr021AfKFP~uzflPGR~l1Ostf5G2csSgIDidGQDsRYHBUuzC61VjjQ6oPm5WhRBetaQMMD7JYxRer7Qv72bCfuvyvLxBs~~wcNOdJ~B-q1tHDRBEHVcbgesKY0iDdQgKQJ2zRqdn4h~F5ZShHPP~1vn7qFkf4N-tJlIp9RMUOyWziTTLWnBa7QcMZJp1ynOgcx7oUvFApP0lSy9K1vuoJjrH0m9nE-zK4gJIgTvwK0GsL0HFZ0wXiDCsyRsbkHwNrWN~L8WN2jrOqlLnnMwZ91NeliQZt6PO-CLk7Cmqq1NWIgewbWlzwpqlTQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" && \
  tar -xzvf cellranger-atac-2.0.0.tar.gz && \
	rm -f cellranger-atac-2.0.0.tar.gz

# Set path
ENV PATH /opt/cellranger-atac-2.0.0:$PATH
