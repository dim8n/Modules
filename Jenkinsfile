node {
    def verString
    
    stage('Preparation') {
        git branch: 'task6', url: 'https://github.com/dim8n/Modules'
    }
    
    stage('Build') {
        if (isUnix()) {
            sh './gradlew incTask'
            sh './gradlew clean build'
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
        //echo verString
        def comString = "curl --noproxy localhost,127.0.0.1 -XPUT -u admin:admin123 -T build/libs/app.war http://127.0.0.1:8081/repository/Task6/$verString/"
        echo comString        

        if (isUnix()) {
            sh comString
        } else {    
            bat comString
        }
    }
    
    stage('Deploy to tomcats'){
        echo 'This will upload app.war to tomcat servers'
        //	http://localhost:8090/manager/deploy?path=/app&war=http://127.0.0.1:8081/repository/Task6/1.0.7/app.war
        if (isUnix()) {
            echo 'This is Linux'
            //sh 'scp -P 2200 build/libs/app.war root@127.0.0.1:/usr/share/tomcat/webapps/'
            //sh 'scp -P 2201 build/libs/app.war root@127.0.0.1:/usr/share/tomcat/webapps/'
            
        } else {
            bat 'copy /Y build\\libs\\app.war "c:/Program Files (x86)/Apache Software Foundation/Tomcat 9.0/webapps/"'
        }
    }
    
    stage('Verify deploy correct'){
        echo 'Thid verify a MANIFEST.MF file on tomcat server'
    }

    stage('Verify HTTP request correct'){
        echo 'Thid verify an HTTP request from tomcat server'
        def response = httpRequest 'http://127.0.0.1:8400/app/'
        if(response.content.contains(verString)) {
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
            sh 'git add .'
            sh 'git commit -m "Version changed"'
            sh 'git push origin task6'
        } else {
            bat 'git add .'
            bat 'git commit -m "Version changed"'
            bat 'git push origin task6'
        }
    }
}
