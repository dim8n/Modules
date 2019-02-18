node {
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
    
    stage('Results') {
        def content = readFile 'gradle.properties'

        Properties properties = new Properties()
        InputStream is = new ByteArrayInputStream(content.getBytes());
        properties.load(is)

        def verString = properties."version"
        
        echo verString
        
        bat 'curl -x "" -XPUT -u admin:admin123 -T build/libs/app.war http://127.0.0.1:8081/repository/Task6/'+verString+'/'
    }
}