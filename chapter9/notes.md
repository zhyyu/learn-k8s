### 使用同样的Tag推送更新过后的镜像
- 注意容器 imagePullPolicy 设置为always，（node 会缓存镜像）

### 创建svc rc； 可使用--- 分割在同一yaml 创建多个资源
- kubectl create -f kubia-rc-and-service-v1.yaml

### rolling-update (deprecated)

---
#  Deployment
### 创建—个 Deployment
- kubectl create -f kubia-deployment-v1.yaml --record
  - 会创建对应rs， 管理pod
  - record 参数, kubectl rollout history deployment kubia-deployment 会展示change-cause
### 升级Deployment
- 持续访问svc， 观察升级
  - while true; do curl localhost:30124; sleep 1; done
- Deployment 默认升级策略为 RollingUpdate
- 降低rolling update 升级速度
  - kubectl patch deployments.apps kubia-deployment -p '{"spec": {"minReadySeconds": 10}}'
- 升级至v2
  - kubectl create -f kubia-deployment-v2.yaml
    - tips： 修改k8s 资源几种方式
      - kubectl edit // 使用默认编辑器打开资源配置
      - kubectl patch // 修改单个资源屈性
      - kubectl apply // 通过一 个完整的YAML或JSON文件，应用其中新的值来修改对象. 如果 YAML/JSON中指定的对象不存在，则会被创建。该文件需要包含资源的完整定义(不能像kubectl patch那样只包含想要更新的字段)
      - kubectl replace // 将原有对象替换为YAML/JSON文件中定义的新对象。与apply命令相反， 运行这个命令前要求对象必须存在，否则会打印错误
      - kubectl setimage // 修改Pod、ReplicationController、Deployment、DernonSet、Job或 ReplicaSet内的镜像

### 回滚Deployment
- 升级至v3 （访问达到5 次会报错）
  - kubectl apply -f kubia-deployment-v3.yaml
- 回滚升级
  - kubectl rollout undo deployment kubia-deployment
- 升级历史
  - kubectl rollout history deployment kubia-deployment
- 回滚到一个特定的 Deployment 版本
  - kubectl rollout undo deployment kubia-deployment --to-revision 1

### 观察升级过程
- kubectl rollout status deployment kubia-deployment

### 暂停滚动升级
- 升级至v4
  - kubectl apply -f kubia-deployment-v4.yaml
- 暂停升级
  - kubectl rollout pause deployment kubia-deployment
- 恢复滚动升级
  - kubectl rollout resume deployment kubia-deployment

### 阻止出错版本的滚动升级
- minReadySeconds: 10
  - pod 最小ready 时间， 未ready 不会继续升级
- 就绪探针 readinessProbe, 注意periodSeconds， 保持minReadySeconds 就绪才ready
- 滚动升级超时时间, 亦会自动取消
  - deployment spec progressDeadlineSeconds， 默认10mins
- 滚动升级出错， 通过rollout undo 取消
  - kubectl rollout undo deployment kubia-deployment
