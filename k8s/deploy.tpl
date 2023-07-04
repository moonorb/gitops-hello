apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
  labels:
    app: hello
spec:
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: registry.moonorb.cloud:5015/gitopshello:GIT_COMMIT
        ports:
        - containerPort: 8000
