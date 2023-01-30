# Deploy Multi-docker Container with ALB
An automated bash script to deploy two `docker` containers with Nginx as application load balancer

## Tested Versions
- Ubuntu Server 22.04 LTS
- Nginx v1.23.3
- Docker v20.10.23 build 7155243
- Docker Compose v2.12.2
- Nginx latest as application load balancer

## Notes
Make sure you replace the `MACHINE_IP` with your current machine address. Make the code executable with `chmod +x multidockerautomation.sh`.

## Directory tree
```
.
├── ContainerA
│   ├── Dockerfile
│   └── index.html
├── ContainerB
│   ├── Dockerfile
│   └── index.html
└── docker-compose.yaml
```

## Output

| ![containerb](https://i.imgur.com/HHQ6dpN.png) |
| -------- |
| <center>Figure 01: `Container A` web access</center> |

| ![containera](https://i.imgur.com/m4qTMI6.png) |
| -------- |
| <center>Figure 02: `Container B` web access</center> |


## Thank you
