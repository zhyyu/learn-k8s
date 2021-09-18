# 使用 kubectl create 来创建 pod
- kubectl create -f my-first-image-test.yaml

# 得到运行中 pod 的完整定义
- kubectl get po my-first-image-pod -o yaml

# 使用 kubectl logs 命令获取 pod 日志
- kubectl logs my-first-image-pod

# 将本地网络端口转发到 pod 中的端口
- kubectl port-forward my-first-image-pod 8099:8088
  - 另一终端可执行： curl localhost:8099

# 展示 label
- kubectl get po --show-labels 
- kubectl get pod -L creation_method,env

# 添加 label
- kubectl label po my-first-image-pod creation_method=manual

# 修改 label
- kubectl label po my-first-image-pod-v2 env=debug --overwrite

# 使用标签选择器列出pod
- kubectl get po -l creation_method=manual
- kubectl get po -l env
- kubectl get po -l '!env'
- kubectl get po -l creation_method=manual,env=debug

# 获取所有命名空间
- kubectl get namespaces

# 指定命名空间查询pod
- kubectl get po --namespace kube-system
- kubectl get po -n kube-system

# 创建namespace
- kubectl create -f namespace-test.yaml
- kubectl create namespace my-namespace2

# 在指定namespace 中创建资源
- kubectl create -f my-first-image-test.yaml -n my-namespace1
- 或者 yaml metadata 中指定namespace

# 查看kubectl 上下文（包含当前namespace）
- kubectl config get-contexts

# 修改上下文namespace
- kubectl config set-context --current --namespace my-namespace1

# 删除pod
- kubectl delete po my-first-image
- 使用标签选择器删除 pod
  - kubectl delete po -l creation_method=manual
- 通过删除整个命名空间来删除 pod(下所有pod 亦删除)
  - kubectl delete namespaces my-namespace1
- 删除命名空间中的所有 pod，但保留命名空间
  - kubectl delete po --all
- 删除命名空间下所有资源 （包括rc service 等）
  - kubectl delete all --all

# explain
- kubectl explain pods (解释pods yaml 字段含义)
  - kubectl explain pods.metadata.labels
