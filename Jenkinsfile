pipeline {
    agent any
    stages {
        stage('Checkout external proj 🙈🙈🙈') {
            steps {
                git url: 'https://github.com/MakariosNassef/Automated-WebApp-on-Amazon-EKS.git', branch: 'main' , credentialsId: 'git-credential'
            }
        }
        stage('Build Docker image Python app and push to ecr 🚚📌') {
            steps{
                script {
                    sh '''
                    pwd
                    cd $PWD/flask_app/FlaskApp/
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 993269114119.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t python_app:app_"$BUILD_NUMBER" .
                    docker tag python_app:app_"$BUILD_NUMBER" 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_app:app_"$BUILD_NUMBER"
                    docker push 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_app:app_"$BUILD_NUMBER"
                    echo "Docker Cleaning up 🗑️"
                    docker rmi 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_app:app_"$BUILD_NUMBER"
                    '''
                }
            }
        }
        stage('Build Docker image mysql and push to ecr 🚚📌') {
            steps{
                script {
                    sh '''
                    pwd
                    cd $PWD/flask_app/db/
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 993269114119.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t python_db:db_"$BUILD_NUMBER" .
                    docker tag python_db:db_"$BUILD_NUMBER" 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_db:db_"$BUILD_NUMBER"
                    docker push 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_db:db_"$BUILD_NUMBER"
                    echo "Docker Cleaning up 🗑️"
                    docker rmi 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_db:db_"$BUILD_NUMBER"
                    '''
                }
            }
        }

        stage('Apply Kubernetes files 🚀 🎉 ') {
            steps{
                script {
                    sh '''
                    sed -i \"s|image:.*|image: 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_app:app_"$BUILD_NUMBER"|g\" `pwd`/kubernetes_manifest_file/deployment_flaskapp.yml
                    sed -i \"s|image:.*|image: 993269114119.dkr.ecr.us-east-1.amazonaws.com/python_db:db_"$BUILD_NUMBER"|g\" `pwd`/kubernetes_manifest_file/statefulSet_flaskdb.yml
                    aws eks update-kubeconfig --region us-east-1 --name eks
                    kubectl apply -f $PWD/kubernetes_manifest_file
                    '''
                }
            }
        }
        stage('INGRESS and LB URL 🚀 🎉 ') {
            steps{       
                script { 
                    sh '''
                    echo "LB SVC URL 🎉 🎉 🎉"
                    echo $(kubectl get svc flask-service-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):5002
                    echo "INGRESS URL 🎉 🎉 🎉"
                    echo $(kubectl get ingress ingress-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    '''
                }
            }
        }
    }
}

