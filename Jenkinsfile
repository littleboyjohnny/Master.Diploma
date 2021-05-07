node {
    stage("Build") {
        sh 'if [[ -n $(docker network ls | grep \"app-zap-network\") ]]; then docker network rm app-zap-network; fi'
        sh 'docker network create app-zap-network'
        docker.image('stegerpa/seafile7').withRun('-p 80:80 --net app-zap-network -t') { c ->
            stage("SAST") {
                cleanWs()
                sh 'git clone https://github.com/haiwen/seafile.git'
                sh 'git clone https://github.com/david-a-wheeler/flawfinder.git'
                sh 'cd flawfinder && make install && cd ..'
                sh 'flawfinder seafile/.'
            }
            stage("Waiting for service starts up...") {
                sleep 10
                sh "docker exec -i ${c.id} sh -c 'while [ -z \$(curl -v --silent localhost:80 2>&1 | grep -o \"< HTTP/.* [^5][0-9][0-9]\") ]; do sleep 10; done'"
            }
            stage("DAST") {
                docker.image('owasp/zap2docker-stable').withRun('--net app-zap-network -t') { c1 ->
                    sh "docker exec -i ${c1.id} zap-baseline.py -t http://\$(docker inspect ${c.id} | egrep \"\\\"IPAddress\\\": \\\"[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\\\"\" -o | egrep -o \"[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}\"):80"
                }
            }
        }
        sh 'docker network rm app-zap-network'
    }
}
