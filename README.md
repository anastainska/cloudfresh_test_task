# cloudfresh_test_task

# Task 1.1: Setup a CI/CD Pipeline

## Overview

This task involved setting us a CI/CD pipeline for a simple Flask web application. The pipeline was configured using GitHub Actions to automatically run tests on every push and deploy the application to AWS using Terraform.

## Flask Application

The Flask application is a basic web app that displays a list of cafes and allows users to view a page dedicated to each cafe.

## Testing

Dummy tests were written using Python's *unittest* framework to verify the functionality of the Flask app.

## CI/CD Pipeline

The CI/CD pipeline was implemented using GitHub Actions. The pipeline performs the following steps:

1. Checkout the code from the repository.
2. Set up Pythin on the runner.
3. Install dependencies using pip.
4. Run dummy tests.

## Infrastructure Deployment

The deployment of the Flask app was managed with Terraform. The infrastructure includes:
- An EC2 instance running Ubuntu with the Flask app and Nginx.
- A security group to allow HTTP and SSH traffic.
- User data to automate the setup of the Flask app and Nginx.

## GitHub Actions Deployment Workflow

A GitHub Actions workflow was set up to automate the deployment of the Flask app to AWS using Terraform.

## Challenges Faced

- Ensuring the Flask app runs on system startup required configuring the EC2 instance properly.
- Managing secrets securely in GitHub Actions required setting up AWS credentials in the repository secrets.