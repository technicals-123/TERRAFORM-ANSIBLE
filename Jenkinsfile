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
        
     stage('Terraform Apply') {
    steps {
        script {
            sh 'terraform init'
            sh 'terraform apply -auto-approve'
        }
    }
}
    }
    
    post {
        always {
            script {
                sh 'terraform destroy -auto-approve' // Destroy infrastructure after job execution
            }
        }
    }
}
