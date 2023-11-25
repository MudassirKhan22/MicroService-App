pipeline{
    agent none

    environment{
        BUILD_SERVER_IP= "ec2-user@65.2.71.176"
        DEPLOY_SERVER_IP= "ec2-user@3.110.167.40"
        PHP_IMAGE_NAME= "mudassir12/php:${BUILD_NUMBER}"
        DB_IMAGE_NAME= "mudassir12/mysql:${BUILD_NUMBER}"

    }

    stages{
        stage("BUILDING THE DOCKER-FILE and PUSH TO THE DOCKER-HUB"){
            agent any

            steps{
                script{
                    sshagent(['my-slave-private-key']){
                        withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentilas', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
                           
                            sh "scp -o strictHostKeyChecking=no -r docker-files/PHP ${BUILD_SERVER_IP}:/home/ec2-user"
                            sh "ssh ${BUILD_SERVER_IP} sudo bash PHP/docker-script.sh"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${PHP_IMAGE_NAME} PHP"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker push ${PHP_IMAGE_NAME}"

                            sh "scp -o strictHostKeyChecking=no -r docker-files/DB ${BUILD_SERVER_IP}:/home/ec2-user"
                            sh "ssh ${BUILD_SERVER_IP} sudo bash DB/docker-script.sh"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${DB_IMAGE_NAME} DB"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker push ${DB_IMAGE_NAME}"
                        }

                    }
                }
            }

        }

        stage('DEPLOY DOCKER CONTAINER USING DOCKER-COMPOSE'){
            agent any
            steps{
                script{
                    sshagent(['my-slave-private-key']){
                        withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentilas', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){

                            sh "ssh -o strictHostKeyChecking=no -r docker-files/Docker-Compose ${DEPLOY_SERVER_IP}:/home/ec2-user"
                            sh "ssh ${DEPLOY_SERVER_IP} sudo bash Docker-Compose/docker-script.sh"
                            sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh ${DEPLOY_SERVER_IP} sudo bash Docker-Compose/docker-compose-script.sh"
                        }

                    }

                }
            }
        }
    }
}