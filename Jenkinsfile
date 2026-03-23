pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tawa123/cicd-app"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run tests') {
            steps {
                sh '''
                    pip install -r app/requirements.txt
                    cd app && python -m pytest tests/ -v
                '''
            }
        }

        stage('Build Docker image') {
            steps {
                sh "docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded - app is live at http://3.238.8.194/health"
        }
        failure {
            echo "Pipeline failed - check logs above"
        }
    }
}
