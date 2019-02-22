node {
    def verString
    
    stage('Preparation') {
        git branch: 'task6', url: 'https://github.com/dim8n/Modules'
    }
    
    stage('Build') {
        sh './gradlew incTask'
        sh './gradlew clean build'
    }
    
    stage ('GetVersion') {
        def content = readFile 'gradle.properties'
        Properties properties = new Properties()
        InputStream is = new ByteArrayInputStream(content.getBytes());
        properties.load(is)
        verString = properties."version"
    }
    
    stage('Upload to Repo') {
        withCredentials([usernamePassword(credentialsId: 'Nexus', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "curl -XPUT -u $USERNAME:$PASSWORD -T build/libs/app.war http://localhost:8081/repository/snapshots/test/$verString/"
        }
    }
    
    stage('Deploy to tomcats'){
        def respString

        sh "curl -o /vagrant_m6/app.war http://localhost:8081/repository/snapshots/test/$verString/app.war" //Put the app.war to shared folder

        sh 'curl "http://localhost:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker1&vwa=1"' //Stop LB tomcat1
        sh 'curl "http://admin:adminadmin@localhost:8481/manager/text/undeploy?path=/app"'
        sh 'curl "http://admin:adminadmin@localhost:8481/manager/text/deploy?path=/app&war=file:/vagrant/app.war"'
        def response = httpRequest 'http://localhost:8481/app/'
        respString = response.content
        if(respString.contains(verString)) {
            println 'Version on the tomcat1 is correct'
            currentBuild.result="SUCCESS"
        } else {
            println "Version on the tomcat1 is incorrect!!!"
            currentBuild.result="FAILURE"
        }
        sh 'curl "http://localhost:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker1&vwa=0"' //Start LB tomcat1
    
        sh 'curl "http://localhost:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker2&vwa=1"' //Stop LB tomcat2
        sh 'curl "http://admin:adminadmin@localhost:8482/manager/text/undeploy?path=/app"'
        sh 'curl "http://admin:adminadmin@localhost:8482/manager/text/deploy?path=/app&war=file:/vagrant/app.war"'
        response = httpRequest 'http://localhost:8482/app/'
        respString = response.content
        if(respString.contains(verString)) {
            println 'Version on the tomcat2 is correct'
            currentBuild.result="SUCCESS"
        } else {
            println "Version on the tomcat2 is incorrect!!!"
            currentBuild.result="FAILURE"
        }
        sh 'curl "http://localhost:8400/jkmanager?cmd=update&from=list&w=myworker&sw=myworker2&vwa=0"' //Start LB tomcat2
    }
    
    stage('Verify HTTP request correct'){
        def respString
        def response = httpRequest 'http://localhost:8400/app/'
        respString = response.content
        if(respString.contains(verString)) {
            println 'Version on the apache is correct'
            currentBuild.result="SUCCESS"
        } else {
            println "Version on the apache is incorrect!!!"
            currentBuild.result="FAILURE"
        }
    }
    
    stage('Commit changes on git'){
        sh 'git add gradle.properties'
        sh 'git commit -m "Version changed to '+verString+'"'
        sh 'git config --global user.name "dim8n"'
        sh 'git config --global user.email "d.elizarov@gmail.com"'
        withCredentials([usernamePassword(credentialsId: 'gitCreds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh 'git push --set-upstream http://$USERNAME:$PASSWORD@github.com/dim8n/Modules.git task6'
            sh 'git checkout master'
            sh 'git merge task6'
            sh 'git tag v'+verString
            sh 'git push --set-upstream http://$USERNAME:$PASSWORD@github.com/dim8n/Modules.git origin v'+verString
        }
    }
}
