# Jenkins-on-Mesos
Tested with [Jenkins v1.623](http://jenkins-ci.org/) + [Mesos-Plugin v.0.8.0](https://github.com/jenkinsci/mesos-plugin)

**Req.:**
- Mesos (tested with v0.23.0)
- Mesos-DNS (tested with v0.1.2)
- Marathon (tested with v0.9.1)

**Default Mesos-Plugin conf. (see [config.xml](config.xml)):**

- Mesos native library path: /usr/local/lib/libmesos.so
- Mesos Master: zk://leader.mesos:2181/mesos
- Slave username: root
- Framework Principal: no set!
- Jenkins URL: http://jenkins.marathon.mesos:31205
- Checkpointing: enabled
- On-demand framework registration: no
- Label String: mesos
- Remote FS Root: root

**Run:**
```sh
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" \
    leader.mesos:8080/v2/apps -d '{
  "id": "jenkins",
  "container": { 
    "type": "DOCKER",
    "docker": {
      "image": "jstabenow/jenkins-mesos:latest"
    },
    "volumes": []
  },
 "env": {
    "JENKINS_HOME": "/var/lib/jenkins"
  },
  "cpus": 2,
  "mem": 8192,
  "instances": 1,
  "ports": [31205],
  "healthChecks": [
        {
            "path": "/",
            "portIndex": 0,
            "protocol": "HTTP",
            "gracePeriodSeconds": 30,
            "intervalSeconds": 30,
            "timeoutSeconds": 30,
            "maxConsecutiveFailures": 3
        }
  ],
  "cmd": "java -jar /usr/share/jenkins/jenkins.war --webroot=war --httpPort=$PORT0 --ajp13Port=-1 --httpListenAddress=0.0.0.0 --ajp13ListenAddress=127.0.0.1 --preferredClassLoader=java.net.URLClassLoader --logfile=/mnt/mesos/sandbox/jenkins.log",
  "upgradeStrategy": {
    "minimumHealthCapacity": 0
  }
}'
```

**Add your first job:**
![TestJob](test-job.gif)
