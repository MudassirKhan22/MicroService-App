pipeline{
    agent none

    environment{
        BUILD_SERVER_IP= "ec2-user@65.2.71.176"
        DEPLOY_SERVER_IP= "ec2-user@3.110.167.40"
        PHP_IMAGE_NAME= "mudassir12/php:${BUILD_NUMBER}"
    }

    stages{
        stage("BUILDING THE DOCKER-FILE and PUSH TO THE DOCKER-HUB"){
            agent any

            steps{
                script{
                    sshagent(['my-slave-private-key']){
                        withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentilas', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
                           
                            sh "scp -o strictHostKeyChecking=no -r docker-files/PHP ${BUILD_SERVER_IP}:/home/ec2-user"
                            sh "ssh -o strictHostKeyChecking=no  ${BUILD_SERVER_IP} sudo bash PHP/docker-script.sh"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${PHP_IMAGE_NAME} PHP"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                            sh "ssh ${BUILD_SERVER_IP} sudo docker push ${PHP_IMAGE_NAME}"
                        }

                    }
                }
            }

        }
    }
}