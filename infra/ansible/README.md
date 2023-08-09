```shell
ansible all -m ping --private-key=id_rsa -i hosts
```

~/.ssh/config


```shell
Host github.com
    Hostname github.com
    IdentityFile ~/.ssh/id_rsa.github
    IdentitiesOnly yes
```
add to ./ssh/id_rsa.github
```shell
PRIVATE KEY
```

```
chmod 400 ~/.ssh/id_rsa.github
```
