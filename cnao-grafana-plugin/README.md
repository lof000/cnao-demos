# Grafana Plugin
You can spin-up a kubernetes pod running grafana and our grafana plugin

### Reqs
* CNAO license
* helm
* kubernetes
* docker

### Running

* Move to the __image__ folder
* Download the plugin from your AppDynamics  [downloads](https://accounts.appdynamics.com/downloads) site
* Unzip the contents and name de folder appdynamicscloud
* Change __build.sh__ to reflect image:tag you want
* run 
```./build.sh```
* Push the new image to your repo
* Move to the __/helm/grafana/__ folder
* Rename __values_sample.yaml__ to __values.yaml__
* Edit __values_sample.yaml__ adding the information from your tenant
* ```helm install grafana .```



