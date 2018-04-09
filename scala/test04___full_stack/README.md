

```
docker run --name test04-db -p 65432:5432 -e POSTGRES_PASSWORD=testpassword -e POSTGRES_USER=developer -e POSTGRES_DB=test04_db -d postgres:latest
```
