## Dart Bash Completion

Copy contents of `dart-bash-completion.sh` file to `~/.bash_completion`.  
open new terminal and try auto completion.


```sh
bash$ dart --version
Dart SDK version: 2.17.1 (stable) (Tue May 17 17:58:21 2022 +0000) on "linux_x64"

bash$ dart [tab]
analyze   create    doc       format    pub       test      
compile   devtools  fix       migrate   run 

bash$ dart pub [tab]
add        deps       get        login      outdated   remove     upgrade    
cache      downgrade  global     logout     publish    token      

bash$ dart pub add -[tab]
--dev            --git-ref        --no-offline     --precompile     -h
--directory=     --git-url        --no-precompile  --sdk=           -n
--dry-run        --help           --offline        -C               
--git-path       --hosted-url     --path           -d 
```

* *dart command execution a bit slow to complete ...*
