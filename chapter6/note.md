# emptyDir volume
- kubectl create -f fortune-pod.yaml 
- kubectl get po
  ```
  NAME                  READY   STATUS    RESTARTS   AGE
  fortune               2/2     Running   0          14m
  ```
  - 一个pod 运行两个容器， 使用-c 进入指定容器
    - kubectl exec -it fortune -c web-server /bin/sh 

- emptyDir 在pod 删除后消失

# hostPath volume
- kubectl create -f fortune-pod-hostpath.yaml 
- minikube ssh 进入node 后 /jurorhostpath 下会有pod html 产生的文件
- 删除pod 后node 上文件不会删除
- 注意pod 迁移至其他node， 新node 没有原node 文件

- gce minikube 替代为hostpath
  - kubectl create -f mongodb-pod-hostpath.yaml

# 持久卷 pv
- pod(user create) -> pvc(user create) ->(k8s find) pv (adm create)
- 创建pv
  - kubectl create -f mongodb-pv-hostpath.yaml
- 查看pv
  - kubectl get pv
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pv
  NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
  mongodb-pv   1Gi        RWO,ROX        Retain           Available
  ```
  - 持久卷不属于任何命名空间(见图6.7), 它跟节点一样是集群层面的资源; pvc 属于命名空间

# 持久卷声明 pvc
- 创建pvc
  - kubectl create -f mongodb-pvc.yaml
- 查看pvc, 对应pv 变化
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pvc
  NAME          STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  mongodb-pvc   Bound    mongodb-pv   1Gi        RWO,ROX                       9s
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pv
  NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS   REASON   AGE
  mongodb-pv   1Gi        RWO,ROX        Retain           Bound    default/mongodb-pvc                           21m
  ```
  - pvc volume 列显示绑定pv
  - RWO、ROX、RWX 涉及可以同时使用卷的工作节点的数量而并非 pod 的数量
  - pv 被绑定后 status 变更为bound claim 显示 命名空间/pvc 下的绑定
  - pv pvc 自动绑定

# 在 pod 中使用持久卷声明
- 创建pod-pvc
  - kubectl create -f mongodb-pod-pvc.yaml
- 启动失败
  - kubectl logs mongodb-pod-pvc 发现已有其他mongo 进程使用  /data/db
  - kubectl delete pod mongodb // 删除其他占用/data/db 进程
  - kubectl delete pod mongodb-pod-pvc // 删除后重新创建
  - kubectl create -f mongodb-pod-pvc.yaml

# 回收持久卷
- kubectl delete pod mongodb-pod-pvc
- kubectl delete pvc mongodb-pvc
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pv
  NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                 STORAGECLASS   REASON   AGE
  mongodb-pv   1Gi        RWO,ROX        Retain           Released   default/mongodb-pvc                           4h47m
  ```
- 删除pod pvc 后， 对应pv status 为released
- kubectl create -f mongodb-pvc.yaml
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pvc
  NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  mongodb-pvc   Pending                                                     4s
  ```
  - 重新创建pvc 无法绑定 Released pv， 故status pending
- retain pv 回收方法： 删除pv， 清理底层存储文件，创新创建pv 

# 持久卷的动态卷配置 StorageClass
- 创建 StorageClass (sc 不属于namespace)
  - kubectl create -f storageclass-fast-hostpath.yaml
- 查看 StorageClass
  - kubectl get sc
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get sc
  NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
  fast                 k8s.io/minikube-hostpath   Delete          Immediate           false                  59s
  standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  30d

  ```
- 创建pvc 引用 sc
  - kubectl create -f mongodb-pvc-dp.yaml
  - 查看pvc
    ```
    yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pvc
    NAME          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    mongodb-pvc   Bound    pvc-657a8758-48d5-4ce7-bab2-8072aae0d838   100Mi      RWO            fast           3s
    ```
    - 发现绑定自动生成pv， STORAGECLASS 为对应sc
  - 查看pv
    ```
    yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pv
    NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                 STORAGECLASS   REASON   AGE
    mongodb-pv                                 1Gi        RWO,ROX        Retain           Released   default/mongodb-pvc                           6h15m
    pvc-657a8758-48d5-4ce7-bab2-8072aae0d838   100Mi      RWO            Delete           Bound      default/mongodb-pvc   fast                    103s
    ```
    - 发现自动生成pv， STORAGECLASS 为对应sc
  
# 默认 storageClass
- 查看默认 standard
  ```
  yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get sc
  NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
  fast                 k8s.io/minikube-hostpath   Delete          Immediate           false                  103m
  standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  30d
  ```
  - standard (default)  为默认存储类
- 创建pvc 未指定 storageClassName
  - kubectl create -f mongodb-pvc-dp-nostorageclass.yaml
  - 自动生成pv 并与之绑定， sc 为 standard
    ```
    yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pvc
    NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    mongodb-pvc2   Bound    pvc-ac780058-2ec9-48f6-9f43-d8806bb84a06   100Mi      RWO            standard       4s

    yuzhongyu@yuzhongyudeMacBook-Air chapter6 % kubectl get pv
    NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                  STORAGECLASS   REASON   AGE
    mongodb-pv                                 1Gi        RWO,ROX        Retain           Released   default/mongodb-pvc                            7h55m
    pvc-ac780058-2ec9-48f6-9f43-d8806bb84a06   100Mi      RWO            Delete           Bound      default/mongodb-pvc2   standard                54s
    ```
- 强制将持久卷声明绑定到预配置的其中一个持久卷
  - 不想让 standard sc 生效， 可把 storageClassName 设置为"" 空串， 如mongodb-pvc.yaml 配置（绑定自定义pv）
