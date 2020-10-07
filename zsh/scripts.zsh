function gitignore() {
    ROOT = $(git rev-parse --show-toplevel)
    if [$?==0]; then
        echo -e $@ >> ROOT/.gitignore
    else 
        return $?
    fi
    return 0;
}