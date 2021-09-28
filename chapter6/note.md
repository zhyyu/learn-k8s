# emptyDir volume
- kubectl create -f fortune-pod.yaml 
- kubectl get po
  ```
  NAME                  READY   STATUS    RESTARTS   AGE
  fortune               2/2     Running   0          14m
  ```
  - 一个pod 运行两个容器， 使用-c 进入指定容器
    - kubectl exec -it fortune -c web-server /bin/sh 

