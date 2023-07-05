# CICD with Gitops
This is a Demo project for testing CI/CD flow using a simple Flask App with Gitlab. For simplicity, I am using a single repo for both the app and deployment code with a sngle branch. The code gets deployed on Dev namespace when the pipeline is executed. Once it's manually triggered, it can be deployed on Prod namespace within the pipeline. 

![Alt text](https://github.com/moonorb/gitops-hello/blob/main/images/cicdwithgitops.PNG)



## Prerequisites
This repo was tested with a "self-hosted Gitlab". Prerequisites are below. There is already a running Kubernetes cluster with ArgocD deployed. 

#### Install Gitlab
```
sudo yum install -y curl policycoreutils-python openssh-server perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.moonorb.cloud" yum install -y gitlab-ee
```
There is an internal DNS which resolves "gitlab.moonorb.cloud"

#### Prepare Repo for Pipeline


#### Install Runner
Runner is installed on the same VM. 
```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install gitlab-runner
sudo gitlab-runner register  --url http://gitlab.moonorb.cloud  --token <TOKEN HERE>
```

Important: Under your Gitlab Project->Settings->CI/CD->General Pipelines(Expand) change "Git Strategy" from its default value of *"git fetch"* to *"git clone"*

#### Install Docker
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker <your existing user>
sudo usermod -aG docker gitlab-runner
sudo systemctl start docker
sudo systemctl enable docker
```


#### Additional Steps on Gitlab Project:
1. Add Image Registry: 
I am using "Nexus Image Registry" deployed as container on another VM on my network running on the following address: "http://registry.moonorb.cloud:5015"

Add the following line to "/etc/gitlab/gitlab.rb" 
registry_external_url 'http://registry.moonorb.cloud:5015'
and run:

```
sudo gitlab-ctl reconfigure
```

After this step we will see a section in Gitlab under "Packages and registries"-> Container Registry

2. Install kubectl
Deploy kubectl on Gitlab VM and copy the .kube/config from your K8s cluster to /home/gitlab-runner/.kube/config so Runner can deploy apps on K8s cluster. 

3.Create Access Token
Project->Settings->Access Tokens (as owner with all scopes)
This token will be used in variables for the runner in pipeline and also for ArgoCD to access the repo.

4. Add variables

Project->Settings->CICD

** Variables: **

CI_USERNAME -> Username used for Gitlab login

CI_PUSH_TOKEN -> Token created on Gitlab

CI_REGISTRY -> FQDN of Nexus

CI_REGISTRY_IMAGE -> Image name of your choosing

CI_REGISTRY_PASSWORD -> exus password

CI_REGISTRY_USER -> Nexus username

Pipeline deploys the  app to Dev and then to Prod namespace

[this](https://medium.com/@andrew.kaczynski/gitops-in-kubernetes-argo-cd-and-gitlab-ci-cd-5828c8eb34d6) is the article which gave me inspiration. 


