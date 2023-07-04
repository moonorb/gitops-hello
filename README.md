## gitops-hello
This is a Demo project for testing CI/CD folow using a simple Web Application. It works on Gitlab since there is .gitlab-ci.yml file here.  [this](https://medium.com/@andrew.kaczynski/gitops-in-kubernetes-argo-cd-and-gitlab-ci-cd-5828c8eb34d6) is the article which gave me inspiration. 

## Prerequisites

This repo was tested with a "self-hosted Gitlab". Below are the steps I used for installing Gitlab on an Ubuntu VM. There is already a running Kubernetes cluster with ArgocD deployed. 

#### Install Gitlab
```
sudo yum install -y curl policycoreutils-python openssh-server perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.moonorb.cloud" yum install -y gitlab-ee
```
There is an internal DNS which resolves "gitlab.moonorb.cloud"

Add the following line to "/etc/gitlab/gitlab.rb" 
```
registry_external_url 'http://registry.moonorb.cloud:5015'
```
and run:
```
sudo gitlab-ctl reconfigure
```
After this step we will see a section in Gitlab under "Packages and registries"-> Container Registry

Deploy kubectl on Gitlab VM and copy the .kube/config from your K8s cluster to /home/gitlab-runner/.kube/config so Runner can deploy apps on K8s cluster. 

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

#### Image Registry
There are different options for registry. I am using Nexus Image Registry on the following address: "http://registry.moonorb.cloud:5015"

#### Additional Required Steps on Gitlab Project:
Add the below variables 

IMAGE HERE



