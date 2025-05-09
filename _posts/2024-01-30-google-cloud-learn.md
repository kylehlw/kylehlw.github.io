---
layout: post
title:  "Google Cloud Learn"
date:   2024-01-30 10:00:00 +0800
categories: tech
---
I've been working on learning Google Cloud recently, and I wanted to share some of my experiences and resources.

Here is the listing for potential use cases.

Details of the program: [PDF](https://services.google.com/fh/files/misc/startup_onepager.pdf)

## Courses

I've been primarily using the official Google Cloud Skills Boost platform, which offers a variety of courses and learning paths. Some of the courses I've completed include:

- Google Cloud Platform Fundamentals: Core Infrastructure
- Networking in Google Cloud
- Security in Google Cloud Platform

These courses provide a good overview of the different services offered by Google Cloud, and they include hands-on labs to help you practice what you've learned.

### Analytics Query and Pipeline

Exploring BigQuery to replace athena. [![](https://www.gstatic.com/cgc/favicon.ico)BigQuery | AI data platform | Lakehouse | EDW](https://cloud.google.com/bigquery/?utm_source=google&utm_medium=cpc&utm_campaign=japac-SG-all-en-dr-BKWS-all-all-trial-PHR-dr-1605216&utm_content=text-ad-none-none-DEV_c-CRE_649002494368-ADGP_Hybrid+%7C+BKWS+-+BRO+%7C+Txt+~+Data+Analytics_BigQuery_bigquery_main-KWID_43700075889240721-aud-2079991351570:kwd-33969409261&userloc_9062542-network_g&utm_term=KW_bigquery&gad_source=1&gclid=CjwKCAiAk9itBhASEiwA1my_69n33vwzkHsXoHAASLBkDEjGAjUvnAEUzRHch4EcCRMiwjjhfhKFRxoCcDcQAvD_BwE&gclsrc=aw.ds&hl=en)

Analytics backend switched from S3 + athena to **GS** + big query.

In house airflow → compose or data flow directly. [![](https://www.gstatic.com/devrel-devsite/prod/v0d244f667a3683225cca86d0ecf9b9b81b1e734e55a030bdcd3f3094b835c987/cloud/images/favicons/onecloud/favicon.ico)Cloud Composer | Google Cloud](https://cloud.google.com/composer?hl=en)

Looker → Data Visualization. [![](https://www.gstatic.com/cgc/favicon.ico)Looker Studio: Business Insights Visualizations | Google Cloud](https://cloud.google.com/looker-studio?utm_source=google&utm_medium=cpc&utm_campaign=japac-SG-all-en-dr-SKWS-all-all-trial-DSA-dr-1605216&utm_content=text-ad-none-none-DEV_c-CRE_647923039857-ADGP_Hybrid+%7C+SKWS+-+BRO+%7C+DSA+~+All+Webpages-KWID_39700075148142355-aud-1596662388934:dsa-19959388920&userloc_9062542-network_g&utm_term=KW_&gad_source=1&gclid=CjwKCAiAk9itBhASEiwA1my_6xJG-coqqcP-UVJKsx3ao1t0g4Jmi-O0wuzHn5RGr0VHMBEICOERphoCht4QAvD_BwE&gclsrc=aw.ds&hl=en)

### Cold Storage

Would it feasible to store some archive data in **GCS** archive storage? Any service available like AWS Snowball to move data in cheap way.

[![](https://www.gstatic.com/cgc/favicon.ico)Cloud Storage Options](https://cloud.google.com/products/storage/?utm_source=google&utm_medium=cpc&utm_campaign=japac-SG-all-en-dr-BKWS-all-all-trial-PHR-dr-1605216&utm_content=text-ad-none-none-DEV_c-CRE_648963674637-ADGP_Hybrid+%7C+BKWS+-+BRO+%7C+Txt+~+Storage_Cloud+Storage_gcp+storage_main-KWID_43700075875309325-aud-1596662388934:kwd-1731096149025&userloc_9062542-network_g&utm_term=KW_google+storage+cloud&gad_source=1&gclid=CjwKCAiAk9itBhASEiwA1my_67usCmqwxfqZ9UsWZaH9A2lWClBve-tPUakm47A8lctPw6FPdo1YahoCdqIQAvD_BwE&gclsrc=aw.ds&hl=en)

[![](https://www.gstatic.com/devrel-devsite/prod/va15d3cf2bbb0f0b76bff872a3310df731db3118331ec014ebef7ea080350285b/cloud/images/favicons/onecloud/favicon.ico)Overview  |  Transfer Appliance  |  Google Cloud](https://cloud.google.com/transfer-appliance/docs/4.0/overview?_gl=1*d3uc1w*_up*MQ..&gclid=CjwKCAiAk9itBhASEiwA1my_610YT3vGXk5zdZIUwP0yNrGLR3Ay08Yjn6V5vb_9lqvnn6wbHxpCphoChIEQAvD_BwE&gclsrc=aw.ds)

### CI/CD

Any good codebuild replacement in GCP? Or we switch to more cloud provider agnostic solutions like github actions.

[GitHub - terraform-google-modules/terraform-google-github-actions-runners: Creates self-hosted GitHub Actions Runners on Google Cloud](https://github.com/terraform-google-modules/terraform-google-github-actions-runners)

### Service Deployment

Should we setup hybrid env cross office servers + cloud servers?

[![](https://www.gstatic.com/devrel-devsite/prod/v0d244f667a3683225cca86d0ecf9b9b81b1e734e55a030bdcd3f3094b835c987/cloud/images/favicons/onecloud/favicon.ico)Google Distributed Cloud](https://cloud.google.com/distributed-cloud)

[![](https://www.gstatic.com/devrel-devsite/prod/v0d244f667a3683225cca86d0ecf9b9b81b1e734e55a030bdcd3f3094b835c987/cloud/images/favicons/onecloud/favicon.ico)Anthos Powers Enterprise Container Platforms](https://cloud.google.com/anthos?hl=en)

### ML Training in GCP

[![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Introduction to Vertex AI  |  Google Cloud](https://cloud.google.com/ai-platform/docs/technical-overview)

## Labs

The hands-on labs are a great way to get practical experience with Google Cloud. They cover a wide range of topics, from setting up virtual machines to configuring networks and deploying applications.

### My Works Setup

#### Install  corresponding tools

* Terraform for infra management. [![](https://developer.hashicorp.com/favicon.ico)Terraform | HashiCorp Developer](https://www.terraform.io/)
* GCP cli. [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)gcloud CLI overview  |  Google Cloud CLI Documentation](https://cloud.google.com/sdk/gcloud)  [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Install the gcloud CLI  |  Google Cloud CLI Documentation](https://cloud.google.com/sdk/docs/install)

##### CLI Basic Setup

Get user created in gcloud console

```
# Setup your gcloud cli
gcloud init

#Terraform use ADC auth, https://cloud.google.com/docs/authentication/provide-credentials-adc#how-to
gcloud auth application-default login
```

Ensure we are using the following project to setup all GCP resources

```
PROJECT_ID             NAME              PROJECT_NUMBER
xxxxgcp                xxxxGCP           731?????????1
```

##### Terraform Basic Setup

###### Before we start

* Before start, can have a quick glance of this official documentations. [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Terraform on Google Cloud documentation](https://cloud.google.com/docs/terraform)
* Tons of good examples. [GitHub - terraform-google-modules/terraform-docs-samples: Terraform samples intended for inclusion in cloud.google.com](https://github.com/terraform-google-modules/terraform-docs-samples/tree/main)
* Official google provider doc. [![](https://registry.terraform.io/images/favicons/favicon-16x16.png)Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

###### Infra Code Structure

```
infra
└── terraform
    ├── aws
    │   ├── cloud_infra
    │   └── init_setup
    └── gcp
        ├── cloud_infra
        └── init_setup
```

**init_setup** to setup basic terraform remote backend storage. ( **NOTE** : this only need run once in **MYWork**, in general, we should not need to run it.)

**cloud_infra** to setup gcp infra.

#### VPC Network Plan

IP range need to avoid.

| **IP Range** | **Description**   |
| ------------------ | ----------------------- |
| 192.168.0.0/16     | office network          |
| 100.172.0.0/16     | **PPP**SIT server |
| 100.66.0.0/15      | PPP-PROD Server         |

Proposed IP Range for VPC and subnets

| **IP Range** | **Description**            |
| ------------------ | -------------------------------- |
| 10.100.0.0/16      | asia-southeast-2 public subnet   |
| 10.101.0.0/16      | asia-southeast-2 private subnet  |
| 10.202.0.0/16      | prod VPC Native**GKE**pods |
| 10.203.0.0/16      | prod VPC NativeGKEservice        |

Private google service access is enabled. [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Private Google Access  |  VPC  |  Google Cloud](https://cloud.google.com/vpc/docs/private-google-access)

Current setup in infra code:  develop/infra/terraform/gcp/cloud_infra/components/vpc

> Currently, there is no limits to add public IP to instance in private subnet, but that is not suggested. If anything need to b accessed from outside, and need a public ip. Put those in public subnet.

## GKE in GCP

First Testing GKE cluster will be a vpc native cluster.

### Basic GCP/GKE Knowledge

* Spot vs Premptive [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Preemptible VM instances  |  Compute Engine Documentation  |  Google Cloud](https://cloud.google.com/compute/docs/instances/preemptible)
* VPC-Native Cluster [![](https://www.gstatic.com/devrel-devsite/prod/v18af98722840dca56faefae94257d94871f07ae68e6f6225c2963b4f21ad2128/cloud/images/favicons/onecloud/favicon.ico)VPC-native clusters  |  GKE networking  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips)
* Node Taints [![](https://kubernetes.io/icons/favicon-16.png)Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
* GKE Autoscaling [![](https://www.gstatic.com/devrel-devsite/prod/v18af98722840dca56faefae94257d94871f07ae68e6f6225c2963b4f21ad2128/cloud/images/favicons/onecloud/favicon.ico)Autoscaling a cluster  |  Google Kubernetes Engine (GKE)  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-autoscaler) [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Vertical Pod autoscaling  |  Google Kubernetes Engine (GKE)  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/concepts/verticalpodautoscaler) [![](https://www.gstatic.com/devrel-devsite/prod/va15d3cf2bbb0f0b76bff872a3310df731db3118331ec014ebef7ea080350285b/cloud/images/favicons/onecloud/favicon.ico)Horizontal Pod autoscaling  |  Google Kubernetes Engine (GKE)  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/concepts/horizontalpodautoscaler)

### Create GKE with Terraform

* Module Used [![](https://registry.terraform.io/images/favicons/favicon-16x16.png)Terraform Registry](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)  Known issue. [Unable to create multiple node piools · Issue #1397 · terraform-google-modules/terraform-google-kubernetes-engine](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1397)
* Configured with VPC / subnets / secondary ip ranges configured above
* Configured with 1 persist node pool, 1 spot node pool.
* Default service account has read/write access to gcs.

Details as here: develop/infra/terraform/gcp/cloud_infra/components/gke

### How to use created GKE cluster

Install gke auth plugin

```
sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin
```

Get k8s config

```
gcloud container clusters get-credentials xxxx-gke-prod --region asia-southeast1 --project xxxxgcp
```

Then use your normal k8s tool chain to access this cluster.

## Enable and use GAR

Google deprecated **GCR** and moved to GAR (google artifacts registry)

Setup GAR to push images that can be used in GKE cluster.

[![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)Artifact Registry documentation  |  Google Cloud](https://cloud.google.com/artifact-registry)

### Setup local credential config

```
# Authenticate local client
gcloud auth login

# Add credentials config in docker config
gcloud auth configure-docker asia-southeast1-docker.pkg.dev

# Check out the config
cat ~/.docker/docker.config
```

### Create GAR Repo

Before we can use GAR. we need create docker repo in GAR with terraform.

Currently following GAR repo are created with terraform. develop/infra/terraform/gcp/cloud_infra/components/gar/gar.tf#L3

* tmp-repo: temp images for testing
* github-action-runner: customized github action runner image.

### Push/Pull Image from Repo with docker cli

Example of push to **tmp-repo** in **xxxgcp** project deployed in **asia-southeast1** region

```
docker tag hello-world:latest asia-southeast1-docker.pkg.dev/xxxxgcp/tmp-repo/hello-world:1.0
docker push asia-southeast1-docker.pkg.dev/xxxxgcp/tmp-repo/hello-world:1.0
```

### Push/Pull Image from GKE

If GKE cluster created with default gke service account, no additional auth setup needed. Nodes should be able to pull image from gar directly.

If GKE cluster created customized service account, ensure proper roles are assigned to the services account and put correct access scope.

> The authorization provided to applications hosted on a Compute Engine instance is limited by two separate configurations: the [roles granted to the attached service account](https://cloud.google.com/compute/docs/access/service-accounts#usingroles "https://cloud.google.com/compute/docs/access/service-accounts#usingroles"), and the [access scopes](https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam "https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam") that you set on the instance. Both of these configurations must allow access before the application running on the instance can access a resource.
>
> Access scopes are the legacy method of specifying authorization for Compute Engine VMs. To pull images from Artifact Registry repositories, GKE nodes must have the storage read-only access scope or another storage access scope that includes storage read access.

```

locals {
  all_service_account_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/storage.folderAdmin",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.repoAdmin", # This is important
  ]
}

resource "google_project_iam_member" "gke" {
  for_each = toset(local.all_service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke.email}"
}

   node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.full_control", ## This is important
    ]
  }
```

develop/infra/terraform/gcp/cloud_infra/components/gke/gke.tf#L27

develop/infra/terraform/gcp/cloud_infra/components/gke/gke.tf#L101

## GCS Usage Quickstart

This page shows you how to perform basic tasks in Cloud Storage using the gcloud command-line tool.

 [![](https://www.gstatic.com/devrel-devsite/prod/v18af98722840dca56faefae94257d94871f07ae68e6f6225c2963b4f21ad2128/cloud/images/favicons/onecloud/favicon.ico)Quickstart: Discover object storage with the gcloud tool  |  Cloud Storage  |  Google Cloud](https://cloud.google.com/storage/docs/discover-object-storage-gcloud)

## get GCS bucket

```
# gcloud storage ls
gs://xxxxgcp-analytics/
gs://xxxxgcp-bucket-tfstate/
gs://xxxxgcp-dbbackup/
```

`gs://xxxxgcp-dbbackup/`  Use for FreeRADIUS server database backup bucket.

## upload/download from GCS bucket

```
# gcloud storage cp
```

## Future Work

* Pair with office network. [![](https://www.gstatic.com/devrel-devsite/prod/va15d3cf2bbb0f0b76bff872a3310df731db3118331ec014ebef7ea080350285b/cloud/images/favicons/onecloud/favicon.ico)Best practices for Cloud VPN  |  Google Cloud](https://cloud.google.com/network-connectivity/docs/vpn/concepts/best-practices) [![](https://www.gstatic.com/devrel-devsite/prod/va15d3cf2bbb0f0b76bff872a3310df731db3118331ec014ebef7ea080350285b/cloud/images/favicons/onecloud/favicon.ico)Prepare for Hybrid Subnets connectivity  |  VPC  |  Google Cloud](https://cloud.google.com/vpc/docs/prepare-for-hybrid-subnet-connectivity)
* Investigate different auto scaling setups for k8s. [![](https://www.gstatic.com/devrel-devsite/prod/v8d1d0686aef3ca9671e026a6ce14af5c61b805aabef7c385b0e34494acbfc654/cloud/images/favicons/onecloud/favicon.ico)About GKE cluster autoscaling  |  Google Kubernetes Engine (GKE)  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler)

## Certifications

I'm currently working towards the Associate Cloud Engineer certification. This certification is designed for individuals who have a foundational understanding of Google Cloud and can perform common tasks, such as deploying and managing applications, monitoring operations, and managing cloud resources.

## Resources

Here are some additional resources that I've found helpful:

- Google Cloud documentation: The official documentation is a comprehensive resource for all things Google Cloud.
- Google Cloud blog: The blog features articles on a variety of topics, including new product releases, best practices, and customer stories.
- Stack Overflow: A great place to ask questions and get help from the community.
