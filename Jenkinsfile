pipeline {
  agent any

  environment {
    GIT_CREDENTIALS_ID = 'jenkins'         // Jenkins에 등록한 GitHub 자격증명 ID
    VALUES_FILE = 'mychart/values.yaml'    // Helm 차트 경로
  }

  triggers {
    GenericTrigger(
      genericVariables: [
        [key: 'REPO', value: '$.repository.name'],       // 예: multi-frontend
        [key: 'NEW_TAG', value: '$.head_commit.id']      // 예: 커밋 SHA
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

    stage('Determine yq path') {
      steps {
        script {
          def repo = env.REPO  // ✅ 환경 변수로부터 안전하게 가져옴

          if (repo == 'multi-frontend') {
            env.YQ_PATH = '.frontend.tag'
          } else if (repo == 'multi-backend-boards') {
            env.YQ_PATH = '.backend.boards.tag'
          } else if (repo == 'multi-backend-users') {
            env.YQ_PATH = '.backend.users.tag'
          } else {
            error "❌ 알 수 없는 REPO 이름: ${repo}"
          }
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
          git commit -m "chore: update ${REPO} tag to ${NEW_TAG}" || echo 'No changes to commit'
          git push origin main
        """
      }
    }
  }
}
