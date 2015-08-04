# Jenkins-on-Mesos
Tested with [Jenkins v1.623](http://jenkins-ci.org/) + [Mesos-Plugin v0.8.0](https://github.com/jenkinsci/mesos-plugin)

**Req.:**
- Mesos v0.23.0
- Mesos-DNS (tested with v0.1.2)
- Marathon (tested with v0.9.1)

**Default Mesos-Plugin [conf.](config.xml):**

- Mesos Master: zk://leader.mesos:2181/mesos
- Slave username: root
- Framework Principal: no set!
- Jenkins URL: http://jenkins.marathon.mesos:31205
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
  "cpus": 1,
  "mem": 2048,
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
  "cmd": "java -jar /usr/share/jenkins/jenkins.war --httpPort=$PORT0 --logfile=/mnt/mesos/sandbox/jenkins.log",
  "upgradeStrategy": {
    "minimumHealthCapacity": 0
  }
}'
```

**UI-Access:** 

"jenkins.marathon.mesos:31205" or "slaves-hostname:31205"

**Add your first job:**

![TestJob](test-job.gif)
