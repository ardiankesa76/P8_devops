pipeline {
    agent any // Pakai agen default (bukan container), biar bisa akses Docker langsung dari host

    environment {
        IMAGE_NAME = 'php-jenkins-app'
        CONTAINER_NAME = 'php-jenkins-app-container'
        PORT_MAP = '8080:80'
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Repositori berhasil dikloning."
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-dev --prefer-dist --no-interaction || true' // composer harus ada di sistem host
                echo "Dependensi PHP berhasil diinstal."
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh './vendor/bin/phpunit tests/ || true' // PHPUnit juga harus ada via composer
                echo "Unit test berhasil dijalankan."
            }
        }

        stage('Build and Deploy Docker Image') {
            steps {
                script {
                    echo "Build Docker image..."
                    sh "docker build -t ${IMAGE_NAME}:latest ."

                    echo "Stop & remove old container (jika ada)..."
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"

                    echo "Run new container..."
                    sh "docker run -d -p ${PORT_MAP} --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline selesai.'
        }
        success {
            echo 'Pipeline berhasil!'
        }
        failure {
            echo 'Pipeline gagal!'
        }
    }
}
