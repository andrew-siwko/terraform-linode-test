# Andrew's Multicloud Terraform Experiment
## Overview
This experiment uses Terraform to create a single virtual machine on Linode's cloud.  It is part of a series of experiments begun in early 2026.  This is the one project that was not free for me.  I have been a Linode Customer since 2004 and so used my personal account.  The good new is that the nodes created cost no more than $5 a month which is affordable.  I have structured the Terraform files with sequence numbers to show the logical flow of resource creation.  Roughly the sequence is:
* 00-create-resources.bash
  * This file contains shell commands and notes used to manipulate the cloud environment from the CLI.  My approach has been to make things work and then Terraform them.  Thus you may see commands to discover the instance types which I used to hard code server creation.  These were later replaced with lookups inside terraform.  the commands and notes may still be useful.
* 01-variables.auto.tfvars, 01-variables.tf
  * The two variable files contain parameters factored out of the main code and their definitions.  As the configuration code matured and I added more cloud providers, it became clear that certain parameters could be pulled up for ease of use.
* 02-providers.tf
  * This file contains the top level terraform{} block which contains required providers, by necessity, the backend definition and connects providers to required variables.  i would have liked to split the backend into a separate file but there may only be one terraform{} block and the rest of the world uses providers.  In these projects I have stored the tfstate file on the cloud provider rather than defining local storage.  I found this proceess to be difficult and educational.
* 03-network.tf
  * This file specifies network elements.  In a basic, single VM case, it is not generally needed.  As soon as you want to control traffic with a firewall or security group, the network definition is required to attach the rules.
* 04-security-group.tf, 04-firewall.tf, 04-security-list.tf
  * This file defines how network traffic flows in and out of the network to your instance.
* 05-ec2.tf, 05-machine.tf, 05-droplet.tf, 05-servers.tf
  * This file contains the virtual machine definition and mapping to other resources.
* 06-domain.tf
  * This small file contains the DNS Zone resource for a Linode zone and an A record for the IP address of the virtual machine.  The zone record is imported from the existing Linode zone and is marked as "prevent_destroy" to avoind domain deletion.
* 07-outputs.tf
  * This file contains outputs from Terraform state at the end of the process.  During development, I leaned on this heavily to discover internal states and key names.  Once finished, I leave the public IP of the instance in the output for validation.

Except for Linode, with whom I have an existing paid relationship, all other instances were provisioned using a free trial.
Once Terraform provisioning is complete, I use Ansible to configure and install Tomcat, set an apache proxy and install a sample application.  [More on that later...](https://github.com/andrew-siwko/ansible-multi-cloud-tomcat-hello)<br/>
It all starts with the [Cloud Console](https://cloud.linode.com/).

## Multicloud
I tried to build the same basic structures in each of the cloud environments.  Each one starts with providers (and a backend), lays out the network and security, creates the VM and then registers the public IP in my DNS.  There is some variability which has been interesting to study.  The Terraform state file is stored on each provider.
* Step 1 - [AWS](https://github.com/andrew-siwko/terraform-aws-test)
* Step 2 - [Azure](https://github.com/andrew-siwko/terraform-azure-test)
* Step 3 - [GCP](https://github.com/andrew-siwko/terraform-gcp-test)
* Step 4 - [Linode](https://github.com/andrew-siwko/terraform-linode-test) (you are here)
* Step 5 - [IBM](https://github.com/andrew-siwko/terraform-ibm-test)
* Step 6 - [Oracle OCI](https://github.com/andrew-siwko/terraform-oracle-test) 
* Step 7 - [Digital Ocean](https://github.com/andrew-siwko/terraform-digital-ocean-test)

## Build Environment
I stood up my own Jenkins server and built a freestyle job to support the Terraform infrastructure builds.
* terraform init
* _some bash to import the domain (see below)_
* terraform plan
* terraform apply -auto-approve
* terraform output (This is piped to mail so I get an e-mail with the outputs.)

Yes, I know plan and apply should be separate and intentional.  In this case I found defects in plan which halted the job before apply.  That was useful.  I also commented out apply until plan was pretty close to working.<br/>
The Jenkins job contains environment variables with authentication information for the cloud environment and [Linode](https://www.linode.com/) (my registrar).<br/>
I did have a second job to import the domain zone but switched to a conditional in a script.  The code checks to see whether my zone record has been imported.  If not, the zone creation will fail.
```bash
if ! terraform state list | grep -q "linode_domain.dns_zone"; then
  echo "Resource not in state. Importing..."
  terraform import linode_domain.dns_zone 3417841
else
  echo "Domain already managed. Skipping import."
fi
```

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
* It took me 2 days to get my VM provisioned.
* Project stats:
  * Start: 2026-01-28
  * Functional: 2026-01-30
  * Number of Jenkins builds to success: 34
  * Hurdles: 
    * Getting the right S3 bucket parameters
    * Broken CLI (1 support ticket - quick fix)
    * Finding the right datacenter for my instance (capacity)
    * No RHEL images
    * setting authorized keys required trimspace() around the file content.
