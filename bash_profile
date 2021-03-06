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

# TODO: Make more path independent
source /Users/aboltart/.dotfiles/bash/functions/gem_home_auto.sh
source /usr/local/share/chruby/auto.sh

##############################
# Configure to autoload project specific envs
##############################
source /Users/aboltart/.dotfiles/bash/functions/auto_env.sh

# Set default ruby
chruby $DEFAULT_RUBY

# Overide builtin to execute auto commands when change directories
function cd {
  builtin cd "$@" && trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto && gem_home_auto && auto_env' DEBUG
}
