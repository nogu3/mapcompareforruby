1. run dokcer

```
docker run -it --mount type=bind,src=./src,dst=/home/src -w /home/src ruby:3.2.2 bash 
```