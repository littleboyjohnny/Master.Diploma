pipeline {
    agent none

    stages {
        stage('SAST') {
            agent any
            steps {
                script {
                   sh './flawfinder/flawfinder seafile/.'
                }
            }
        }
        
        stage('Build') {
            agent any
            steps {
                sh 'docker container stop $(docker container ls -aq)'
                sh 'docker container prune -f'
                sh 'docker run -p 80:80 --name sf7 -d -t stegerpa/seafile7'
                sleep 600
            }
        }
        
        stage('DAST') {
            agent any
            steps {
                sh '/Applications/OWASP\\ ZAP.app/Contents/Java/zap.sh -cmd -quickurl http://127.0.0.1'
            }
        }
    }
}
