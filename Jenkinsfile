pipeline {
    agent {
        label 'docker'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds()
    }
    stages {
        stage("Simple") {
            environment {
                COMPOSE_FILE = 'simple.yml'
            }            
            steps {
                sh 'docker-compose build'
            }
        }
        stage("Unmanaged") {
            environment {
                COMPOSE_FILE = 'unmanaged.yml'
            }            
            steps {
                sh 'docker-compose build'
            }
        }    
        stage("Managed") {
            environment {
                COMPOSE_FILE = 'managed.yml'
            }            
            steps {
                sh 'docker-compose build'
            }
        }    
    }
}
