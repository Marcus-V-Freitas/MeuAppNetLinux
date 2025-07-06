// Jenkinsfile

pipeline {
    agent any

    environment {
        // Define o nome da imagem Docker que será gerada
        DOCKER_IMAGE_NAME = "meu-app-net-linux"
    }

    stages {
        stage('Checkout') {
            steps {
                // Clona o código do repositório Git
                echo 'Clonando o repositório...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Iniciando a construção da imagem Docker: ${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"

                    // Constrói a imagem Docker usando o Dockerfile do projeto
                    // O BUILD_NUMBER é uma variável de ambiente do Jenkins que gera um número único para cada build
                    def appImage = docker.build("${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}", ".")

                    echo "Imagem construída com sucesso!"
                }
            }
        }

        stage('Run Test Container') {
            steps {
                script {
                    echo "Rodando o container para verificação..."
                    // Roda o container em modo 'detached' (-d) e mapeia a porta 8081 do host para a 8080 do container
                    // para não conflitar com a porta do Jenkins
                    sh "docker run -d --name meu-app-teste-${env.BUILD_NUMBER} -p 8081:8080 ${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    
                    // Espera um pouco para a aplicação iniciar
                    sleep 5
                    
                    echo "Acesse a aplicação em http://localhost:8081/weatherforecast"
                }
            }
        }
    }

    post {
        always {
            // Bloco de limpeza: será executado sempre, independentemente do resultado do build
            echo "Limpando o container de teste..."
            // Para e remove o container de teste para não deixar lixo no ambiente
            sh "docker stop meu-app-teste-${env.BUILD_NUMBER} || true"
            sh "docker rm meu-app-teste-${env.BUILD_NUMBER} || true"
        }
    }
}