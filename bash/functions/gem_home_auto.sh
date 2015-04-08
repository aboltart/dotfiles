unset GEM_HOME_AUTO_PATH

function gem_home_auto() {
  if ! type gem_home > /dev/null 2>&1; then
    echo -e "\033[0;33m gem_home not installed or loaded \033[0m"
  fi

  local dir="$PWD/" gem_home_path
  if { read -r gem_home_path <"$dir/.gem-home"; } 2>/dev/null || [[ -n "$gem_home_path" ]]; then
    if [[ "$gem_home_path" == "$GEM_HOME_AUTO_PATH" ]]; then return
    else
      GEM_HOME_AUTO_PATH="$gem_home_path"
      echo -e "\033[1;33m Use gems from $dir$gem_home_path \033[0m"
      gem_home "$gem_home_path"
    fi
  fi


  # Unset gem_home if navigate away from place where was .gem-home file
  if [[ -n "$GEM_HOME_AUTO_PATH" ]] && [[ ! -n "$gem_home_path" ]]; then
    unset GEM_HOME_AUTO_PATH

    ###################################
    # SET default gem home
    #
    local ruby_engine ruby_version gem_dir

    eval "$(ruby - <<EOF
puts "ruby_engine=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "ruby_version=#{RUBY_VERSION};"
EOF
)"

    gem_dir="$HOME/.gem/$ruby_engine/$ruby_version"

    [[ "$GEM_HOME" == "$gem_dir" ]] && return

    export GEM_HOME="$gem_dir"
    export GEM_PATH="$gem_dir${GEM_PATH:+:}"
    export PATH="$gem_dir/bin${PATH:+:}$PATH"

  fi
}

if [ ! -f /usr/local/share/chruby/auto.sh ]; then
  if [[ -n "$ZSH_VERSION" ]]; then
   if [[ ! "$preexec_functions" == *gem_home_auto* ]]; then
     preexec_functions+=("gem_home_auto")
   fi
  elif [[ -n "$BASH_VERSION" ]]; then
    trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && gem_home_auto' DEBUG
  fi

# else
#
# If "/usr/local/share/chruby/auto.sh" file exists then need to make following changes
#
#    trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto && gem_home_auto' DEBUG
fi
