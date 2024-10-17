pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1' // Bölgeyi değiştir
        ECR_REPO = 'sprint-frontend' // ECR repository adı
        IMAGE_TAG = "${BUILD_NUMBER}"  // Use BUILD_NUMBER for unique tags
        AWS_ACCOUNT_ID = '571600829776'
        DOCKER_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
        // Consider using credentials for AWS and Docker authentication
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/yusufhkran/bcfm_academy_sprint_app.git']]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the image based on the directory structure
                    sh '''
                        cd academy2024-app-main-2/frontend
                        docker build -t $DOCKER_IMAGE .
                    '''
                }
            }
        }

        stage('Test Image (Optional)') {
            // Add unit/integration tests for the image (consider tools like JUnit, TestNG, etc.)
            steps {
                // ... Test steps here ...
            }
        }

        stage('Login to ECR') {
            steps {
                // Consider using credentials for AWS authentication
                script {
                    def credentialsId = 'ecr-credentials' // Replace with your credential ID
                    def credentials = credentialsStore.lookupCredentials(
                        credentialsId: credentialsId,
                        descriptorId: 'Amazon Web Services Credentials'
                    )
                    sh """
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin ${credentials.accessKey}:${credentials.secretKey} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Update Helm Chart (Conditional)') {
            steps {
                script {
                    // Check for changes in the Helm chart directory (replace 'helm-chart' with your actual directory)
                    def hasChanges = sh(returnStdout: true, script: 'git diff --name-only helm-chart/') != ''
                    if (hasChanges) {
                        // Update the Helm chart values.yaml with the new image tag (replace 'image:' with your actual image path)
                        sh '''
                            sed -i "s|image:.*|image: ${DOCKER_IMAGE}|g" helm-chart/values.yaml
                        '''
                        // Optionally, run Helm commands to package or deploy the updated chart
                        sh '''
                            helm package helm-chart
                            helm upgrade my-release helm-chart*.tgz -n my-namespace
                        '''
                    } else {
                        echo 'No changes detected in Helm chart. Skipping update.'
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker containers/images (optional)
            sh 'docker system prune -f'
        }
    }
}
