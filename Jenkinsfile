pipeline {
    agent any

    environment {
        ARM_CLIENT_ID = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('ARM_CLIENT_SECRET')
        ARM_TENANT_ID = credentials('ARM_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/pranavkumarpk01/TERRAFORM.git'
            }
        }

       stage('Terraform Init') {
    steps {
        script {
            // Run terraform init in the workspace directory
            dir('/var/lib/jenkins/workspace/TERRAFORM') {
                sh 'terraform init'
            }
        }
    }
}

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform configuration
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Always destroy infrastructure after job execution
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
