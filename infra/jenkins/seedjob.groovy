// seedjob.groovy

// Create CI - multibranch pipeline
pipelineJob("CI - multibranch pipeline") {
    definition {
        cps {
            sandbox(true)
            script("""
pipeline {
    agent any
    stages {
        stage("CIStage1") {
            steps {
                // Steps specific to Stage1 of CI - multibranch pipeline
                echo "CI Шаг 1"
            }
        }
        stage("CIStage2") {
            steps {
                // Steps specific to Stage2 of CI - multibranch pipeline
                echo "CI Шаг 2"
            }
        }
        stage("CIStage3") {
            steps {
                // Steps specific to Stage3 of CI - multibranch pipeline
                echo "CI Шаг 3"
            }
        }
    }
    post {
        success {
            // запуск CD - когда успешно выполнится CI - multibranch pipeline
            build job: "CD - pipeline"
        }
    }
}
""")
        }
    }
}

// Create CD - pipeline
pipelineJob("CD - pipeline") {
    definition {
        cps {
            sandbox(true)
            script("""
pipeline {
    agent any
    stages {
        stage("CDStage1") {
            steps {
                // Steps specific to Stage4 of CD - pipeline
                echo "CD Шаг 1"
            }
        }
        stage("CDStage2") {
            steps {
                // Steps specific to Stage5 of CD - pipeline
                echo "CD Шаг 2"
            }
        }
    }
}
""")
        }
    }
}
