

node {
    stage("Prepare") {
        checkout scm
    }

    stage("Build") {
        echo "..."
    }

    stage("Comment") {
        if (env.CHANGE_ID) {
            for (comment in pullRequest.comments) {
                if (comment.user == "automation-user") {
                    pullRequest.deleteComment(comment.id)
                }
            }
            def date = sh 'python3 main.py'
            // pullRequest.comment("Build ${env.BUILD_ID} ran at ${date}")
        }
    }
}