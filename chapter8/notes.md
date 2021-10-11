# pod metadata(ip node name...) to pod via env
- kubectl create -f downward-api-env.yaml

# pod metadata to pod via volume
- kubectl create -f downward-api-volume.yaml

---
# 与 Kubernetes API 服务器交互
