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
        cluster = "LNProject"
        service = "my-ecs-service"
        servicetwo = "ecs-svc"
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


        stage("Build and Push"){
            steps{
            sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 971760914448.dkr.ecr.us-west-2.amazonaws.com'
            sh 'docker build . -t lnp-repo -f ./Docker-files/app/Dockerfile'
            sh 'docker tag lnp-repo:latest 971760914448.dkr.ecr.us-west-2.amazonaws.com/lnp-repo:latest'
            sh 'docker push 971760914448.dkr.ecr.us-west-2.amazonaws.com/lnp-repo:latest'
            }
        }
// Use one of the service based on requirements. Using both for demo purpose. For "with LB"  option create ALB and TargetGroups to Fwd traffic to ECS service.

        stage('Deploy to ECS') {
            steps {
                withAWS(credentials: 'awscreds', region: 'us-west-2') {
                    //withoutLB
                    sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment' 
                    //withLB
                    sh 'aws ecs update-service --cluster ${cluster} --service ${servicetwo} --force-new-deployment' 

                } 
            }
        }
         
          


    }
}
  