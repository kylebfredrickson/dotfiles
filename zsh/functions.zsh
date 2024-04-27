function mtcd() {
    local dir=$1;
    local file=$2;

    hdiutil attach $dir/$file &> /dev/null && cd /Volumes/${file%.dmg};
}

function um() {
    local name=$1;
    local olddir=$(pwd);

    cd $HOME
    local volume=$(hdiutil info | grep "/Volumes/$name" |\
        sed "s/\([^[:space:]]*\).*/\1/")
    hdiutil detach $volume
}
