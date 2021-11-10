# 手动标记节点为不可调度、 排空节点
- kubectl cordon <node> 标记节点为不可调度(但对其上的 pod 不做 任何事)。
- kubectl drain <node> 标记节点为不可调度， 随后疏散其上所有 pod。
- 两种情形下， 在你用 kubectl uncordon <node> 解除节点的不可调度 状态之前， 不会有新pod被调度到该节点。
