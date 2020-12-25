unset AUTO_ENV_PATH

# Remove leading and trailing whitespace characters
function __trim() {
  local val="$*"
  echo $val | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//'
}

# Check if value is not empty ar comment
function __not_empty_or_comment() {
  local val="$*"
  if [ -n "$val" ] && [[ ${val:0:1} != '#' ]]; then
    # 0 = true
    return 0
  else
    # 1 = false
    return 1
  fi
}

echo_yellow() {
  __echo_colored "93m" $*
}

echo_red() {
  __echo_colored "31m" $*
}

echo_green() {
  __echo_colored "32m" $*
}

__echo_colored() {
  local color=$1
  local text="${@:2}"
  echo -e "\e[$color$text\e[0m"
}

function auto_env() {
  local dir="$PWD/"
  local file=".auto-env"
  local full_path="${dir}${file}"
  local existing_env_str=""
  local new_env_str=""

  # If Exists file or symlinc and is not allready loaded
  if ([ -f "$full_path" ] || [ -L "$full_path" ])  && [[ "$AUTO_ENV_PATH" != "$full_path" ]]; then
    AUTO_ENV_PATH=${full_path}

    while read p; do
      trimmed_env=$(__trim $p)

      if __not_empty_or_comment $trimmed_env; then
        IFS='=' read -r key val <<< "$trimmed_env"

        new_env_str="$new_env_str $key=$(eval echo \"$val\")"

        # check if exist existing environment variable
        if [[ -v $key ]]; then
          # Save previous env variable value
          existing_env="$key"

          existing_env_str="$existing_env_str $key=${!existing_env}"
          export "___$key"="${!existing_env}"
        fi

        # Export env variables from file with expand
        export $key="$(eval echo \"$val\")"
      fi
    done < $full_path

    if [ ! -z "$existing_env_str" ]; then echo_green "EXISTING: $existing_env_str"; fi
    if [ ! -z "$new_env_str" ];      then echo_yellow "NEW:      $new_env_str";     fi
  fi

  # Unset env auto if navigate away from place where was .envs file
  if [[ -n "$AUTO_ENV_PATH" ]] && [[ "$AUTO_ENV_PATH" != "$full_path" ]]; then

    while read p; do
      trimmed_env=$(__trim $p)

      if __not_empty_or_comment $trimmed_env; then
        IFS='=' read -r key val <<< "$trimmed_env"

        existing_env_str="$existing_env_str $key=$(eval echo \"$val\")"

        # check if exist old environment variable
        if [[ -v "___$key" ]]; then
          # Set previous value
          existing_env="___$key"

          new_env_str="$new_env_str $key=${!existing_env}"
          export "$key"="${!existing_env}"
          unset "___$key"
        else
          unset $key
        fi
      fi
    done < $AUTO_ENV_PATH

    if [ ! -z "$existing_env_str" ]; then echo_green  "EXISTING: $existing_env_str"; fi
    if [ ! -z "$new_env_str" ];      then echo_yellow "NEW:      $new_env_str";      fi

    unset AUTO_ENV_PATH
  fi
}
