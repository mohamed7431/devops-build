pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([\$class: 'GitSCM',
          branches: branches: [[name: '*/${GIT_BRANCH:-main}']],
          userRemoteConfigs: [[url: 'https://github.com/mohamed7431/devops-build.git', credentialsId: 'github-creds']]
        ])
      }
    }

    stage('Build') {
      steps {
        script {
          def tag = "mohamed7431:${BUILD_NUMBER}"
          docker.build(tag, 'build/')
        }
      }
    }

    stage('Push') {
      steps {
        script {
          docker.withRegistry('', 'dockerhub-creds') {
            docker.image("mohamed7431:${BUILD_NUMBER}").push()
          }
        }
      }
    }

    stage('Deploy to Dev') {
      when { branch 'dev' }
      steps {
        sshagent(['ec2-ssh-key']) {
          sh "ssh -o StrictHostKeyChecking=no ubuntu@${aws_instance.dev.public_ip} 'docker pull mohamed7431:${BUILD_NUMBER} && docker stop myapp || true && docker rm myapp || true && docker run -d --name myapp -p 80:80 mohamed7431:${BUILD_NUMBER}'"
        }
      }
    }

    stage('Deploy to Prod') {
      when { branch 'master' }
      steps {
        sshagent(['ec2-ssh-key']) {
          sh "ssh -o StrictHostKeyChecking=no ubuntu@${aws_instance.prod.public_ip} 'docker pull mohamed7431:${BUILD_NUMBER} && docker stop myapp || true && docker rm myapp || true && docker run -d --name myapp -p 80:80 mohamed7431:${BUILD_NUMBER}'"
        }
      }
    }
  }

  post {
    always {
      echo "Build ${BUILD_NUMBER} finished with status: ${currentBuild.currentResult}"
    }
  }
}
