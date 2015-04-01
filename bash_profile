if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# setjdk 1.7
# setjdk 1.7.0_51
function setjdk() {
  if [ $# -ne 0 ]; then
    removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
    if [ -n "${JAVA_HOME+x}" ]; then
      removeFromPath $JAVA_HOME
    fi
    export JAVA_HOME=`/usr/libexec/java_home -v $@`
    export PATH=$JAVA_HOME/bin:$PATH
  fi
}
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

##############################
# Configure chruby
##############################
source /usr/local/share/chruby/chruby.sh
# Configure gem_home (https://github.com/postmodern/gem_home)
source /usr/local/share/gem_home/gem_home.sh

##############################
# Configure to autoload ruby and gem home
##############################
source /Users/aboltart/.dotfiles/bash/completions/gem_home_auto.sh
source /usr/local/share/chruby/auto.sh
