# 使用statefulSet
- 创建pv
  - kubectl create -f persistent-volumes-hostpath.yaml (List 与 --- 类似，定义多个资源)
- 创建 headless svc
  - kubectl create -f kubia-service-headless.yaml 
- 创建 statefulset
  - kubectl create -f kubia-statefulset.yaml
    - statefulset pod 会顺序创建（等待上一个创建好） rs rc 会同步创建
    - statefulset pod 后标识为 0, 1 这样的顺序序号
    - storageClassName: "" 设置为空串， pvc绑定手动创建pv
    - 查看创建pod 详情
      - kubectl get po kubia-statefulset-0 -o yaml
      ```
      volumeMounts:
        - mountPath: /var/data
        name: data

       volumes:
        - name: data
        persistentVolumeClaim:
          claimName: data-kubia-statefulset-0

      ```
    - 查看pvc
      ```
      yuzhongyu@yuzhongyudeMacBook-Air zhyyu-workspace % kubectl get pvc
      NAME                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
      data-kubia-statefulset-0   Bound    pv-a                                       1Mi        RWO                           6m14s
      data-kubia-statefulset-1   Bound    pv-b                                       1Mi        RWO                           6m7s
      mongodb-pvc2               Bound    pvc-ac780058-2ec9-48f6-9f43-d8806bb84a06   100Mi      RWO            standard       2d20h

      ```
    - pvc 自动生成， 并被pod 绑定， pvc 绑定可用pv

# 通过API服务器与pod通信
- 借助另一个pod curl 访问， 或则使用api server
- <apiServerHost>:<port>/api/v1/namespaces/default/pods/kubia-statefulset-0/proxy/<path>
- kubectl proxy
- curl localhost:8001/api/v1/namespaces/default/pods/kubia-statefulset-0/proxy/
- curl -X POST -d "Hey there! This greeting was submitted to kubia-statefulset-0." localhost:8001/api/v1/namespaces/default/pods/kubia-statefulset-0/proxy/
  - 重新curl get 可获取post 值
- 删除一个pod 检查重新调度pod 是否使用相同存储
  - kubectl delete pod kubia-statefulset-0
  - kubectl get po 马上会重新创建一个同名pod， 并绑定相同pvc ， curl get 数据仍然存在
  - 重新创建的pod 和原ip 相同
- 扩缩容Statefulset
  - 首先删除最高索引的pod， 完成后再删除次最高索引pod
- 通过—个普通的非headless的Service暴露Statefulset的pod
  - kubectl create -f kubia-service-public.yaml
  - /api/v1/namespaces/<namespace>/services/<service name>/proxy/<path>
  - curl localhost:8001/api/v1/namespaces/default/services/kubia-public/proxy/

# 在 Statefulset 中发现伙伴节点
- dns SRV记录查找pod ip
  - kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia-svc-headless.default.svc.cluster.local
    ```
    yuzhongyu@yuzhongyudeMacBook-Air chapter10 % kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia-svc-headless.default.svc.cluster.local

    ; <<>> DiG 9.9.5-3ubuntu0.2-Ubuntu <<>> SRV kubia-svc-headless.default.svc.cluster.local
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 17684
    ;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 3
    ;; WARNING: recursion requested but not available
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;kubia-svc-headless.default.svc.cluster.local. IN SRV
    
    ;; ANSWER SECTION:
    kubia-svc-headless.default.svc.cluster.local. 30 IN SRV 0 50 80 172-17-0-15.kubia-svc-headless.default.svc.cluster.local.
    kubia-svc-headless.default.svc.cluster.local. 30 IN SRV 0 50 80 172-17-0-5.kubia-svc-headless.default.svc.cluster.local.
    
    ;; ADDITIONAL SECTION:
    172-17-0-15.kubia-svc-headless.default.svc.cluster.local. 30 IN A 172.17.0.15
    172-17-0-5.kubia-svc-headless.default.svc.cluster.local. 30 IN A 172.17.0.5
    
    ;; Query time: 7 msec
    ;; SERVER: 10.96.0.10#53(10.96.0.10)
    ;; WHEN: Mon Oct 18 08:51:50 UTC 2021
    ;; MSG SIZE  rcvd: 455
    
    pod "srvlookup" deleted

    ```
