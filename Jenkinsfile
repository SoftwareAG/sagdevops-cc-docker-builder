pipeline {
    agent {
        label 'docker'
    }
    environment {
        COMPOSE_PROJECT_NAME = 'sagdevopsccdockerbuilder'
        RELEASE = '10.1'
    } 
    stages {
        stage("Build") {
            steps {
                sh 'envsubst < init-$RELEASE.yaml > init.yaml && cat init.yaml'
                sh 'docker-compose build simple'
                sh 'docker-compose build unmanaged'
                sh 'docker-compose build managed'
                sh 'docker images | grep msc'
            }
        }
        stage("Test") {
            steps {
                sh 'docker-compose run --rm init'
                sh 'docker-compose up -d managed'
                sh 'docker-compose run --rm test'
            }
            post {
                always {
                    sh 'docker-compose logs'
                    sh 'docker-compose down'
                }
            }
        }
    }
}
