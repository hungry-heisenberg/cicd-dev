## Overview

- This project aims to build an advanced CI-CD pipeline for a Dockerized Java web application.

- Application runs on **AWS ECS(Fargate)**

This project is divided into three main parts:

1. Initial phase - Installation and configuration of various tools and servers.
    
2. Second phase - Create an advanced end-to-end Jenkins pipeline with multiple stages.

3. Final phase - Deploy application on ECS

## Prerequisites

- JDK 1.8 or later

- Maven 3 or later
 
- AWS account
    
- Terraform,  awscli on local computer

## Technologies

- Spring MVC

- Spring Security

- Spring Data JPA

- Maven

- JSP

## Tools

1. AWS
 
2. Git

3. Maven
  
4. Terraform
  
5. Jenkins
   
6. SonaType Nexus Repository Manager
  
7. SonarQube
   
8. Docker
   
9. Shell Script


 
# Initial phase:  **Installation and configuration**


We utilised Terraform configuration files to deploy AWS resources, while employing shell scripts to configure the instances according to our specifications.

We require three servers for establishing our CICD pipeline infrastructure, all of which are built on the Ubuntu 20 operating system as their foundation.

1.  Jenkins Server -  

 - This setup will serve as the hosting environment for our Jenkins application, facilitating the implementation of our CI/CD pipelines.
 
2. Nexus Repository server - `

 -  **Nexus Repository** Manager offers a centralized platform for storing build artifacts. This server will be responsible for hosting our pair of private repositories: one dedicated to storing WAR artifact files, and the other intended for housing Maven dependencies.

3. SonarQube Server -  

- The SonarQube application will  carry out the continuous inspection of code quality. This involves conducting automated reviews through static code analysis to identify bugs and code issues.


> Generate AWS account and user credentials, essential for Terraform's resource orchestration and Jenkins job's Docker build management within the AWS environment.
 
>  Clone the Git repository

- Using configs in terraform-files directory we will provision all of the AWS resources

# Terraform resources

**- Custom VPC,  Subnets**
**- EC2 instance,  Security groups,  SSH key,** 
**- ECR repository, ECS Cluster, IAM roles, Task definitions, ECS service**


- Setup Jenkins, Nexus and Sonarqube server from Web UI

# Second phase - Setup CICD Pipeline

- Install Jenkins Plugins
  Maven Integration, Github Integration, Nexus Artifact Uploader, Sonarqube Scanner, Pipeline Maven Integration, Docker Pipeline, CloudBees Docker Build and Publish, Amazon ECR, Pipeline: AWS Steps.

- Setup Jenkins Tools
   JDK, MAVEN

-  Add Jenkins Credentials
  GitHub, Nexus, Sonar Token

- Create Web hook in GitHub for pipeline build triggers

- Create Pipeline job and define source code repository and branch
   In Jenkinsfile we have written multi-stage groovy code. 
   1) define tools
   2) define environment variables
   3) stage - build
   4) stage - test
   5) stage - checkstyle analysis
   6) stage - sonar analysis
   7) stage - quality gate
   8) stage - upload artifact
   9) stage - docker build and push to ECR

# Final phase - Deploy application on ECS

   10) stage - use latest image and ECS tasks definitions to launch service with required number of  tasks 