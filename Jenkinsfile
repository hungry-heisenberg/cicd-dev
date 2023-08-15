pipeline {
    agent any
    tools {
        maven "maven3"
        jdk "jdk8"
    }
    environment {
        SNAP_REPO = "LNP-snapshot"
        RELEASE_REPO = "LNP-release"
        CENTRAL_REPO = "LNP-main"
        NEXUSIP = "10.0.1.67"
        NEXUSPORT = "8081"
        NEXUS_GRP_REPO = "LNP-maven-group"
        NEXUS_LOGIN = "nexuslogin"
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
        registryCredential = 'ecr:us-west-2:awscreds'
        appRegistry = "971760914448.dkr.ecr.us-west-2.amazonaws.com/lnp-repo"
        lnpRegistry = "971760914448.dkr.ecr.us-west-2.amazonaws.com/"
    }


    stages {
        stage('Build'){
            steps {
                // sh 'mvn -U -s settings.xml -DskipTests clean install'
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Test'){
            steps {
                // sh 'mvn -s settings.xml test'
                sh 'mvn test' 
            }

        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
               withSonarQubeEnv("${SONARSERVER}") {
                   sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=lnp-app \
                   -Dsonar.projectName=lnp-app \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
              }
            }
        }

// Before proceeding create QG and attach it to your project in SonarQube. Also create webhook for jenkins
        
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'lnp-app',
                     classifier: '',
                     file: 'target/lnp-app-v1.war',
                     type: 'war']
                  ]
                )
            }
        }

        stage ("echo workspace"){
            steps {
            // Print the workspace path
            sh 'echo "Workspace: ${env.WORKSPACE}"'

            // Use the workspace path to reference files or execute commands
            sh 'ls ${env.WORKSPACE}'
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./Docker-files/app/")
                }
            }
        }
        
        stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( lnpRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }
        


    }
}
  