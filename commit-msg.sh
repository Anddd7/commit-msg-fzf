gcfzf() {
  commit_message="$1"

  # search the config file from bottom to top
  config_file=".commit-template"
  current_dir=$(pwd)
  while [ "$current_dir" != "/" ]; do
    if [ -f "$current_dir/$config_file" ]; then
      break
    fi
    current_dir=$(dirname "$current_dir")
  done

  # load prefixes from config file
  if [ -f "$current_dir/$config_file" ]; then
    prefixes=($(<"$current_dir/$config_file"))
  else
    echo "Config file not found. Using default prefixes."

    prefixes=("feat" "fix" "chore" "docs" "style" "test")
  fi

  # select via fzf
  selected_prefix=$(printf "%s\n" "${prefixes[@]}" | fzf)

  # 如果用户没有选择前缀，退出脚本
  if [ -z "$selected_prefix" ]; then
    selected_prefix="chore"
  fi

  final_commit_message="$selected_prefix: $commit_message"

  echo "Final commit message: $final_commit_message"

  git commit -m "$final_commit_message"
}