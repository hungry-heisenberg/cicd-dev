pipeline {
    agent any
    tools {
        maven "maven3"
        jdk "jdk8"
    }
    environment {
        SNAP_REPO = "LNP-snapshot"
        NEXUS_USER = "admin"
        NEXUS_PASS = "omkar"
        RELEASE_REPO = "LNP-release"
        CENTRAL_REPO = "LNP-main"
        NEXUSIP = "10.0.1.67"
        NEXUSPORT = "8081"
        NEXUS_GRP_REPO = "LNP-maven-group"
        // NEXUS_LOGIN = "c2102648-56ff-44fc-95ac-1eaf17d048ad"
        NEXUS_LOGIN = "nexuslogin"
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
    }
    stages {
        stage('Build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests clean install'
                // sh 'mvn -DskipTests install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        // stage('Test'){
        //     steps {
        //         // sh 'mvn -s settings.xml test'
        //         sh 'mvn test' 
        //     }

        // }

        // stage('Checkstyle Analysis'){
        //     steps {
        //         sh 'mvn -s settings.xml checkstyle:checkstyle'
        //     }
        // }

        // stage('Sonar Analysis') {
        //     environment {
        //         scannerHome = tool "${SONARSCANNER}"
        //     }
        //     steps {
        //        withSonarQubeEnv("${SONARSERVER}") {
        //            sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=lnp-app \
        //            -Dsonar.projectName=lnp-app \
        //            -Dsonar.projectVersion=1.0 \
        //            -Dsonar.sources=src/ \
        //            -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
        //            -Dsonar.junit.reportsPath=target/surefire-reports/ \
        //            -Dsonar.jacoco.reportsPath=target/jacoco.exec \
        //            -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
        //       }
        //     }
        // }

        // stage("Quality Gate") {
        //     steps {
        //         timeout(time: 1, unit: 'HOURS') {
        //             // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
        //             // true = set pipeline to UNSTABLE, false = don't
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

        // stage("UploadArtifact"){
        //     steps{
        //         nexusArtifactUploader(
        //           nexusVersion: 'nexus3',
        //           protocol: 'http',
        //           nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
        //           groupId: 'QA',
        //           version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
        //           repository: "${RELEASE_REPO}",
        //           credentialsId: "${NEXUS_LOGIN}",
        //           artifacts: [
        //             [artifactId: 'vproapp',
        //              classifier: '',
        //              file: 'target/lnp-app-v1.war',
        //              type: 'war']
        //           ]
        //         )
        //     }
        // }





    }
}
  