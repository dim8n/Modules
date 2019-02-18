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
    
    stage('Results') {
        //echo verString
        def comString = "curl -XPUT -u admin:admin123 -T build/libs/app.war http://127.0.0.1:8081/repository/Task6/$verString/"
        echo comString        

        if (isUnix()) {
            sh comString
        } else {    
            bat comString
        }
    }
}
