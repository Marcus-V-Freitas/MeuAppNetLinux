// Jenkinsfile (versão com deploy)

pipeline {
    agent any

    environment {
        // Nome da imagem Docker que será gerada
        DOCKER_IMAGE_NAME = "meu-app-net-linux"
        // Nome fixo para o nosso container de "produção"
        CONTAINER_NAME = "meu-app-net-production"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando o repositório...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Iniciando a construção da imagem Docker: ${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    // Constrói a imagem Docker usando o Dockerfile do projeto
                    def appImage = docker.build("${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}", ".")
                    echo "Imagem construída com sucesso!"
                }
            }
        }

        // Este estágio agora é responsável pelo deploy
        stage('Deploy to Docker') {
            steps {
                script {
                    echo "Iniciando deploy do container: ${env.CONTAINER_NAME}"

                    // 1. Tenta parar e remover o container antigo (se existir)
                    // O '|| true' previne que o pipeline falhe se o container não existir na primeira execução.
                    sh "docker stop ${env.CONTAINER_NAME} || true"
                    sh "docker rm ${env.CONTAINER_NAME} || true"

                    // 2. Roda o novo container com a imagem que acabamos de construir
                    // Usamos --name para dar um nome fixo e -d para rodar em background (detached)
                    echo "Subindo novo container..."
                    sh "docker run -d --name ${env.CONTAINER_NAME} -p 8081:8080 ${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"

                    echo "Deploy concluído! A aplicação está disponível em http://localhost:8081/weatherforecast"
                }
            }
        }
    }

    // O bloco 'post' foi removido para que o container não seja limpo após a execução!
}