pipeline {
    // Jalankan seluruh pipeline di dalam container Docker.
    // Menggunakan image PHP CLI untuk memastikan lingkungan yang konsisten untuk build dan test.
    agent {
        docker {
            image 'php:8.1-cli' // Image untuk Composer dan PHPUnit
            // Menambahkan argumen untuk memungkinkan akses ke Docker daemon dan binary Docker dari host
            args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker'
        }
    }

    stages {
        // Tahap 1: Mengkloning Repositori
        stage('Clone Repository') {
            steps {
                script {
                    echo "Repositori berhasil dikloning."
                }
            }
        }

        // Tahap 2: Menginstal Dependensi PHP (dengan Composer)
        stage('Install Dependencies') {
            steps {
                script {
                    // Pastikan composer terinstal di dalam container agen
                    sh 'composer install --no-dev --prefer-dist --no-interaction'
                    echo "Dependensi PHP berhasil diinstal."
                }
            }
        }

        // Tahap 3: Menjalankan Unit Test
        stage('Run Unit Tests') {
            steps {
                script {
                    // Jalankan PHPUnit. Pastikan PHPUnit terinstal melalui composer.json (dev dependency)
                    sh './vendor/bin/phpunit tests/'
                    echo "Unit test berhasil dijalankan."
                }
            }
        }

        // Tahap 4: Membangun dan Menerapkan Aplikasi Menggunakan Docker Image Lokal
        stage('Build and Deploy Docker Image') {
            steps {
                script {
                    // Membangun Docker image dari Dockerfile yang ada di root repo
                    // Tag image dengan nama 'php-jenkins-app' dan tag 'latest'
                    sh 'docker build -t php-jenkins-app:latest .'
                    echo "Docker image 'php-jenkins-app:latest' berhasil dibangun."

                    // Hentikan dan hapus container lama jika ada (agar deployment bersih)
                    sh 'docker stop php-jenkins-app-container || true' // '|| true' agar tidak error jika container tidak ada
                    sh 'docker rm php-jenkins-app-container || true'

                    // Jalankan container baru dari image yang baru dibangun
                    // Map port 8080 di host ke port 80 di container (tempat Apache berjalan)
                    sh 'docker run -d -p 8080:80 --name php-jenkins-app-container php-jenkins-app:latest'
                    echo "Aplikasi berhasil di-deploy di Docker container 'php-jenkins-app-container' pada port 8080."
                }
            }
        }
    }

    // Bagian post-build untuk notifikasi atau cleanup
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