---
page_title: "Jarvis"
---

[![Build Status](https://git.bink.com/DevOps/Cookbooks/jarvis/badges/master/pipeline.svg)](https://git.bink.com/DevOps/Cookbooks/jarvis)

This cookbook deploys the Prometheus Node Exporter, direct from the GitHub release. It handles updating the node exporter and downgrading as well. To update the node exporter version, update `attributes/default.rb` with the version number and the packages SHA256 checksum.

Node Exporter will listen on 9100.
