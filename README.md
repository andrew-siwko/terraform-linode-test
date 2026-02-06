# Andrew's Multicloud Terraform Experiment
## Goal
The goal of this repo is to create a usable VM in the Linode cloud.
This is the one project that was not free for me.  I have been a Linode Customer sinve 2004 and so used my personal account.  The good new is that the nodes created cost no more than $5 a month which is affordable.<br/>
After this step completed I used Ansible to configure and install Tomcat and run a sample application.  [More on that later...](https://github.com/andrew-siwko/ansible-multi-cloud-tomcat-hello)<br/>
It all starts with the [Cloud Console](https://cloud.linode.com/).

## Multicloud
I tried to build the same basic structures in each of the cloud environments.  Each one starts with providers (and a backend), lays out the network and security, creates the VM and then registers the public IP in my DNS.  There is some variability which has been interesting to study.  The Terraform state file is stored on each provider.
* Step 1 - [AWS](https://github.com/andrew-siwko/terraform-aws-test)
* Step 2 - [Azure](https://github.com/andrew-siwko/terraform-azure-test)
* Step 3 - [GCP](https://github.com/andrew-siwko/terraform-gcp-test)
* Step 4 - [Linode](https://github.com/andrew-siwko/terraform-linode-test) (you are here)
* Step 5 - [IBM](https://github.com/andrew-siwko/terraform-ibm-test)

## Build Environment
I stood up my own Jenkins server and built two freestyle jobs to support the Terraform infrastructure builds.  The main job calls 
* terraform init
* terraform plan
* terraform apply -auto-approve
* terraform output (This is piped to mail so I get an e-mail with the outputs.)

Yes, I know plan and apply should be separate and intentional.  In this case I found defects in plan which halted the job before apply.  That was useful.  I also commented out apply until plan was pretty close to working.<br/>
The first Jenkins job contains environment variables with authentication information for the cloud environment and [Linode](https://www.linode.com/) (my registrar).<br/>
The second Jenkins job imports my DNS zone.  I run it only once after the plan is complete.  After that Terraform happily manages records in my existing zone.

## Observations
* This was my fourth cloud provisioning project.  I chose Linode because I've used the company to host Linux virtual machines (LINux NOdes) for many years.
* Linode is an excellent provider of VMs.  Their service is top notch and their prices are good.  
* The linode cli was easy to install but I encountered an issue in the beginning.
* Linode support quickly duplicated my issue and recommended a fix.  Later I had a beta setting enabled which they took care of.
* Provisioning a virtual machine was very natural.  Getting the storage bucket to work was difficult.  I got frustrated at one point and opened a ticket.  
* Linode and IBM were the 2 providers that did not have RHEL 9.7.  In the case of Linode, they don't even offer RHEL.  MyRHEL aligned choices were:
  * Alma Linux (downstream RHEL)
  * Centos Linux (midstream RHEL)
  * Fedora Linux (upstream RHEL)
  * Rocky Linux (downstream RHEL)
* I knew that I wanted to stay downstream of RHEL but ultimatley I couldn't decide and so installed instances of Rocky 9 and Alma 9.
* I liked being able to just give a key to the other cloud providers.  Linode also asked for a root password.  I see the value but I'm just starting with ansible-vault.
* It took me 2 days to get my VMs provisioned.
  * Start: 2026-01-28
  * Functional: 2026-01-30
  * Number of Jenkins builds to success: 34
  * Hurdles: 
    * Getting the right S3 bucket parameters
    * Broken CLI (1 support ticket - quick fix)
    * Finding the right datacenter for my instance (capacity)
    * No RHEL images
    * setting authorized keys required trimspace() around the file content.
