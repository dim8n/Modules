node {
    def verString
    
    stage('Preparation') {
        git branch: 'task6', url: 'https://github.com/dim8n/Modules'
    }
    
    stage('Build') {
        if (isUnix()) {
            sh './gradlew incTask'
            sh './gradlew clean build'
            sh 'git config --global user.name "dim8n"'
            sh 'git config --global user.email "d.elizarov@gmail.com"'
        } else {
            bat 'gradlew.bat incTask'
            bat 'gradlew.bat clean build'
        }
    }
    
    stage ('GetVersion') {
        def content = readFile 'gradle.properties'

        Properties properties = new Properties()
        InputStream is = new ByteArrayInputStream(content.getBytes());
        properties.load(is)

        def runtimeString = 'version'
        verString = properties."$runtimeString"
    }
    
    stage('Upload to Repo') {
        withCredentials([usernamePassword(credentialsId: 'Nexus', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            def comString = "curl --noproxy localhost,127.0.0.1 -XPUT -u $USERNAME:$PASSWORD -T build/libs/app.war http://127.0.0.1:8081/repository/snapshots/test/$verString/"
            echo comString
            if (isUnix()) {
                sh comString
            } else {    
                bat comString
            }
        }
    }
    
    stage('Deploy to tomcats'){
        //	http://localhost:8090/manager/deploy?path=/app&war=http://127.0.0.1:8081/repository/Task6/1.0.7/app.war
        if (isUnix()) {
            echo 'This is Linux'
            sh 'curl "http://127.0.0.1:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker1&vwa=1"'
            echo 'This will upload app.war to tomcat server1'
            sh 'curl "http://127.0.0.1:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker1&vwa=0"'
            sh 'curl "http://127.0.0.1:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker2&vwa=1"'
            echo 'This will upload app.war to tomcat server2'
            sh 'curl "http://127.0.0.1:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker2&vwa=0"'
        } else {
            withCredentials([usernamePassword(credentialsId: 'tomcatCreds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                bat "curl -o app.war http://127.0.0.1:8081/repository/snapshots/test/$verString/app.war"
                bat "curl -u $USERNAME:$PASSWORD http://localhost:8090/manager/text/undeploy?war=app.war"
                bat "curl -XPUT -u $USERNAME:$PASSWORD -T app.war http://localhost:8090/manager/text/deploy?path=/app"
            }
        }
    }
    
    stage('Verify deploy correct'){
        echo 'Thid verify a MANIFEST.MF file on tomcat server'
    }

    stage('Verify HTTP request correct'){
        echo 'Thid verify an HTTP request from tomcat server'
        def respString
        if (isUnix()) { 
            def response = httpRequest 'http://127.0.0.1:8400/app/'
            respString = response.content
        } else {
            def response = httpRequest 'http://127.0.0.1:8090/app/'
            respString = response.content
        }
        if(respString.contains(verString)) {
            println 'Version on the tomcat is correct'
            //currentBuild.result="SUCCES";
        } else {
            //currentBuild.result="FAILURE";
            println "Version on the tomcat is incorrect!!!"
        }
    }
    
    stage('Commit changes on git'){
        echo 'This will sync changes on git'
        if (isUnix()) {
            sh 'git add gradle.properties'
            sh 'git commit -m "Version changed to '+verString+'"'
            sh 'git config --global user.name "dim8n"'
            sh 'git config --global user.email "d.elizarov@gmail.com"'
            withCredentials([usernamePassword(credentialsId: 'gitCreds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'git push --set-upstream http://$USERNAME:$PASSWORD@github.com/dim8n/Modules.git task6'
            }
        } else {
            bat 'git add gradle.properties'
            bat 'git commit -m "Version changed to '+verString+'"'
            bat 'git config --global user.name "dim8n"'
            bat 'git config --global user.email "d.elizarov@gmail.com"'
            withCredentials([usernamePassword(credentialsId: 'gitCreds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                bat 'git push --set-upstream http://dim8n:469Wa880ca@github.com/dim8n/Modules.git task6'
                //bat 'git push --set-upstream http://USERNAME:PASSWORD@github.com/dim8n/Modules.git task6'
            }
        }
    }
}
