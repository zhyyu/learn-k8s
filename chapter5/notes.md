# 创建服务
- expose
  - see chapter2
- yaml
  - kubectl create -f my-first-svc.yaml
- pod 访问内网集群ip
  - kubectl exec my-first-rc01-mjjh8 -- curl -s 10.101.231.141:8090
    - 类似ssh 登陆到pod 上curl
- 可设置 spec.sessionAffinity: ClientIP
  - 一个clientIP 访问只会命中一个pod
- 服务可映射多个端口
- svc ip port 会在pod 生成后的env 中
- 在 pod 容器中运行 shell
  - kubectl exec -it my-first-rc01-nqxkr /bin/bash

# service 对内域名
- curl my-first-svc.default.svc.cluster.local:8090
- curl my-first-svc.default:8090
- curl my-first-svc:8090
- 格式为: 服务名.命名空间.svc.cluster.local , 若命名空间相同， 可省略 namespace.svc.cluster.local
```
root@my-first-rc01-5jjt4:/# cat /etc/resolv.conf 
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
```
  - 注意search 参数
    - 如给出 my-svc.default, 则会根据search 参数自动拼接为 my-svc.default.svc.cluster.local
  - 域名可以 telnet curl 通， 但是不能ping 通

---
# 连接集群外部服务 5.2
- 获取服务下端点
  - kubectl get endpoints my-first-svc
- 手动创建服务与对应外部端点
  - kubectl create my-first-endpoint.yaml
  - kubectl create -f my-first-svc-external.yaml
  - 可不设置端点， service spec.type ExternalName 绑定外部域名
    - kubectl create -f my-first-svc-external-domain.yaml

---
# 5.3 将服务暴露给外部客户端
- nodeport
  - kubectl create -f my-first-svc-nodeport.yaml
  - 通过 nodeip:nodeport 集群外可以访问； minikue 需要（minikube service my-first-svc-nodeport )
    - curl 每次都随机node， 浏览器固定node（浏览器 keep alive， 固定了一个连接， curl 每次新的连接）
    - minikube 可执行 minikube ssh， 进入node, 再使用 nodeip:nodeport 访问
- ingress
  - kubectl create -f my-first-ingress.yaml
  - 创建域名与ingress ip /etc/hosts 绑定 (kubectl get ingress 获取对外ip)
  - curl my-first-svc-test.com （minikube ssh 进入node 中绑定hots）

---
# 5.5 就绪探针
- exp： rc.yaml
  - spec.container.readinessProbe 配置

---
# 其他
- kubectl apply 可以修改k8s 资源（kubectl create 必须先删除再创建）

# headless
- 创建headless svc
  - kubectl create -f my-first-svc-headless.yaml （clusterIP: None）
- 创建dns 查询pod
  - kubectl run dnstuils --image tutum/dnsutils --command -- sleep infinity
- 和普通svc 区别
  ```
  root@dnstuils:/# nslookup my-first-svc
  Server:         10.96.0.10
  Address:        10.96.0.10#53
  
  Name:   my-first-svc.default.svc.cluster.local
  Address: 10.101.231.141

  root@dnstuils:/# nslookup my-first-svc-headless
  Server:         10.96.0.10
  Address:        10.96.0.10#53
  
  Name:   my-first-svc-headless.default.svc.cluster.local
  Address: 172.17.0.4
  Name:   my-first-svc-headless.default.svc.cluster.local
  Address: 172.17.0.8
  Name:   my-first-svc-headless.default.svc.cluster.local
  Address: 172.17.0.18
  
  yuzhongyu@yuzhongyudeMacBook-Air chapter5 % kubectl get svc
  NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
  my-first-svc            ClusterIP      10.101.231.141   <none>        8090/TCP         22d
  my-first-svc-headless   ClusterIP      None             <none>        80/TCP           4s

  ```
  - headless svc 没有CLUSTER-IP 
  - 在pod 中 headless svc dns 查询返回svc 对应pod ip
  - 在pod 中 普通 svc dns 查询返回svc CLUSTER-IP
