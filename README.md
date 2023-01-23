# tf-gcp-demoproj-ntier-infra
EADME.md
 
 Introduction :- This terraform module used for 3 tire application  with GKE and Cloudsql .In this module it is also consider defense in depth and isolated with private vpc network.
 Feature included like , private vpc , Defense in defth with private vpc and Cloud Armor,firewall setting wich allow only spefic network .Cloud NAT provides outgoing connectivity
 for privat gke , vm ,cloud run , cloud function , app engine .
  
Purpose of this module 

 A) With Terraform

    1:- It will create a VPC with 2 subnets
       a) web subnet for GKE Autopilot.
       b) data subnet for the Cloud SQL instance.
    2:- NAT gateway attached to web subnet, but not on data subnet as Cloud SQL doesn't need to access the public internet.
    GKE Autopilot.
   3:-  A highly available Cloud SQL MySQL Instance.

B) With Kubectl

    1:- It  will create an annotated Kubernetes service account with Google Service Account that has the necessary permission to connect to the Cloud SQL instance.
    Cloud SQL proxy.
    2:- A Web application. A Kubernetes deployment to connect with our MySQL database with:
    3:- A GKE ingress, to create an external HTTPS Load balancer
    4:- A managed SSL certificate.
    5:- A backend config with IAP and Cloud Armor security policy enabled.
    6:- A frontend config to redirect http requests to https.
