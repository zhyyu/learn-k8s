# pod metadata(ip node name...) to pod via env
- kubectl create -f downward-api-env.yaml

# pod metadata to pod via volume
- kubectl create -f downward-api-volume.yaml

---
# 与 Kubernetes API 服务器交互
- api 服务器地址
  - kubectl cluster-info 
    - https 接口， 难以操作
- proxy
  - kubectl proxy (proxy 作为一个后台进程， 和api server 交互, 可简化https 交互过程)
  - curl localhost:8001 (查询所有api)
  - curl localhost:8001/apis/batch （查询api 版本）
  - curl localhost:8001/apis/batch/v1 （查询指定版本操作）
  - curl localhost:8001/apis/batch/v1/jobs （查询所有jobs， 所有命名空间）
  - curl localhost:8001/apis/batch/v1/namespaces/default/jobs/my-first-job01 (指定命名空间与资源名称)
    - 和 kubectl get jobs.batch my-first-job01 -o json 相同

# 从pod 内部与api 服务器进行交互
- kubectl create -f curl-pod.yaml (创建 curl pod)
- kubectl get svc (default 命名空间下 kubernetes 服务， 代表api 服务器， https)
- export CURL_CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
- export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
- opt: 注意403 （RBAC 原因）
  - kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default （验证）
  - kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts （未验证）
- curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/$NS/pods
