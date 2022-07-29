# GCP Project 
This project is to deploy app in private cluster for more security

**in GCP console**\
create service account and put its json file path serviceAccount email in dev.tfvars file\



## Build the infrastructure of GCP 
**infastructure:**
- Service-account
- VPC
- 2 private-subnets (management, restricted)
- nat
- cloud-router
- firewall (Allow ssh and http)
- vm (bastion host)
- GCR
- GKE

in the folder terraform code run these commands
```
terraform init 
terraform apply --var-file dev.tfvars
```
## create image for the python app  
```
- docker build . -f dockerfile -t challenging
- docker tag challenging gcr.io/belal-357614/challenges
- gcloud auth configure-docker
- docker push gcr.io/belal-357614/challenges
```
## you have to enable iap api to connect to your private instance 

## configration in Bastion instance
**ssh to bastion instance by running**
`gcloud compute ssh --zone "us-central1-a" "bastion-vm"  --tunnel-through-iap --project "belal-357614"`

**install gcloud- and initialize gcloud**
```
$ curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-394.0.0-linux-x86_64.tar.gz
$ tar -xf google-cloud-cli-394.0.0-linux-x86_64.tar.gz
$ ./google-cloud-sdk/install.sh
$ ./google-cloud-sdk/bin/gcloud init
# install gcloud packages and update repo
$ sudo apt-get install apt-transport-https ca-certificates gnupg
$ echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
$ curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
$ sudo apt-get update
$ sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```
**install kubectl**
`$ sudo apt-get install kubectl`

**install tinyproxy**
```
sudo apt-get -y install tinyproxy
sudo service tinyproxy start
```
**connect to the cluster**
gcloud container clusters get-credentials private-cluster --region us-central1 --project belal-357614

# deploy app
```
gcloud compute scp frontend-service.yaml python-deploy.yaml --zone="us-central1-a"  belal@bastion-vm:~/
gcloud compute scp --project=belal-357614  "deplymentsfiles.yml" gcp-instance-name:~/<remote>
kubectl apply -f python-deploy.yaml
kubectl apply -f frontend-service.yaml
```
`kubectl get all`
```
NAME                                       READY   STATUS    RESTARTS   AGE
pod/frontend-deployment-577b7cdcbb-brpkn   1/1     Running   0          20m

NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)          AGE
service/kubernetes   ClusterIP      10.102.0.1       <none>         443/TCP          4h9m
service/lb-service   LoadBalancer   10.102.144.223   34.172.42.61   8000:30010/TCP   86m

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend-deployment   1/1     1            1           80m

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/frontend-deployment-577b7cdcbb   1         1         1       20m
```
![This is an image](/images/app-result.png)
