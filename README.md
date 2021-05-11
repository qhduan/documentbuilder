
```
docker build -t qhduan/docbuilder .
docker push qhduan/docbuilder
```

```
docker run -it --rm --name docbuilder -p 3000:3000 qhduan/docbuilder
```


```
docker run -d --restart=always --name docbuilder -p 3000:3000 qhduan/docbuilder
```
