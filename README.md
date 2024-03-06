# DevSecOps Pipeline Project 

## Overview

This project implements a comprehensive DevSecOps pipeline utilizing AWS EC2 instances to streamline the continuous integration and deployment (CI/CD) process with a strong emphasis on security and monitoring. The setup consists of two AWS EC2 instances:

- **Instance 1**: Dedicated to SonarQube, Trivy, and the Netflix coding standard checker for static code analysis and security scanning.
- **Instance 2**: Hosts Jenkins, Prometheus, and Grafana for CI/CD, monitoring, and visualization, respectively.

The pipeline checks for security issues using SonarQube, Trivy, and OWASP Dependency Checker integrated as plugins in Jenkins. After successful analysis, code is containerized and pushed to Docker Hub. Future enhancements include adopting GitOps with Argo CD for automated deployments to Kubernetes on AWS.

## Pipeline Stages

The pipeline is defined in a Groovy script for Jenkins and includes the following stages:

1. **Clean Workspace**: Prepares the build environment by cleaning the workspace.
2. **Checkout from Git**: Pulls the latest code from the specified Git repository.
3. **SonarQube Analysis**: Performs static code analysis to identify bugs, vulnerabilities, and code smells.
4. **Quality Gate**: Waits for SonarQube's Quality Gate result, ensuring code quality standards are met.
5. **Install Dependencies**: Installs required dependencies for the project using `npm`.
6. **OWASP FS SCAN**: Conducts a dependency check to identify project dependencies' publicly disclosed vulnerabilities.
7. **TRIVY FS SCAN**: Scans the file system for vulnerabilities using Trivy.
8. **Docker Build & Push**: Builds a Docker image from the codebase and pushes it to Docker Hub.
9. **TRIVY Image Scan**: Scans the Docker image for vulnerabilities using Trivy.
10. **Deploy to Container**: Deploys the Docker image as a container, making the application accessible.

### Running the Pipeline

Ensure Jenkins is configured with the necessary plugins and tools (JDK, Node.js, SonarQube scanner, Docker, etc.) as defined in the pipeline script.

**Troubleshooting**: If you encounter a Docker login error, ensure Jenkins has Docker permissions:

```sh
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

## Getting Started with Terraform

This project infrastructure can be provisioned using Terraform. To get started:

1. **Initialize Terraform**:
   ```
   terraform init
   ```
   This command initializes the Terraform environment.

2. **Apply Terraform Configuration**:
   ```
   terraform apply -auto-approve
   ```
   Applies the Terraform configuration to provision the AWS infrastructure as defined. The `--auto-approve` flag skips interactive approval.

3. **Destroy Infrastructure**:
   ```
   terraform destroy -auto-approve
   ```
   Safely tears down the infrastructure provisioned by Terraform when the project is concluded.

Ensure you have AWS CLI configured and Terraform installed on your machine. Always review Terraform configurations before applying them to understand the resources being created, modified, or destroyed.

## Architecture Diagram

![DevSecOps Pipeline Architecture](images/image.png)

*Diagram visualizing the workflow and integration of tools within the pipeline.*

## Tools and Technologies

- **Jenkins**: Automation server for CI/CD pipelines.
- **SonarQube & Trivy**: Tools for static code analysis and vulnerability scanning.
- **Prometheus & Grafana**: Monitoring and visualization.
- **Docker & Docker Hub**: Containerization and image hosting.
- **Terraform**: Infrastructure as Code tool for provisioning and managing cloud resources.
- **Argo CD**: GitOps continuous delivery tool for Kubernetes.

## Contributing

Contributions to improve the pipeline or add new features are welcome. Please fork the repository, make changes, and submit pull requests.

---

*This README provides a high-level overview of the DevSecOps pipeline project. Detailed setup instructions and configurations for each tool and technology can be found in their respective official documentation.*