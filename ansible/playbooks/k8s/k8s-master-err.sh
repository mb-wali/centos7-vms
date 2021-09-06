[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[kubelet-check] Initial timeout of 40s passed.
    
    Unfortunately, an error has occurred:
        timed out waiting for the condition
    
    This error is likely caused by:
        - The kubelet is not running
        - The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)
    
    If you are on a systemd-powered system, you can try to troubleshoot the error with the following commands:
        - 'systemctl status kubelet'
        - 'journalctl -xeu kubelet'
    
    Additionally, a control plane component may have crashed or exited when started by the container runtime.
    To troubleshoot, list all containers using your preferred container runtimes CLI, e.g. docker.
    Here is one example how you may list all Kubernetes containers running in docker:
        - 'docker ps -a | grep kube | grep -v pause'
        Once you have found the failing container, you can inspect its logs with:
        - 'docker logs CONTAINERID'
    error execution phase wait-control-plane: couldn't initialize a Kubernetes cluster