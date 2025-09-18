pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "mohamed7431"
        DEV_IMAGE      = "guvi-react-dev"
        PROD_IMAGE     = "guvi-react-prod"
        BRANCH         = "${env.BRANCH_NAME}" // Automatically detect branch
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = (env.BRANCH == "dev") ? DEV_IMAGE : PROD_IMAGE

                    echo "Building Docker image ${DOCKERHUB_USER}/${imageName}:${env.BRANCH}"

                    // Build Docker image using Dockerfile in react-app folder
                    sh """
                    docker build -t ${DOCKERHUB_USER}/${imageName}:${env.BRANCH} \
                        -f react-app/Dockerfile ./react-app
                    """

                    // Tag also as "latest"
                    sh "docker tag ${DOCKERHUB_USER}/${imageName}:${env.BRANCH} ${DOCKERHUB_USER}/${imageName}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def imageName = (env.BRANCH == "dev") ? DEV_IMAGE : PROD_IMAGE

                        echo "Logging in to Docker Hub"
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'

                        echo "Pushing Docker images"
                        sh "docker push ${DOCKERHUB_USER}/${imageName}:${env.BRANCH}"
                        sh "docker push ${DOCKERHUB_USER}/${imageName}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def imageName = (env.BRANCH == "dev") ? DEV_IMAGE : PROD_IMAGE

                    echo "Stopping existing container (if any)"
                    sh "docker stop react-app || true"
                    sh "docker rm react-app || true"

                    echo "Running new container"
                    sh """
                    docker run -d \
                        --name react-app \
                        -p 3000:80 \
                        --restart unless-stopped \
                        ${DOCKERHUB_USER}/${imageName}:${env.BRANCH}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! 🎉"
        }
        failure {
            echo "Pipeline failed ❌ Check above logs for Docker build errors."
        }
    }
}
