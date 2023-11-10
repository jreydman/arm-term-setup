# Sed filter

[example] with docker service observer

```bash
    $sed_command -e '/postgres: #service/,/#endservice/ {;s/# <Virtual stage>\(.*\)#stage-toggle/\1#stage-toggle/;}' -e '/maildev: #service/,/#endservice/ {;s/# <Virtual stage>\(.*\)#stage-toggle/\1#stage-toggle/;}' "$PARENT_DIR"/"$DOCKER_PATH_LOCAL"/docker-compose.yaml
```

[example] check apparat system util

```bash
if sed --version > /dev/null 2>&1; then
    echo "Info! Setting [sed] command style: GNU"
    sed_command="sed -i"
else
    echo "Info! Setting [sed] command style: BSD"
    sed_command="sed -i ''"
fi
```