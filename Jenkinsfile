pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1' // Bölgeyi değiştir
        ECR_REPO = 'sprint-frontend' // ECR repository adı
        IMAGE_TAG = "${ECR_REPO}-${BUILD_NUMBER}"
        AWS_ACCOUNT_ID = '571600829776'
        DOCKER_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/yusufhkran/bcfm_academy_sprint_app.git']]) 
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                cd academy2024-app-main-2/frontend
                docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }
    }
}
