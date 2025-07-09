pipeline {
  agent any

  environment {
    GIT_CREDENTIALS_ID = 'jenkins' // Jenkins Credentials ID
    VALUES_FILE = 'myChart/values.yaml'
  }

  triggers {
    GenericTrigger(
      genericVariables: [
        [key: 'REPO', value: '$.repository.name'],
        [key: 'NEW_TAG', value: '$.head_commit.id']
      ],
      token: 'msa-token'
    )
  }

  stages {
    stage('Checkout devops repo') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[
            url: 'https://github.com/onetouch-ke/multi_Devops.git',
            credentialsId: "${env.GIT_CREDENTIALS_ID}"
          ]]
        ])
      }
    }

    stage('Determine service path') {
      steps {
        script {
          env.SERVICE_KEY = REPO.replace('multi_', '') // 예: multi-frontend → frontend
          env.YQ_PATH = ".services.${SERVICE_KEY}.image.tag"
        }
      }
    }

    stage('Update values.yaml') {
      steps {
        sh """
          echo "▶ Before update:"
          cat ${VALUES_FILE}

          yq eval --inplace '${YQ_PATH} = "${NEW_TAG}"' ${VALUES_FILE}

          echo "✅ After update:"
          cat ${VALUES_FILE}
        """
      }
    }

    stage('Commit & Push changes') {
      steps {
        sh """
          git config user.name "jenkins-bot"
          git config user.email "jenkins@local"
          git add ${VALUES_FILE}
          git commit -m "chore: update \${SERVICE_KEY} tag to ${NEW_TAG}" || echo "No changes to commit"
          git push origin main
        """
      }
    }
  }
}
